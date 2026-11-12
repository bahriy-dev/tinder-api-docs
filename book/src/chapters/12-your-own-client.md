# Designing your own client

Existing libraries may be outdated or not quite fit your needs. This
chapter gives you the principles for writing a small, **safe and
maintainable** client for your own account, plus starter skeletons in two
languages.

## Design principles

| Principle | Why | How |
| --- | --- | --- |
| **Read first** | Reads don't change the account, so the risk is low | Start the client with `readOnly: true`. Write methods must be enabled explicitly. |
| **One entry point** | Headers, errors and rate limits are handled in one place | Route every request through a single `request()` function |
| **Slow and serial** | Avoids automation detection and rate limits | 1.5–3 s between requests plus random jitter, no concurrent requests |
| **Respect stop signals** | A `403` or CAPTCHA means elevated risk | Trip a circuit breaker on these errors and require a human to reset it |
| **Don't trust the schema** | The API changes without notice | Validate responses at runtime (Zod, `System.Text.Json` + null checks) |
| **Protect secrets** | The token is the key to your account | Environment variable or keychain; mask it in logs |
| **Lock irreversible actions** | Deleting the account or unmatching can't be undone | Don't define these routes, or require explicit confirmation |

## Architecture

```text
┌──────────────┐    ┌──────────────┐    ┌───────────────┐    ┌───────────┐
│ Your code    │──▶ │ TinderClient │──▶ │ RequestGate   │──▶ │  fetch /  │
│ (UI, CLI…)   │    │ (typed API)  │    │ • rate limit  │    │ HttpClient│
└──────────────┘    └──────────────┘    │ • breaker     │    └───────────┘
                           │            │ • retries     │
                           ▼            └───────────────┘
                    ┌──────────────┐
                    │ Validate     │
                    └──────────────┘
```

## TypeScript skeleton

Node.js 20+ or Deno. The only external dependency is the optional `zod`.

```ts
// tinder-client.ts
const BASE = "https://api.gotinder.com";

export class TinderBlockedError extends Error {}
export class TinderAuthError extends Error {}

type Options = {
  token: string;
  locale?: string;
  readOnly?: boolean;
  minDelayMs?: number;
};

export class TinderClient {
  private last = 0;
  private blocked = false;
  private queue: Promise<unknown> = Promise.resolve();

  constructor(private readonly opts: Options) {
    if (!opts.token) throw new Error("TINDER_AUTH_TOKEN is missing");
  }

  // --- Reads ---
  profile(include = ["user", "likes", "boost"]) {
    return this.request("GET", "/v2/profile", { include: include.join(",") });
  }
  recommendations() {
    return this.request("GET", "/v2/recs/core", { duos: "0" });
  }
  matches(count = 60, withMessages = true) {
    return this.request("GET", "/v2/matches", {
      count: String(count),
      message: withMessages ? "1" : "0",
    });
  }
  messages(matchId: string, count = 100) {
    return this.request("GET", `/v2/matches/${encodeURIComponent(matchId)}/messages`, {
      count: String(count),
    });
  }

  // --- Writes (require readOnly: false) ---
  sendMessage(matchId: string, message: string) {
    this.assertWritable();
    return this.request("POST", `/user/matches/${encodeURIComponent(matchId)}`, {}, { message });
  }

  // --- Plumbing ---
  private assertWritable() {
    if (this.opts.readOnly !== false) {
      throw new Error("The client is read-only. Pass readOnly: false to enable writes.");
    }
  }

  private request(
    method: "GET" | "POST" | "DELETE",
    path: string,
    query: Record<string, string> = {},
    body?: unknown,
  ): Promise<unknown> {
    // Queue requests: one at a time.
    const run = async () => {
      if (this.blocked) throw new TinderBlockedError("Circuit open: a previous 403/CAPTCHA");
      await this.pace();

      const url = new URL(path, BASE);
      url.search = new URLSearchParams({ locale: this.opts.locale ?? "en", ...query }).toString();

      const res = await fetch(url, {
        method,
        headers: {
          "X-Auth-Token": this.opts.token,
          "Content-Type": "application/json",
          Accept: "application/json",
          platform: "web",
        },
        body: body === undefined ? undefined : JSON.stringify(body),
      });

      if (res.status === 401) throw new TinderAuthError("Token invalid or expired");
      if (res.status === 403 || res.status === 429) {
        this.blocked = true; // Stop until a human looks.
        throw new TinderBlockedError(`HTTP ${res.status}: automation stopped`);
      }
      if (!res.ok) throw new Error(`HTTP ${res.status}: ${await res.text()}`);

      const json = (await res.json()) as { data?: unknown };
      return json.data ?? json; // v2 envelope or flat object
    };
    const next = this.queue.then(run, run);
    this.queue = next.catch(() => undefined);
    return next;
  }

  private async pace() {
    const min = this.opts.minDelayMs ?? 2000;
    const jitter = Math.random() * 1000;
    const wait = this.last + min + jitter - Date.now();
    if (wait > 0) await new Promise((r) => setTimeout(r, wait));
    this.last = Date.now();
  }
}
```

Usage:

```ts
const client = new TinderClient({ token: process.env.TINDER_AUTH_TOKEN! });
const matches = await client.matches(20);
```

> **Note:** The circuit also trips on `429`. That is a deliberately
> cautious choice: for personal use, hitting the rate limit means you are
> already going too fast.

## C# / .NET 8 skeleton

```csharp
// TinderClient.cs
using System.Net;
using System.Net.Http.Json;
using System.Text.Json;

public sealed class TinderBlockedException(string message) : Exception(message);

public sealed class TinderClient : IDisposable
{
    private readonly HttpClient _http;
    private readonly SemaphoreSlim _gate = new(1, 1);
    private readonly TimeSpan _minDelay;
    private DateTimeOffset _last = DateTimeOffset.MinValue;
    private bool _blocked;
    private readonly string _locale;

    public bool ReadOnly { get; init; } = true;

    public TinderClient(string token, string locale = "en", TimeSpan? minDelay = null)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(token);
        _locale = locale;
        _minDelay = minDelay ?? TimeSpan.FromSeconds(2);
        _http = new HttpClient { BaseAddress = new Uri("https://api.gotinder.com") };
        _http.DefaultRequestHeaders.Add("X-Auth-Token", token);
        _http.DefaultRequestHeaders.Add("platform", "web");
    }

    public Task<JsonElement> GetMatchesAsync(int count = 60, bool withMessages = true, CancellationToken ct = default) =>
        SendAsync(HttpMethod.Get, $"/v2/matches?count={count}&message={(withMessages ? 1 : 0)}", null, ct);

    public Task<JsonElement> GetMessagesAsync(string matchId, int count = 100, CancellationToken ct = default) =>
        SendAsync(HttpMethod.Get, $"/v2/matches/{Uri.EscapeDataString(matchId)}/messages?count={count}", null, ct);

    public Task<JsonElement> SendMessageAsync(string matchId, string message, CancellationToken ct = default)
    {
        if (ReadOnly) throw new InvalidOperationException("The client is read-only. Create it with ReadOnly = false.");
        return SendAsync(HttpMethod.Post, $"/user/matches/{Uri.EscapeDataString(matchId)}", new { message }, ct);
    }

    private async Task<JsonElement> SendAsync(HttpMethod method, string pathAndQuery, object? body, CancellationToken ct)
    {
        await _gate.WaitAsync(ct);
        try
        {
            if (_blocked) throw new TinderBlockedException("Circuit open: a previous 403/429");

            var wait = _last + _minDelay + TimeSpan.FromMilliseconds(Random.Shared.Next(0, 1000)) - DateTimeOffset.UtcNow;
            if (wait > TimeSpan.Zero) await Task.Delay(wait, ct);
            _last = DateTimeOffset.UtcNow;

            var separator = pathAndQuery.Contains('?') ? '&' : '?';
            using var request = new HttpRequestMessage(method, $"{pathAndQuery}{separator}locale={_locale}");
            if (body is not null) request.Content = JsonContent.Create(body);

            using var response = await _http.SendAsync(request, ct);
            if (response.StatusCode is HttpStatusCode.Forbidden or HttpStatusCode.TooManyRequests)
            {
                _blocked = true;
                throw new TinderBlockedException($"HTTP {(int)response.StatusCode}: automation stopped");
            }
            response.EnsureSuccessStatusCode();

            var json = await response.Content.ReadFromJsonAsync<JsonElement>(ct);
            return json.TryGetProperty("data", out var data) ? data : json;
        }
        finally
        {
            _gate.Release();
        }
    }

    public void Dispose()
    {
        _http.Dispose();
        _gate.Dispose();
    }
}
```

Usage:

```csharp
var token = Environment.GetEnvironmentVariable("TINDER_AUTH_TOKEN")
    ?? throw new InvalidOperationException("TINDER_AUTH_TOKEN is missing");
using var tinder = new TinderClient(token);
var matches = await tinder.GetMatchesAsync(count: 20);
Console.WriteLine(matches.GetProperty("matches").GetArrayLength());
```

## Validating responses

When the API schema changes, you want an immediate error rather than
silently processing the wrong data. In TypeScript, with Zod:

```ts
import { z } from "zod";

const Match = z.object({
  _id: z.string(),
  created_date: z.string(),
  person: z.object({ _id: z.string(), name: z.string() }).passthrough(),
}).passthrough();

const MatchesData = z.object({ matches: z.array(Match) });

const data = MatchesData.parse(await client.matches(20));
```

`.passthrough()` allows unknown fields. Only require the fields you
**actually use**.

## Testing strategy

Don't write automated tests against the live API. It puts your account at
risk and the tests will be flaky. Instead:

1. Save **your own** responses from the browser's Network tab.
2. Replace personal data (names, photo URLs, messages, IDs) with fake
   values.
3. Test parsing and business logic against these fixture files.
4. Mock the HTTP layer (`msw`, `nock`, or an `HttpMessageHandler` in .NET).

## Notes for AI agents and MCP

If you want to give an AI agent access to Tinder:

- Use the official **MCP SDK** (`@modelcontextprotocol/sdk`, or the
  `ModelContextProtocol` NuGet package).
- Expose **read-only tools** only: `list_matches`, `read_messages`,
  `get_profile`.
- If you expose writes such as sending messages, require **human
  approval** on every call. Let the agent only draft.
- **Never** expose like, pass or bulk actions.
- Think about the privacy implications of putting the other person's
  messages into the agent's context ([chapter 13](13-responsible-use.md)).

