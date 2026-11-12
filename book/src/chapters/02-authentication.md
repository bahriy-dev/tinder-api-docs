# Authentication

Almost every request to the app API is authenticated with a single header:

```http
X-Auth-Token: 3f9c2a1e-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

The token is a UUID and gives **full access to your account**: profile,
matches, messages and location. This chapter explains how the token is
obtained and how to protect it.

> **Warning:** Never put your token on a website, in an issue, in a
> screenshot or in a git repository. Anyone who has it can read and send
> messages as you.

## How login has evolved

| Period | Method | Endpoint | Status |
| --- | --- | --- | :---: |
| 2014–2019 | Exchange a Facebook access token | `POST /auth`, later `POST /v2/auth/login/facebook` | 🔴 |
| 2018–2020 | SMS via Facebook Account Kit | `POST /auth/login/accountkit` | 🔴 Account Kit shut down |
| 2019–2023 | Tinder's own SMS OTP flow (JSON) | `POST /v2/auth/sms/send`, `/v2/auth/sms/validate`, `/v2/auth/login/sms` | 🟡 |
| 2024– | Protobuf authentication gateway | `POST /v3/auth/login` | 🟢 |
| Always | Copy your own token from the browser | – | 🟢 The most robust option |

## Method 1: Copy your own token from the browser (recommended)

For personal experiments this is the simplest and least fragile route, and
it never runs into a CAPTCHA. Current clients recommend it too.

1. Sign in to [tinder.com](https://tinder.com) **with your own account** as
   usual.
2. Open the developer tools (`F12` or `Cmd+Option+I`).
3. Go to **Application → Local Storage → `https://tinder.com`**.
4. Find these keys:

| Key | Contents | Used for |
| --- | --- | --- |
| `TinderWeb/APIToken` | The `X-Auth-Token` value | Every app API request |
| `TinderWeb/uuid` | Persistent device ID | The `persistent-device-id` header |
| Refresh token (key name may vary) | Refresh token | Getting a new token when the old one expires |

Put the token in an environment variable. Never hard-code it:

```bash
# .env (remember to add this file to .gitignore)
TINDER_AUTH_TOKEN=...
TINDER_DEVICE_ID=...
```

## Method 2: The protobuf gateway (`/v3/auth/login`) 🟢

Since 2024 the mobile app logs in through a single endpoint that speaks
**Protocol Buffers** instead of JSON. The only current open-source
implementation is the `LoginSession` class in the `tinder-api-ts` package.

### Flow

```text
Client                                    /v3/auth/login
  │  1. PhoneRequest(phone)                      │
  │ ───────────────────────────────────────────▶ │
  │ ◀──────────────── SmsSent(masked phone, OTP length)
  │                                              │
  │  2. OtpRequest(phone, sms_code)              │
  │ ───────────────────────────────────────────▶ │
  │ ◀──── a) Success(auth_token, refresh_token, user_id)
  │ ◀──── b) EmailRequired(masked email, jwt)  ──┐
  │ ◀──── c) CaptchaRequired(Arkose)  → STOP     │
  │                                              │
  │  3. EmailCode(email_code, jwt)  ◀────────────┘
  │ ───────────────────────────────────────────▶ │
  │ ◀──────────── Success(auth_token, refresh_token, user_id)
```

### Request details

| Property | Value (as of July 2026) |
| --- | --- |
| Method and path | `POST /v3/auth/login?locale=en` |
| `Content-Type` / `Accept` | `application/x-protobuf` |
| Client identity | `platform: ios`, `tinder-version`, `app-version`, an iOS `User-Agent` |
| Session headers | `persistent-device-id`, `app-session-id`, `funnel-session-id`, `app-session-time-elapsed` |
| Body | An `AuthGatewayRequest` protobuf message (with a phone, OTP or email-code sub-message) |
| Response | An `AuthGatewayResponse` message containing one of `sms_sent`, `success`, `email_required` or `captcha` |

The `.proto` schema has never been published, so the messages are built with
a small hand-written protobuf encoder. If the field numbers change, the flow
can break silently. In your own code, **throw an explicit error** when the
field you expect is missing from the response.

### The three possible outcomes

| Response | Meaning | What to do |
| --- | --- | --- |
| **Success** | `auth_token` and `refresh_token` were returned | Store both securely |
| **EmailRequired** | An extra code was sent to the account's email; the response includes a `jwt` | Ask the user for the email code and send it together with the `jwt` |
| **CaptchaRequired** | The server found the traffic suspicious (Arkose Labs) | **Stop.** Log in normally in the browser and switch to Method 1. Trying to solve the CAPTCHA automatically is a clear violation of the Terms of Use. |

## Method 3: The JSON SMS flow (`/v2/auth/...`) 🟡

The older flow, documented in 2019–2023 material. Don't use it in new
projects, but it helps when you read older code:

| Step | Request | Body | Taken from the response |
| --- | --- | --- | --- |
| 1 | `POST /v2/auth/sms/send?auth_type=sms` | `{"phone_number": "1555…"}` | – |
| 2 | `POST /v2/auth/sms/validate?auth_type=sms` | `{"otp_code": "123456", "phone_number": "1555…"}` | `refresh_token` |
| 3 | `POST /v2/auth/login/sms` | `{"refresh_token": "…"}` | `api_token` (= `X-Auth-Token`) |

## Token lifecycle

- An `X-Auth-Token` is valid for a **limited time**. When it expires,
  requests return `401 Unauthorized`.
- Getting a new token with a refresh token **also rotates the refresh
  token**. Store the new pair every time and never reuse the old refresh
  token.
- Logging out on the web (`POST /v2/auth/logout`) invalidates the token.

```text
         ┌─────────── 401 ───────────┐
         ▼                           │
 [refresh_token] ──▶ new pair ──▶ [auth_token] ──▶ requests
         ▲                │
         └── store ◀──────┘
```

## Secure storage checklist

- [ ] The token lives in an environment variable or the OS keychain (macOS
      Keychain, Windows Credential Manager)
- [ ] The `.env` file is in `.gitignore`
- [ ] Tokens are masked in logs (`3f9c…xxxx`)
- [ ] Request headers are redacted in error reports
- [ ] The token is only ever sent to `https://api.gotinder.com`
