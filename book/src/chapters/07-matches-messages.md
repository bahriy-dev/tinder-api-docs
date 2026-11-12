# Matches, messages and the real-time channel

## The match list 🟢

```http
GET /v2/matches?locale=en&count=60&message=1
```

| Parameter | Notes |
| --- | --- |
| `count` | How many matches to return, between 1 and 100 |
| `message` | `1`: matches you have messaged, `0`: new matches with no messages yet |
| `is_tinder_u` | Tinder U matches (usually `false`) |

The app's "New matches" strip and its "Messages" list are separate requests.
To combine them, call once with `message=0` and once with `message=1`.

### The match object (selected fields)

| Field | Meaning |
| --- | --- |
| `_id` / `id` | The match ID, used as `match_id` in message endpoints. Usually the two user IDs concatenated. |
| `person` | A short profile of the other person (`_id`, `name`, `photos`, `bio`) |
| `created_date` | When the match happened |
| `last_activity_date` | Last message or activity |
| `message_count`, `messages[]` | Message count and the latest messages |
| `participants` | Participant user IDs |
| `seen` | Whether the match has been seen |
| `closed`, `dead` | The match was closed or has ended |
| `pending` | A match that isn't complete yet |
| `is_super_like`, `is_boost_match`, `is_fast_match`, `is_super_boost_match`, `is_primetime_boost_match` | How the match came about |
| `is_opener`, `has_shown_initial_interest` | Who wrote first |
| `readreceipt` | Read receipts 💳 |
| `liked_content` | What of theirs you liked |
| `common_friend_count`, `common_like_count` | Shared connections |

## Messages in a match 🟢

```http
GET /v2/matches/{match_id}/messages?locale=en&count=100
```

Returns a `data.messages[]` array:

```json
{
  "_id": "6a3f…",
  "match_id": "5f1c…5f2d…",
  "from": "5f1c…",
  "to": "5f2d…",
  "message": "Hi!",
  "sent_date": "2026-11-12T09:41:00.000Z",
  "created_date": "2026-11-12T09:41:00.000Z",
  "timestamp": 1794476460000,
  "is_liked": false
}
```

## Sending a message 🟢

```http
POST /user/matches/{match_id}?locale=en
Content-Type: application/json

{ "message": "Hi! Where was the coffee photo on your profile taken?" }
```

The response is the created message object (`_id`, `from`, `to`,
`match_id`, `sent_date`, `message`).

> **🐛 A bug found in the wild:** One popular async Python client builds the
> body as `{"message", message}`. In Python that is a **set**, not a
> dictionary. The correct form is `{"message": message}`. If a Python client
> can't send messages, check for this.

## Unmatching 🟢

```http
DELETE /user/matches/{match_id}
```

Deletes the match and the conversation **irreversibly**. Put it behind a
confirmation step in your client.

## Single lookups 🟡

| Request | Purpose |
| --- | --- |
| `GET /matches/{match_id}` | A single match |
| `GET /message/{message_id}` | A single message |
| `POST /updates` with `{"last_activity_date": "<ISO date>"}` | Everything that changed since a date 🔴 (the old method, before WebSocket) |

## The real-time channel (WebSocket)

Instead of polling, Tinder Web receives new messages over a WebSocket:

```text
1. GET /ws/generate?locale=en   → { "token": "…" }   (with X-Auth-Token)
2. WebSocket: wss://keepalive.gotinder.com/ws?token=<token>
3. The server pushes an event   → fetch the data from the matching endpoint
```

| Step | Details |
| --- | --- |
| Token | `GET /ws/generate` is called with web headers (`platform: web`) |
| Connection | `keepalive.gotinder.com`, using a short-lived token |
| Keep-alive | Clients send a small binary ping frame every 30 seconds |
| Events | Binary messages with an undocumented schema |

> **Design tip:** Don't try to decode event payloads. Treat an event as a
> "something changed" signal and call `GET /v2/matches`. That is more robust
> and survives schema changes.
