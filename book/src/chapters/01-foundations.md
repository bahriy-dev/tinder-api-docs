# Understanding an unofficial API

## What "unofficial API" means

Tinder's iOS, Android and web apps all get their data from the same server:
`api.gotinder.com`. The contract between the apps and that server is an API,
but it was never opened up to outsiders:

- **There is no documentation.** Everything known comes from developers who
  watched the traffic and took notes.
- **There is no versioning guarantee.** An endpoint can be removed or change
  shape without a day's notice.
- **There is no access program.** There are no API keys, OAuth apps or
  developer portal. The only credential is a normal user session.

These three facts frame the rest of the book. Every statement here means
"this was observed at a given time in a given client".

## A short history

| Period | What happened | Effect |
| --- | --- | --- |
| 2014 | A widely shared gist published the first comprehensive endpoint list. | It became the common ancestor of almost every later project. |
| 2014–2017 | The first libraries appeared (`pynder`, `tinderjs`, `tinder_pro`). Login used a Facebook token. | 🔴 Most libraries from this era no longer work. |
| 2018 | An updated community reference documented the `/v2/...` endpoints and SMS login. | It became the most cited endpoint table. |
| 2019–2020 | Facebook Account Kit shut down. Tinder moved to its own phone OTP flow (`/v2/auth/sms/...`) and added CAPTCHA (Arkose Labs). | Automated login got harder. The community moved to copying the token from the browser. |
| 2021–2023 | An async Python client, a Java wrapper and the first OpenAPI schema appeared. | The API got its first machine-readable description. |
| 2024–2026 | Login moved to **protobuf** over `/v3/auth/login`. The first MCP server was published. | The app API stayed largely JSON. The login layer is what changed. |

## Architecture overview

```text
┌────────────────────┐   HTTPS + JSON     ┌─────────────────────────┐
│  Client            │ ─────────────────▶ │ api.gotinder.com        │
│  (app / web /      │  X-Auth-Token      │  /v2/profile, /v2/recs, │
│   library)         │ ◀───────────────── │  /like, /v2/matches …   │
│                    │                    └─────────────────────────┘
│                    │   HTTPS + protobuf ┌─────────────────────────┐
│                    │ ─────────────────▶ │ /v3/auth/login          │
│                    │  (login flow)      │  SMS, email, CAPTCHA    │
│                    │                    └─────────────────────────┘
│                    │   WebSocket        ┌─────────────────────────┐
│                    │ ◀════════════════▶ │ keepalive.gotinder.com  │
└────────────────────┘  (new messages…)   └─────────────────────────┘
```

There are three separate layers:

1. **The app API (REST + JSON).** Profile, recommendations, likes, matches
   and messages. Most of this book is about this layer.
2. **The authentication gateway (protobuf).** Phone login, OTP, email
   verification and CAPTCHA. Covered in [chapter 2](02-authentication.md).
3. **The real-time channel (WebSocket).** Notifications for new messages and
   matches. Covered in [chapter 7](07-matches-messages.md#the-real-time-channel-websocket).

## Versioning

Tinder's paths follow no consistent versioning scheme:

| Prefix | Example | Status |
| --- | --- | --- |
| *(none)* | `/like/{id}`, `/pass/{id}`, `/user/matches/{id}`, `/boost` | 🟢 They look old but are still used by 2026 clients |
| `/v1/` | `/v1/activity/feed` | 🔴 Rare |
| `/v2/` | `/v2/profile`, `/v2/recs/core`, `/v2/matches`, `/v2/meta` | 🟢 The main app API |
| `/v3/` | `/v3/auth/login` | 🟢 Login only |

Rule of thumb: **if a `/v2` version exists, use it.** Unprefixed paths are
still the primary route only for single-purpose actions such as liking,
passing, sending a message and boosting.

## How each fact is checked

For every endpoint this book asks three questions:

1. **Who documented it?**
2. **Which client code actually calls it?**
3. **When was it last seen?**

An endpoint that only appears in documentation, and in no current client
code, is marked 🟡 or 🔴.
