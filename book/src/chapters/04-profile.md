# Profile and account

## Reading your own profile 🟢

```http
GET /v2/profile?locale=en&include=user,account,likes,boost,super_likes
```

The `include` parameter decides which sections the response contains.
Without it the response is very thin. Known scopes:

| Scope | Contents |
| --- | --- |
| `user` | Name, bio, photos, birth date, gender, discovery preferences |
| `account` | Phone, email, account status |
| `likes` | Remaining likes and when they reset |
| `super_likes` | Remaining Super Likes |
| `boost` | Boost allowance and any active boost |
| `travel` | Passport (location change) status 💳 |
| `plus_control` | Paid privacy settings (hide age and distance) 💳 |
| `readreceipts` | Read receipt allowance 💳 |
| `spotify`, `instagram` | Connected accounts |
| `notifications`, `email_settings` | Notification preferences |
| `available_descriptors` | Descriptors you can add to a profile (star sign, education, …) |
| `profile_meter` | Profile completeness meter |
| `feature_access`, `paywalls`, `offerings`, `purchase`, `misc_merchandising` | Subscription and sales screens |
| `onboarding`, `tutorials` | First-run steps |
| `tinder_u` | Tinder U (university) status |
| `contact_cards`, `bouncerbypass`, `all_in_gender` | Undocumented internal scopes |

> **Tip:** Only request the scopes you need. The response is smaller and you
> avoid processing data you don't use. `user,likes,boost` covers most cases.

## Updating your profile and discovery settings 🟢

Updates are split across **two endpoints** with two different body shapes:

| Endpoint | Body | What it updates |
| --- | --- | --- |
| `POST /v2/profile` | `{"user": {…}}` | Your profile and basic discovery settings: age range, distance, gender filter, bio, visibility, auto-expansion, Global mode |
| `POST /v2/profile/user` | `{"preference_filters": {…}}` | **Advanced filters** that narrow recommendations: interests, descriptors (star sign, education…), "has a bio", number of photos 💳 |

Example: basic discovery settings

```json
{
  "user": {
    "age_filter_min": 25,
    "age_filter_max": 35,
    "distance_filter": 30,
    "gender_filter": 1,
    "bio": "Coffee, code and long walks.",
    "discoverable": true
  }
}
```

| Field | Values |
| --- | --- |
| `age_filter_min`, `age_filter_max` | Ages 18 and up |
| `distance_filter` | In **miles**. The API stores miles even when the app shows kilometres (36 mi ≈ 58 km). Divide km by `1.609344` and round. The upper limit is roughly 100 miles (≈160 km). |
| `gender_filter` | `0` men, `1` women, `-1` everyone |
| `bio` | Profile text |
| `discoverable` | If `false`, you don't appear in anyone's deck |
| Auto-expansion | Widen age and distance when recommendations run low |
| Global mode | Recommendations from around the world, plus the languages you want to match in |

> **💳 Premium limit:** Preference updates (especially `preference_filters`)
> return `403` on a free account. Treat that `403` as "not allowed" and don't
> retry.

### Legacy `/profile` options 🔴

In 2018-era material, `POST /profile` could also do the following:

| Body | Effect |
| --- | --- |
| `{"hide_age": true}` | Hide your age 💳 |
| `{"hide_distance": true}` | Hide your distance 💳 |
| `{"hide_ads": true}` | Hide ads 💳 |
| `{"blend": "recency"}` / `{"blend": "optimal"}` | Recommendation ordering mode 💳 |
| `{"discoverable_party": "liked"}` | Only show yourself to people you liked 💳 |

These are probably managed today under the `plus_control` scope via
`/v2/profile`. This has not been confirmed in any current client.

## Other profile endpoints

| Request | Purpose | Status |
| --- | --- | :---: |
| `PUT /profile/job` · `DELETE /profile/job` | Add or remove your job | 🔴 |
| `PUT /profile/school` · `DELETE /profile/school` | Add or remove your school | 🔴 |
| `POST /v2/profile/job` · `POST /v2/profile/school` | v2 equivalents | 🟡 |
| `GET /v2/profile/spotify` · `PUT /v2/profile/spotify/theme` | Spotify settings and profile anthem | 🔴 |
| `PUT /profile/username` · `DELETE /profile/username` | Web profile username | 🔴 |
| `GET /profile/photos` · `DELETE /media` | List photos, delete a photo | 🟡 |
| `POST /v2/profile/email_settings` | Email notification settings | 🟡 |
| `POST /v2/account/account-email/confirm` | Confirm your email | 🟡 |
| `POST /v2/account/recovery/send` | Account recovery email | 🟡 |
| `DELETE /v2/profile` | **Permanently deletes the account** | 🟡 ⚠️ |

> **⚠️ `DELETE /v2/profile`:** This request deletes the account. Don't define
> this route in your client at all, or put it behind an explicit
> confirmation step. Deleting and re-creating an account repeatedly is
> reported to get the phone number permanently banned.

## Another user's profile 🟡

```http
GET /user/{user_id}?locale=en
```

The response is a `results` object similar to a recommendation card: name,
age, photos, bio, distance. This data belongs to someone else. Only use it
to display what you could already see in the app. Don't store or collect it
(see [chapter 13](13-responsible-use.md)).
