# Location, meta and Passport

## Updating your location

The location endpoint is one of the areas that has changed most:

| Period | Request | Body | Status |
| --- | --- | --- | :---: |
| 2014–2020 | `POST /user/ping` | `{"lat": 40.71, "lon": -74.00}` | 🔴 |
| 2021– | `POST /v2/meta` | `{"lat": 40.71, "lon": -74.00}` | 🟢 |

Current clients call `POST /v2/meta?locale=en`, so updating your location
and fetching your account meta happen **in the same request**.

> **Location is sensitive.** Changing it often and inconsistently (different
> cities within minutes) can be flagged as suspicious. It has been reported
> that this can be used as a free "location change". That would bypass the
> paid Passport feature, which this book's rules exclude.

## The meta response 🟢

The `POST /v2/meta` response is a broad summary of your account state:

| Section | Contents |
| --- | --- |
| `readreceipts` | Whether read receipts are on |
| `profile` | Editing limits: `can_edit_jobs`, `can_edit_email`, `school_name_max_length`, `job_title_max_length`… |
| `super_like` | Whether Super Like is enabled, `alc_mode` |
| `location_prechecks` | Location pre-check codes |
| `age_verification` | Age verification status |
| `biometric_consent` | Consent for biometric data (e.g. photo verification) |
| `voter_registration` | US-only voter registration prompt |

The legacy `GET /meta` endpoint (🔴) returned things like remaining swipes
and the number of people seen. `GET /v2/meta` (🟡) added extras such as
"Top Picks".

## Passport (travel mode) 💳 🔴

| Request | Body | Purpose |
| --- | --- | --- |
| `POST /passport/user/travel` | `{"lat": …, "lon": …}` | Move your swiping location to another city |
| `POST /passport/user/reset` | `{}` | Return to your real location |

Requires a paid subscription. Documented in 2018.

## Popular places 🟡

```http
GET /location/popular
```

Returns the list of popular cities shown on the Passport screen.
