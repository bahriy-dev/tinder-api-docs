# Anatomy of a request

## The basics

| | |
| --- | --- |
| Base URL | `https://api.gotinder.com` |
| Transport | HTTPS only |
| Body format | JSON (except login, which uses protobuf) |
| Credential | The `X-Auth-Token` header |
| Language | The `?locale=en` query parameter |

## Example request

```http
GET /v2/recs/core?locale=en&duos=0 HTTP/1.1
Host: api.gotinder.com
X-Auth-Token: 3f9c2a1e-…
Content-Type: application/json
Accept: application/json
platform: web
tinder-version: <Tinder Web version>
persistent-device-id: 7b1d…
```

> Take the version values from your own browser's Network tab. For example,
> in 2023 a web client sent `tinder-version: 2.54.0`, which is long outdated.

## Headers

| Header | Required? | Notes |
| --- | :---: | --- |
| `X-Auth-Token` | ✅ | The session token. Every current client sends it. |
| `Content-Type: application/json` | Mostly | Older material says it should **not** be sent with the legacy `GET` requests to `/like/{id}` and `/pass/{id}`. Current clients send it on every request. |
| `platform` | Recommended | `web`, `ios` or `android`. Real clients always send it. |
| `tinder-version`, `app-version` | Recommended | The app version. A very old version may be rejected or flagged. |
| `persistent-device-id` | Recommended | The device ID. On the web it is the `TinderWeb/uuid` value. |
| `User-Agent` | Recommended | Should match the platform. |
| `x-supported-image-formats` | Optional | `webp,jpeg`. Affects the format of photo URLs. |

> **Why it matters:** Requests with missing or inconsistent headers can be
> flagged as automation. That can lead to a CAPTCHA, a `403` or a ban.
> Define your headers in **one place** and keep them close to what the
> browser actually sends.

## Query parameters

| Parameter | Where | Notes |
| --- | --- | --- |
| `locale` | Almost everywhere | The language of text in the response (`en`, `tr`, `es-ES`) |
| `include` | `GET /v2/profile` | Which profile sections to return (see [chapter 4](04-profile.md)) |
| `count` | `/v2/matches`, `/v2/matches/{id}/messages` | Page size. Up to 100 for matches. |
| `message` | `/v2/matches` | `1`: matches you have messaged, `0`: new matches |
| `s_number` | `/like`, `/pass` | The `s_number` from the recommendation card (see [chapter 6](06-interactions.md)) |

> **Pagination:** None of the clients examined use a page token. They all
> fetch a single list capped by `count`. For longer lists, check the extra
> fields in the response's `data` object in your browser's Network tab.

## Response envelope

`/v2/...` endpoints usually share the same envelope:

```json
{
  "meta": { "status": 200 },
  "data": { "...": "..." }
}
```

Unprefixed legacy endpoints (such as `/like/{id}`) return a flat object with
no envelope:

```json
{ "match": false, "likes_remaining": 99, "status": 200 }
```

> **Tip:** Normalize both shapes in your client with a single `unwrap()`
> function: return `data` if present, otherwise the body itself.

## HTTP status codes

| Code | Meaning | Recommended behavior |
| --- | --- | --- |
| `200` | Success | – |
| `400` | Missing or invalid parameter | Fix the request; don't retry |
| `401` | Token invalid or expired | Refresh it; if that fails, log in again |
| `403` | Not allowed: premium feature, suspicious traffic or CAPTCHA | **Stop.** If it is a premium error, tell the user. Otherwise turn the automation off. |
| `404` | Endpoint or resource not found | The API may have changed; compare with a current client |
| `429` | Rate limited | Exponential backoff (2 s, 4 s, 8 s…) with a capped number of retries |
| `5xx` | Server error | At most 1–2 retries after a short wait |

A good model is to split errors into types:

| Error type | When it happens |
| --- | --- |
| `HttpError` | Generic HTTP error carrying `status` and `body` |
| `PremiumRequiredError` | A `403` on a preference update: a subscription is required |
| `NoBoostAvailableError` | No Boost left |
| `CaptchaRequiredError` | Login asked for a CAPTCHA |
| `EmailRequiredError` | Login asked for email verification |

## Pace and politeness

Tinder does not publish its rate limits. Safe assumptions based on community
experience:

- Wait **at least 1–3 seconds** between requests, with a little random
  jitter.
- Send **one request at a time**.
- **Cache** responses such as `GET /v2/profile` and `GET /v2/meta`. They
  rarely change.
- Free accounts have a daily like quota. Track what is left through the
  `likes_remaining` field in every `/like` response.
- When the recommendation pool runs out (an empty `results`), Tinder may
  apply a temporary "soft block" that reportedly lasts about 30 minutes.
