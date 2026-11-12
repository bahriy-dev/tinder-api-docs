# Eşleşmeler, mesajlar ve gerçek zamanlı kanal

## Eşleşme listesi 🟢

```http
GET /v2/matches?locale=tr&count=60&message=1
```

| Parametre | Açıklama |
| --- | --- |
| `count` | Kaç eşleşme döneceği. tinder-api-ts varsayılanı 60, fbessez'e göre 1–100 arası. |
| `message` | `1`: mesajlaşılmış eşleşmeler, `0`: henüz mesaj olmayan yeni eşleşmeler |
| `is_tinder_u` | Tinder U eşleşmeleri (tinder-api-ts `false` gönderiyor) |

Uygulamadaki "Yeni eşleşmeler" şeridi ile "Mesajlar" listesi ayrı istekler.
İkisini birleştirmek için `message=0` ve `message=1` ile iki çağrı yap.

### Eşleşme nesnesi (seçilmiş alanlar)

| Alan | Anlamı |
| --- | --- |
| `_id` / `id` | Eşleşme kimliği. Mesaj endpoint'lerinde `match_id` olarak kullanılır. Genellikle iki kullanıcı kimliğinin birleşimidir. |
| `person` | Karşı tarafın özet profili (`_id`, `name`, `photos`, `bio`) |
| `created_date` | Eşleşme zamanı |
| `last_activity_date` | Son mesaj veya etkinlik |
| `message_count`, `messages[]` | Mesaj sayısı ve son mesajlar |
| `participants` | Katılımcı kullanıcı kimlikleri |
| `seen` | Eşleşmenin görülüp görülmediği |
| `closed`, `dead` | Eşleşme kapatılmış veya sona ermiş |
| `pending` | Henüz tamamlanmamış eşleşme |
| `is_super_like`, `is_boost_match`, `is_fast_match`, `is_super_boost_match`, `is_primetime_boost_match` | Eşleşmenin nasıl oluştuğu |
| `is_opener`, `has_shown_initial_interest` | Kimin önce yazdığına dair işaretler |
| `readreceipt` | Okundu bilgisi 💳 |
| `liked_content` | Karşı tarafın neyini beğendiğin |
| `common_friend_count`, `common_like_count` | Ortak bağlantılar |

## Bir eşleşmenin mesajları 🟢

```http
GET /v2/matches/{match_id}/messages?locale=tr&count=100
```

Yanıt `data.messages[]` dizisini döner:

```json
{
  "_id": "6a3f…",
  "match_id": "5f1c…5f2d…",
  "from": "5f1c…",
  "to": "5f2d…",
  "message": "Merhaba!",
  "sent_date": "2026-11-12T09:41:00.000Z",
  "created_date": "2026-11-12T09:41:00.000Z",
  "timestamp": 1794476460000,
  "is_liked": false
}
```

## Mesaj göndermek 🟢

```http
POST /user/matches/{match_id}?locale=tr
Content-Type: application/json

{ "message": "Merhaba! Profilindeki kahve fotoğrafı nerede çekildi?" }
```

Yanıt, oluşturulan mesaj nesnesidir (`_id`, `from`, `to`, `match_id`,
`sent_date`, `message`).

> **🐛 Kaynakta bulunan bir hata:** tinder.py 0.x sürümünün `send_message`
> fonksiyonu gövdeyi `{"message", message}` olarak yazıyor. Bu Python'da bir
> sözlük (`dict`) değil, bir **küme (`set`)**. Doğrusu
> `{"message": message}`. tinder.py ile mesaj gönderemiyorsan nedeni bu
> olabilir.

## Eşleşmeyi kaldırmak 🟢

```http
DELETE /user/matches/{match_id}
```

Eşleşmeyi ve sohbeti **geri dönüşsüz** siler. Kendi istemcinde bir onay
adımının arkasına koy.

## Tekil sorgular 🟡

| İstek | Amaç |
| --- | --- |
| `GET /matches/{match_id}` | Tek bir eşleşme |
| `GET /message/{message_id}` | Tek bir mesaj |
| `POST /updates` gövde `{"last_activity_date": "<ISO tarih>"}` | Bir tarihten bu yana olan değişiklikler 🔴 (WebSocket'ten önceki eski yöntem) |

## Gerçek zamanlı kanal (WebSocket)

Tinder Web yeni mesajları sürekli sorgulamak (polling) yerine bir WebSocket
bağlantısıyla alıyor. tinder.py bu akışı uyguluyor:

```text
1. GET /ws/generate?locale=tr      → { "token": "…" }   (X-Auth-Token ile)
2. WebSocket: wss://keepalive.gotinder.com/ws?token=<token>
3. Sunucu olay gönderir           → ilgili endpoint'ten veriyi çek
```

| Adım | Ayrıntı |
| --- | --- |
| Token üretimi | `GET /ws/generate` web başlıklarıyla (`platform: web`) çağrılıyor |
| Bağlantı | `keepalive.gotinder.com`, kısa ömürlü token ile |
| Canlı tutma | tinder.py her 30 saniyede bir küçük bir ikili ping çerçevesi gönderiyor |
| Olaylar | İkili (binary) mesajlar. Şema belgelenmemiş. tinder.py olayları çözmüyor, yalnızca hex olarak logluyor. |

> **Tasarım önerisi:** Olay içeriğini çözmeye çalışma. Olayı yalnızca
> "bir şey değişti" sinyali olarak kullan ve `GET /v2/matches` çağır. Bu
> hem daha sağlam hem de şema değişikliklerinden etkilenmez.

---

**Kaynaklar:** [tinder-api-ts `src/interfaces/matches.ts`, `chat.ts`](https://github.com/Miguelo981/tinder-api) ·
[tinder.py `tinder/http.py`, `gateway.py`](https://github.com/tiagovla/tinder.py) ·
[fbessez/Tinder](https://github.com/fbessez/Tinder) ·
[NastyDevs OpenAPI](https://nastydevs.github.io/tinder-api-documentation/)
