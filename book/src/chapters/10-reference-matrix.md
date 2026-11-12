# Endpoint reference matrix

Every endpoint in this book in one place, with its status and the chapter
that covers it.

| Marker | Meaning |
| :-: | --- |
| 🟢 | Used by a client maintained in 2025–2026 |
| 🟡 | Only seen in 2020–2024 material |
| 🔴 | Pre-2020, very likely broken |
| 💳 | Paid subscription |
| ⚠️ | Irreversible |

## Authentication

| Method | Path | Status | Chapter |
| --- | --- | :-: | --- |
| POST | `/v3/auth/login` (protobuf) | 🟢 | [2](02-authentication.md) |
| POST | `/v2/auth/sms/send` | 🟡 | [2](02-authentication.md) |
| POST | `/v2/auth/sms/validate` | 🟡 | [2](02-authentication.md) |
| POST | `/v2/auth/login/sms` | 🟡 | [2](02-authentication.md) |
| POST | `/v2/auth/login/facebook` | 🔴 | [2](02-authentication.md) |
| POST | `/auth` (Facebook) | 🔴 | [2](02-authentication.md) |
| POST | `/v2/auth/verify-captcha` | 🟡 | [9](09-other.md) |
| POST | `/v2/auth/logout` | 🟡 | [9](09-other.md) |

## Profile and account

| Method | Path | Status | Chapter |
| --- | --- | :-: | --- |
| GET | `/v2/profile?include=…` | 🟢 | [4](04-profile.md) |
| POST | `/v2/profile` | 🟢 | [4](04-profile.md) |
| POST | `/v2/profile/user` | 🟢 💳 | [4](04-profile.md) |
| DELETE | `/v2/profile` ⚠️ | 🟡 | [4](04-profile.md) |
| GET / POST | `/profile` | 🔴 | [4](04-profile.md) |
| PUT / DELETE | `/profile/job`, `/profile/school` | 🔴 | [4](04-profile.md) |
| POST | `/v2/profile/job`, `/v2/profile/school` | 🟡 | [4](04-profile.md) |
| PUT / DELETE | `/profile/username` | 🔴 | [4](04-profile.md) |
| GET | `/profile/photos` | 🟡 | [4](04-profile.md) |
| DELETE | `/media` | 🟡 | [4](04-profile.md) |
| POST | `/v2/profile/email_settings` | 🟡 | [4](04-profile.md) |
| POST | `/v2/account/account-email/confirm` | 🟡 | [4](04-profile.md) |
| POST | `/v2/account/recovery/send` | 🟡 | [4](04-profile.md) |
| GET | `/user/{id}` | 🟡 | [4](04-profile.md) |

## Discovery and interactions

| Method | Path | Status | Chapter |
| --- | --- | :-: | --- |
| GET | `/v2/recs/core` | 🟢 | [5](05-discovery.md) |
| GET | `/user/recs` | 🔴 | [5](05-discovery.md) |
| GET | `/v2/explore` | 🟡 | [5](05-discovery.md) |
| POST (current) · GET (legacy) | `/like/{id}` | 🟢 | [6](06-interactions.md) |
| GET (current) · POST (2023 client) | `/pass/{id}` | 🟢 | [6](06-interactions.md) |
| POST | `/like/{id}/super` | 🟢 💳 | [6](06-interactions.md) |
| POST | `/boost` | 🟢 💳 | [6](06-interactions.md) |
| POST | `/message/{id}/like` | 🔴 | [6](06-interactions.md) |

## Matches and messages

| Method | Path | Status | Chapter |
| --- | --- | :-: | --- |
| GET | `/v2/matches` | 🟢 | [7](07-matches-messages.md) |
| GET | `/v2/matches/{id}/messages` | 🟢 | [7](07-matches-messages.md) |
| POST | `/user/matches/{id}` (send) | 🟢 | [7](07-matches-messages.md) |
| DELETE | `/user/matches/{id}` (unmatch) | 🟢 | [7](07-matches-messages.md) |
| GET | `/matches/{id}` | 🟡 | [7](07-matches-messages.md) |
| GET | `/message/{id}` | 🟡 | [7](07-matches-messages.md) |
| POST / GET | `/updates` | 🔴 | [7](07-matches-messages.md) |
| GET | `/ws/generate` + `wss://keepalive.gotinder.com/ws` | 🟡 | [7](07-matches-messages.md) |

## Location and meta

| Method | Path | Status | Chapter |
| --- | --- | :-: | --- |
| POST | `/v2/meta` (location + meta) | 🟢 | [8](08-location-meta.md) |
| GET | `/v2/meta`, `/meta` | 🔴 | [8](08-location-meta.md) |
| POST | `/user/ping` | 🔴 | [8](08-location-meta.md) |
| POST | `/passport/user/travel`, `/passport/user/reset` | 🔴 💳 | [8](08-location-meta.md) |
| GET | `/location/popular` | 🟡 | [8](08-location-meta.md) |

## Other

| Method | Path | Status | Chapter |
| --- | --- | :-: | --- |
| POST / GET | `/v2/fast-match/count` | 🟡 💳 | [9](09-other.md) |
| GET | `/v2/fast-match/teaser(s)` | 🟡 | [9](09-other.md) |
| GET | `/v2/fast-match/preview` | 🔴 | [9](09-other.md) |
| GET | `/v2/my-likes` | 🟡 | [9](09-other.md) |
| PUT | `/v2/push/notifications` | 🟡 | [9](09-other.md) |
| POST / DELETE | `/v2/push/devices/web/{code}` | 🟡 | [9](09-other.md) |
| GET | `/giphy/trending`, `/giphy/search` | 🔴 | [9](09-other.md) |
| GET / POST | `/instagram/…` | 🔴 | [9](09-other.md) |
| GET / PUT | `/v2/profile/spotify…` | 🔴 | [9](09-other.md) |
| POST | `/report/{id}`, `/report/user/{id}` | 🔴 | [9](09-other.md) |
| GET | `/user/{id}/common_connections` | 🔴 | [9](09-other.md) |
| POST | `/user/{id}/share` | 🔴 | [9](09-other.md) |
| GET | `/group/friends` | 🔴 | [9](09-other.md) |
| GET | `/v1/activity/feed` | 🔴 | [9](09-other.md) |
| POST | `/v2/incentives/eligibility` | 🟡 | [9](09-other.md) |
| – | `/v2/onboarding/…` (sign-up) | Out of scope | [9](09-other.md) |

