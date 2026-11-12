# Library reviews

This chapter reviews the seven most important projects in depth. The reviews
are based on **source code**, not READMEs. None were run against the live
API. The full list of projects is in [Appendix A](../appendix/a-catalog.md).

## At a glance

| | tinder-api-ts | tinder.py | pynder | tinder-mcp-server | OpenAPI schema | 2018 reference | TinderSharp |
| --- | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| Language | TypeScript | Python | Python | TypeScript | OpenAPI | Markdown + Python | C# |
| Last push | 2026-07 | 2023-11 | 2021-06 | 2025-05 | 2025-03 | 2023-01 | 2022-12 |
| Current login flow | ✅ `/v3` | ➖ token only | ❌ Facebook | ❌ `/v2` | ➖ `/v2` | ❌ | ❌ |
| Types / models | ✅ | ✅ | ✅ | ✅ Zod | ✅ schema | ❌ | ✅ |
| Error types | ✅ | ✅ | ➖ | ✅ | – | – | ➖ |
| Rate limiting / retries | ❌ | ➖ 3 tries on 5xx | ❌ | ✅ | – | – | ❌ |
| Tests | ✅ | ✅ | ❌ | ✅ | – | – | ❌ |
| License | MIT | GPL-3.0 | Custom | Unclear | None | MIT | Unlicense |
| Grade | **A** | **B** | **C** (historical) | **C** | **B** (reference) | **B** (historical) | **C** |

---

## 1. tinder-api-ts

**What:** A TypeScript client for Node.js and Deno, published on npm as
`tinder-api-ts` and on JSR.

**Why it matters:** Of all the projects examined, it is the **only** open
code that implements the post-2024 protobuf login flow.

| Feature | Status |
| --- | --- |
| SMS login + email verification (`LoginSession`) | ✅ `/v3/auth/login` |
| CAPTCHA detection | ✅ Throws `TinderCaptchaRequiredError`; never tries to solve it |
| Reading the profile (with scopes) | ✅ |
| Preference updates (both endpoints) | ✅ With km/mile conversion |
| Recommendations, like, pass, Super Like | ✅ |
| Matches, reading and sending messages | ✅ |
| Location (`/v2/meta`), Boost | ✅ |
| Proxy support | ✅ Deno `HttpClient` / undici `ProxyAgent` |
| Rate limiting, retries | ❌ Left to the caller |

**Code quality:** All endpoints live in a single `TINDER_ROUTER` constant.
There is one `request()` function, and HTTP errors are split into types.
Filtered search uses a `try/finally`-style pattern to restore preferences.
The protobuf encoder is small and hand-written (85 lines), so a schema
change could break it.

**Watch out:** The default `locale` is `es-ES`. For English responses, pass
`locale: "en"` on each call or set `baseOptions.defaultLocale`.

```ts
import { TinderAPI } from "tinder-api-ts";

const tinder = new TinderAPI({
  xAuthToken: process.env.TINDER_AUTH_TOKEN!,
  baseOptions: { defaultLocale: "en" },
});

const { data } = await tinder.getMatches({ count: 20, message: 1 });
console.log(data.data.matches.length, "matches");
```

**Verdict:** The best starting point for a new JS/TS project. It is MIT
licensed, so you can read it and adapt it into your own client.

---

## 2. tinder.py

**What:** An `asyncio` Python client inspired by discord.py, published on
PyPI as `tinder.py`, with documentation on Read the Docs.

| Feature | Status |
| --- | --- |
| Login | With a token copied from the browser |
| Recommendations (`/v2/recs/core`), like, pass | ✅ |
| Matches, unmatch | ✅ |
| Sending messages | ⚠️ **Broken** (see below) |
| Like previews (`fast-match`), `my-likes`, `explore` | ✅ |
| WebSocket | ➖ Connects and pings; doesn't decode events |
| Location (`/v2/meta`) | ✅ |
| Rate limiting | ➖ No `429` handling; 3 tries with growing waits on `500/502` only. `403` and `404` have their own error types. |

**The bug:** `send_message` in `http.py`:

```python
payload = {"message", message}   # ❌ This is a set, not a dict
payload = {"message": message}   # ✅ Correct
```

The source also has a `TODO` comment listing unsupported endpoints, such as
`/v2/matches/{id}/messages` and `/like/{id}/super`.

**Verdict:** Good async architecture and models, but it hasn't been updated
since 2023. Because it is GPL-3.0, copying its code would make your project
GPL too. Borrow ideas from its design rather than its code.

---

## 3. pynder

**What:** The best-known Python client (600+ stars).

**Status:** Login depends on a Facebook token (`POST /auth`). Most endpoints
are unprefixed legacy paths (`/user/recs`, `/updates`, `/user/ping`). It has
not been updated since 2021. **Don't expect it to work today.**

**Value:** Its issue tracker is the richest record of API changes from 2015
to 2021. It is the first place to look when you want to know when and how an
endpoint changed.

**Verdict:** Historical reference. Don't use it in a new project.

---

## 4. tinder-mcp-server

**What:** According to its README, a Model Context Protocol (MCP) server for
the Tinder API.

**What the code shows:**

| Claim | Reality |
| --- | --- |
| "MCP server" | It does **not** use the official MCP SDK (`@modelcontextprotocol/sdk`). It is an **Express HTTP** server with `/mcp/...` routes. An MCP client such as Claude can't connect to it directly without a bridge. |
| Authentication | The old `/v2/auth/sms/...` and `/v2/auth/login/facebook` flows. No `/v3` flow. |
| CAPTCHA | Calls `/v2/auth/verify-captcha`, the opposite of the "stop" approach this book recommends. |
| License | `package.json` says MIT, but the repository has no LICENSE file |
| Setup | The clone URL in the README still contains a `yourusername` placeholder |
| Quality | Zod schemas, a rate limiter, a cache and an extensive test suite |

**Verdict:** Worth reading for its architecture (schema validation, caching,
rate limiting). Not a product you can use as is. For a real MCP integration,
write a small server on the official SDK that only exposes read-only tools
([chapter 12](12-your-own-client.md#notes-for-ai-agents-and-mcp)).

---

## 5. The OpenAPI schema

**What:** `tinder-api-swagger.yaml`, the **only OpenAPI schema** written for
the Tinder API. It can also be browsed as a web page.

**Strengths:** 39 path and method combinations, including endpoints found
nowhere else (account management, push, Instagram), plus practical notes:
OTP behavior, refresh token rotation, soft-block duration and the penalty
for repeated account deletion.

**Weaknesses:** Many endpoints have `summary: TODO`. Login is stuck in the
`/v2` era. There is no license file.

**Tip:** You can feed the schema to an OpenAPI generator (for example
`openapi-generator` or NSwag) to scaffold a typed client. Compare the result
with a current client, though: the `like` and `pass` methods differ.

---

## 6. The 2018 community reference

**What:** The most-starred (860+) endpoint document, from 2018–2019, with a
small Python wrapper.

**Value:** It documents things no other material covers: paid features
(`hide_age`, `blend`, Passport), Spotify, job and school, and usernames. Much
of the community's shared vocabulary comes from it.

**Watch out:** The content stops in 2018–2019. Its `GET /like/{id}` is now
`POST`, and `/user/ping` is now `/v2/meta`.

---

## 7. TinderSharp

**What:** A C# wrapper for .NET Standard 2.0 (Unlicense, i.e. public
domain).

**Status:** Not updated since 2022. Its login models belong to the Facebook
and `/v2` SMS era (`FacebookAuthentication`, `SMSAuthentication`). There is
no test project, only a `SandBox` console app. It includes a custom JSON
converter for match responses (`MatchResponseConverter`).

**Value:** The only serious example in the .NET ecosystem. Because it is
Unlicense, you can freely take its model classes into a modern .NET 8+
client built on `System.Text.Json` and `HttpClient`.
[Chapter 12](12-your-own-client.md) gives you a skeleton for exactly that.

---

## Choosing

```text
Language?
├── TypeScript / Node / Deno ──▶ tinder-api-ts
├── Python ──────────────────▶ tinder.py (patch the message bug)
│                              or generate a client from the OpenAPI schema
├── C# / .NET ───────────────▶ Your own client (chapter 12)
│                              + TinderSharp models
└── Just understanding it ───▶ This book
```
