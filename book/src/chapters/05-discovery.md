# Discovery and recommendations

The deck of cards you swipe through comes from a single endpoint.

## The recommendation deck 🟢

```http
GET /v2/recs/core?locale=en&duos=0
```

| Parameter | Notes |
| --- | --- |
| `locale` | Response language |
| `duos` | `0` normal recommendations, `1` "Double Date / Duos" mode |

### Response

```json
{
  "meta": { "status": 200 },
  "data": {
    "results": [
      {
        "type": "user",
        "user": {
          "_id": "5f1c…",
          "name": "…",
          "birth_date": "…",
          "bio": "…",
          "photos": [ { "id": "…", "url": "…", "processedFiles": [ … ] } ],
          "gender": 1,
          "badges": [ … ]
        },
        "distance_mi": 4,
        "s_number": 123456789,
        "content_hash": "…",
        "teasers": [ … ],
        "experiment_info": { "user_interests": { "selected_interests": [ … ] } },
        "spotify": { … },
        "facebook": { "common_connections": [], "common_interests": [] }
      }
    ]
  }
}
```

### Key fields

| Field | Why it matters |
| --- | --- |
| `user._id` | The ID used in like and pass requests |
| `s_number` | A per-session card number. It is sent back in like and pass requests (see [chapter 6](06-interactions.md)). |
| `content_hash` | A hash of the card content. Some older clients added it to likes. |
| `user.photos[].id` | Sent as the liked content (`liked_content_id`) in current clients |
| `distance_mi` | Approximate distance in miles. Rounded, not an exact location. |
| `teasers` | Short facts shown on the card (job, school, interest) |
| `experiment_info.user_interests` | Interests, with an `is_common` flag for shared ones |
| `type` | Usually `user`. Ads or special cards can use other types. |

### An empty deck

If `results` comes back empty:

1. Your distance and age range may be too narrow.
2. You may have seen everyone nearby.
3. You may have sent too many requests in a short time, triggering a
   temporary soft block. **Wait; don't repeat the request.**

## The legacy recommendations endpoint 🔴

```http
GET /user/recs
```

Used by early clients. Historical since `/v2/recs/core` arrived. Don't use it
in new code.

## Explore 🟡

```http
GET /v2/explore?locale=en
```

Returns the themed cards from the app's "Explore" tab (for example "New
friends" or "Long-term partner"). The response schema is undocumented.

## Filtered search: the temporary preference pattern

One current client implements filtered search with an interesting pattern:

```text
1. Read current preferences     GET  /v2/profile?include=user
2. Apply filters temporarily    POST /v2/profile, /v2/profile/user
3. Fetch the deck               GET  /v2/recs/core
4. Restore old preferences      POST /v2/profile, /v2/profile/user
   (even if step 2 or 3 fails)
```

The lesson: **wrap every state-changing operation in `try/finally`.** If your
code stops halfway, your account shouldn't be left with unexpected settings.
