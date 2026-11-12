# Other endpoints

This chapter collects endpoints that sit outside the main flow but have been
observed in clients and documentation.

## "Likes You" 💳

| Request | Purpose | Status |
| --- | --- | :---: |
| `POST /v2/fast-match/count` · `GET /v2/fast-match/count` | How many people liked you | 🟡 (method varies) |
| `GET /v2/fast-match/teaser?type=recently-active` | A single blurred preview | 🟡 |
| `GET /v2/fast-match/teasers` | A list of previews | 🟡 |
| `GET /v2/fast-match/preview` | Preview thumbnail | 🔴 |
| `GET /v2/my-likes` | Summary of your likes | 🟡 |

> **Limit:** On a free account these endpoints only return **blurred**
> previews. In the past some projects exposed unblurred images through API
> flaws. Tinder closed those flaws, and such tools are deliberately left out
> of this book ([chapter 13](13-responsible-use.md)).

## GIFs in chat 🔴

| Request | Purpose |
| --- | --- |
| `GET /giphy/trending?limit={n}` | Trending GIFs |
| `GET /giphy/search?limit={n}&query={q}` | GIF search |

Tinder uses Giphy for GIFs in chat and proxies these requests through its own
server.

## Connected accounts

| Request | Purpose | Status |
| --- | --- | :---: |
| `GET /instagram/authorize` | Start an Instagram connection | 🔴 |
| `POST /instagram/authenticate` · `POST /instagram/deauthorize` | Connect / disconnect Instagram | 🟡 |
| `GET /v2/profile/spotify` · `PUT /v2/profile/spotify/theme` | Spotify settings and profile anthem | 🔴 |

## Notifications

| Request | Purpose | Status |
| --- | --- | :---: |
| `PUT /v2/push/notifications` | Notification preferences (exact behavior undocumented) | 🟡 |
| `POST /v2/push/devices/web/{device_code}` · `DELETE …` | Web push device registration | 🟡 |

## Reporting

| Request | Body | Status |
| --- | --- | :---: |
| `POST /report/{user_id}` | `{"cause": <number>, "text": "<explanation>"}` | 🔴 |
| `POST /report/user/{user_id}` | Similar | 🟡 |

Report causes are a small set of numbers. To report a real problem, the app's
own report screen is always the better choice. Automated reporting is very
easy to abuse.

## Sign-up (onboarding)

The sign-up steps (`/v2/onboarding/fields`, `/v2/onboarding/photo`,
`/v2/onboarding/complete`, `/v2/onboarding/user`) have been documented. This
book **deliberately doesn't go into them**. Creating accounts
programmatically is almost only ever used for fake or bulk accounts. Create
your account in the app.

## Everything else

| Request | Purpose | Status |
| --- | --- | :---: |
| `GET /user/{user_id}/common_connections` | Shared connections | 🔴 |
| `POST /user/{user_id}/share` | Profile share link | 🔴 |
| `GET /group/friends` | Facebook friends (the old "Social" feature) | 🔴 |
| `GET /v1/activity/feed?direction=past&eventTypes=1023` | Activity feed | 🔴 |
| `POST /v2/incentives/eligibility` | Promo code eligibility | 🟡 |
| `POST /v2/auth/verify-captcha` | CAPTCHA verification (don't use it; see chapter 2) | 🟡 |
| `POST /v2/auth/logout` | Log out | 🟡 |
