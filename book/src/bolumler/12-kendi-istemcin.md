# Kendi istemcini tasarlamak

Hazır kütüphaneler ya eskimiş ya da senin ihtiyacına tam uymuyor olabilir.
Bu bölüm, kendi hesabın için küçük, **güvenli ve bakımı kolay** bir istemci
yazarken izlenecek ilkeleri ve iki dilde başlangıç iskeletini veriyor.

## Tasarım ilkeleri

| İlke | Neden | Nasıl |
| --- | --- | --- |
| **Önce okuma** | Okuma işlemleri hesabı değiştirmez, risk düşüktür | İstemciyi `readOnly: true` ile başlat. Yazma metotları ayrıca açılsın. |
| **Tek giriş noktası** | Başlıklar, hatalar, hız sınırı tek yerde yönetilir | Bütün istekler tek bir `request()` fonksiyonundan geçsin |
| **Yavaş ve tek sıra** | Otomasyon algılamasını ve hız sınırını önler | İstekler arasında 1,5–3 sn ve rastgele sapma, eş zamanlı istek yok |
| **Dur sinyaline uy** | `403` ve CAPTCHA yükseltilmiş risk demektir | Bu hatalarda devre kesici açılsın, insan müdahalesi gereksin |
| **Şemaya güvenme** | API haber vermeden değişir | Yanıtları çalışma zamanında doğrula (Zod, `System.Text.Json` + null kontrolleri) |
| **Sırları koru** | Token hesabın anahtarıdır | Ortam değişkeni veya anahtar zinciri; loglarda maskeleme |
| **Geri alınamaz işlemleri kilitle** | Hesap silme ve eşleşme kaldırma geri alınamaz | Bu yolları tanımlama veya açık onay iste |

## Mimari

```text
┌──────────────┐    ┌──────────────┐    ┌───────────────┐    ┌───────────┐
│ Senin kodun  │──▶ │ TinderClient │──▶ │ RequestGate   │──▶ │  fetch /  │
│ (UI, CLI…)   │    │ (tipli API)  │    │ • hız sınırı  │    │ HttpClient│
└──────────────┘    └──────────────┘    │ • devre kesici│    └───────────┘
                           │            │ • yeniden dene│
                           ▼            └───────────────┘
                    ┌──────────────┐
                    │ Şema doğrula │
                    └──────────────┘
```

## TypeScript iskeleti

Node.js 20+ veya Deno. Harici bağımlılık olarak yalnızca isteğe bağlı `zod`
kullanılıyor.

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
    if (!opts.token) throw new Error("TINDER_AUTH_TOKEN eksik");
  }

  // --- Okuma ---
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

  // --- Yazma (readOnly: false gerektirir) ---
  sendMessage(matchId: string, message: string) {
    this.assertWritable();
    return this.request("POST", `/user/matches/${encodeURIComponent(matchId)}`, {}, { message });
  }

  // --- Altyapı ---
  private assertWritable() {
    if (this.opts.readOnly !== false) {
      throw new Error("İstemci salt okunur. Yazmak için readOnly: false ver.");
    }
  }

  private request(
    method: "GET" | "POST" | "DELETE",
    path: string,
    query: Record<string, string> = {},
    body?: unknown,
  ): Promise<unknown> {
    // İstekleri sıraya koy: aynı anda tek istek.
    const run = async () => {
      if (this.blocked) throw new TinderBlockedError("Devre açık: önceki 403/CAPTCHA");
      await this.pace();

      const url = new URL(path, BASE);
      url.search = new URLSearchParams({ locale: this.opts.locale ?? "tr", ...query }).toString();

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

      if (res.status === 401) throw new TinderAuthError("Token geçersiz veya süresi dolmuş");
      if (res.status === 403 || res.status === 429) {
        this.blocked = true; // İnsan bakana kadar dur.
        throw new TinderBlockedError(`HTTP ${res.status}: otomasyon durduruldu`);
      }
      if (!res.ok) throw new Error(`HTTP ${res.status}: ${await res.text()}`);

      const json = (await res.json()) as { data?: unknown };
      return json.data ?? json; // v2 zarfı veya düz nesne
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

Kullanımı:

```ts
const client = new TinderClient({ token: process.env.TINDER_AUTH_TOKEN! });
const matches = await client.matches(20);
```

> **Not:** `429` hatasında burada da devre kesiliyor. Bilinçli olarak
> temkinli bir seçim. Kişisel kullanımda hız sınırına takıldıysan zaten
> fazla hızlı gidiyorsun demektir.

## C# / .NET 8 iskeleti

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

    public TinderClient(string token, string locale = "tr", TimeSpan? minDelay = null)
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
        if (ReadOnly) throw new InvalidOperationException("İstemci salt okunur. ReadOnly = false ile oluştur.");
        return SendAsync(HttpMethod.Post, $"/user/matches/{Uri.EscapeDataString(matchId)}", new { message }, ct);
    }

    private async Task<JsonElement> SendAsync(HttpMethod method, string pathAndQuery, object? body, CancellationToken ct)
    {
        await _gate.WaitAsync(ct);
        try
        {
            if (_blocked) throw new TinderBlockedException("Devre açık: önceki 403/429");

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
                throw new TinderBlockedException($"HTTP {(int)response.StatusCode}: otomasyon durduruldu");
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

Kullanımı:

```csharp
var token = Environment.GetEnvironmentVariable("TINDER_AUTH_TOKEN")
    ?? throw new InvalidOperationException("TINDER_AUTH_TOKEN eksik");
using var tinder = new TinderClient(token);
var matches = await tinder.GetMatchesAsync(count: 20);
Console.WriteLine(matches.GetProperty("matches").GetArrayLength());
```

## Yanıtları doğrulamak

API şeması değiştiğinde sessizce yanlış veri işlemek yerine hemen hata
almak istersin. TypeScript'te Zod ile:

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

`.passthrough()` bilinmeyen alanlara izin verir; yalnızca **gerçekten
kullandığın** alanları zorunlu tut.

## Test stratejisi

Canlı API'ye karşı otomatik test yazma. Hem hesabın için risk hem de testler
güvenilmez olur. Bunun yerine:

1. Tarayıcının Network sekmesinden **kendi** yanıtlarını kaydet.
2. Kişisel verileri (ad, fotoğraf URL'si, mesaj, kimlik) sahte değerlerle
   değiştir.
3. Bu "fixture" dosyalarıyla ayrıştırma ve iş mantığını test et.
4. HTTP katmanını taklit et (`msw`, `nock`, .NET'te `HttpMessageHandler`).

## Yapay zekâ ajanları için MCP notları

Bir yapay zekâ ajanına Tinder erişimi vermek istiyorsan:

- Resmî **MCP SDK**'sını kullan (`@modelcontextprotocol/sdk`,
  `ModelContextProtocol` NuGet paketi).
- Yalnızca **okuma araçları** sun: `list_matches`, `read_messages`,
  `get_profile`.
- Mesaj göndermek gibi yazma işlemlerini sunacaksan, her çağrıda **insan
  onayı** iste. Ajan yalnızca taslak hazırlasın.
- Beğenme, geçme ve toplu işlemleri **hiç sunma**.
- Karşı tarafın mesajlarını ajanın bağlamına koymanın gizlilik sonuçlarını
  düşün ([13. bölüm](13-sorumlu-kullanim.md)).

---

**Esinlenilen kaynaklar:** [tinder-api-ts](https://github.com/Miguelo981/tinder-api)
(tek giriş noktası, hata türleri), [tinder.py](https://github.com/tiagovla/tinder.py)
(yeniden deneme), [tinder-mcp-server](https://github.com/glassBead-tc/tinder-mcp-server)
(şema doğrulama).
