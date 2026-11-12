# Interactions: like, pass, Super Like, Boost

## Methods differ across eras

The HTTP method for these actions has changed over time, which explains why
older code breaks:

| Action | Path | 2018 docs | 2021 schema | 2023 client | 2026 client |
| --- | --- | :---: | :---: | :---: | :---: |
| Like | `/like/{user_id}` | GET | GET | POST | **POST** + body |
| Pass | `/pass/{user_id}` | GET | GET | POST | **GET** + `s_number` |
| Super Like | `/like/{user_id}/super` | POST | POST | – | **POST** + body |
| Boost | `/boost` | – | POST | – | **POST** |

Follow the most recent column. The others are there for historical context.

## Like 🟢

```http
POST /like/{user_id}?locale=en
Content-Type: application/json

{
  "s_number": 123456789,
  "liked_content_id": "<photo id>",
  "liked_content_type": "photo"
}
```

| Body field | Where it comes from |
| --- | --- |
| `s_number` | The recommendation card's `s_number` |
| `liked_content_id` | The `id` of the photo you liked (usually the first) |
| `liked_content_type` | Currently only `photo` |

**Response:**

```json
{ "match": false, "likes_remaining": 87, "status": 200 }
```

| Field | Meaning |
| --- | --- |
| `match` | If `true`, the like was mutual and a new match was created |
| `likes_remaining` | Likes left today. Stop at `0`. |
| `X-Padding` | Meaningless padding; ignore it |

Current clients type `match` as a `boolean`. Older clients suggest it could
be an object when a match happens. Check it as a truthy value:
`if (res.match)`.

## Pass (swipe left) 🟢

```http
GET /pass/{user_id}?locale=en&s_number=123456789
```

No body. `s_number` goes in the query string.

## Super Like 🟢 💳

```http
POST /like/{user_id}/super?locale=en
```

Same body as a like. Free accounts get very few. Check what is left with
`GET /v2/profile?include=super_likes`.

## Boost 🟢 💳

```http
POST /boost?locale=en
```

The body is empty (`{}`). Boost puts your profile in front for a limited
time. Key response fields:

| Field | Meaning |
| --- | --- |
| `duration` | Boost duration (unit not documented) |
| `expires_at` | End time (Unix ms) |
| `remaining`, `allotment_remaining`, `purchased_remaining` | Boosts left |
| `multiplier` | Visibility multiplier |
| `resets_at` | When the allowance resets |
| `boost_type`, `is_super_boost` | Type of boost |

With no Boost left, the server returns an error. Model it as its own error
type.

## Liking a message 🔴

```http
POST /message/{message_id}/like
```

Appears in early clients. The current equivalent is unconfirmed.

## Why auto-swiping is a bad idea

Calling `/like` in a loop is technically easy. But:

- Tinder's Terms of Use prohibit automated interaction. Your account and
  phone number can be banned permanently.
- Tinder has repeatedly told users not to like everyone. Community
  experience suggests indiscriminate liking doesn't improve visibility.
- The people on the other side are real. Indiscriminate likes make their
  experience worse too.

Use the endpoints in this chapter for single, deliberate actions, such as
clicking a card in your own interface.
