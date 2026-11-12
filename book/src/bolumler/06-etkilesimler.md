# Etkileşimler: beğen, geç, Super Like, Boost

## Kaynaklar ne diyor?

Bu işlemlerde kaynaklar arasında **metot farkı** var. Bu fark, eski kodun
neden bozulduğunu açıklıyor:

| İşlem | Yol | fbessez (2018) | NastyDevs (2021) | tinder.py (2023) | tinder-api-ts (2026) |
| --- | --- | :---: | :---: | :---: | :---: |
| Beğen | `/like/{user_id}` | GET | GET | POST | **POST** + gövde |
| Geç | `/pass/{user_id}` | GET | GET | POST | **GET** + `s_number` |
| Super Like | `/like/{user_id}/super` | POST | POST | – | **POST** + gövde |
| Boost | `/boost` | – | POST | – | **POST** |

En güncel kaynağı (tinder-api-ts) esas al. Diğerleri tarihsel bağlam için
tabloda.

## Beğen 🟢

```http
POST /like/{user_id}?locale=tr
Content-Type: application/json

{
  "s_number": 123456789,
  "liked_content_id": "<fotoğraf id>",
  "liked_content_type": "photo"
}
```

| Gövde alanı | Kaynağı |
| --- | --- |
| `s_number` | Öneri kartındaki `s_number` |
| `liked_content_id` | Kullanıcının beğendiğin fotoğrafının `id` değeri (genellikle ilk fotoğraf) |
| `liked_content_type` | Şimdilik yalnızca `photo` |

**Yanıt:**

```json
{ "match": false, "likes_remaining": 87, "status": 200 }
```

| Alan | Anlamı |
| --- | --- |
| `match` | `true` ise karşılıklı beğeni oldu; yeni bir eşleşme oluştu |
| `likes_remaining` | Günlük kalan beğeni hakkı. `0` olunca dur. |
| `X-Padding` | Anlamsız dolgu; yok sayılabilir |

tinder-api-ts `match` alanını `boolean` olarak tipliyor. Eski kaynaklarda
(ör. pynder) eşleşme olduğunda bu alanın bir nesne olabileceğine dair izler
var. Kodunda `match` değerini "truthy" olarak kontrol et: `if (res.match)`.

## Geç (sola kaydır) 🟢

```http
GET /pass/{user_id}?locale=tr&s_number=123456789
```

Gövde yok. `s_number` sorgu parametresi olarak gönderiliyor.

## Super Like 🟢 💳

```http
POST /like/{user_id}/super?locale=tr
```

Gövde, beğeniyle aynı. Ücretsiz hesaplarda hak çok sınırlı. Kalan hakkı
`GET /v2/profile?include=super_likes` ile kontrol et.

## Boost 🟢 💳

```http
POST /boost?locale=tr
```

Gövde boş (`{}`). Profilini belirli bir süre öne çıkarır. Önemli yanıt
alanları:

| Alan | Anlamı |
| --- | --- |
| `duration` | Boost süresi (birimi kaynakta belirtilmemiş) |
| `expires_at` | Bitiş zamanı (Unix ms) |
| `remaining`, `allotment_remaining`, `purchased_remaining` | Kalan haklar |
| `multiplier` | Görünürlük çarpanı |
| `resets_at` | Hakların yenileneceği zaman |
| `boost_type`, `is_super_boost` | Boost türü |

Hak yoksa sunucu hata döner. tinder-api-ts bunu
`TinderNoBoostAvailableError` olarak ayırıyor.

## Mesaj beğenmek 🔴

```http
POST /message/{message_id}/like
```

pynder ve fbessez'de var. Güncel karşılığı doğrulanmadı.

## Otomatik kaydırma neden kötü bir fikir?

Teknik olarak bir döngüde `/like` çağırmak kolay. Ama:

- Tinder'ın Kullanım Koşulları otomatik etkileşimi yasaklıyor. Hesabın ve
  telefon numaran kalıcı olarak engellenebilir.
- Tinder, kullanıcıları herkesi beğenmemeleri konusunda defalarca uyardı.
  Topluluk deneyimine göre seçici olmayan beğeni görünürlüğü artırmıyor.
- Karşındaki kişiler gerçek insanlar. Seçici olmayan beğeniler onların
  deneyimini de bozuyor.

Bu bölümdeki endpoint'leri tek tek, bilinçli işlemler (ör. kendi
arayüzünden bir karta tıklamak) için kullan.

---

**Kaynaklar:** [tinder-api-ts `src/tinder.ts`, `src/interfaces/like.ts`, `src/interfaces/boost.ts`](https://github.com/Miguelo981/tinder-api) ·
[tinder.py](https://github.com/tiagovla/tinder.py) ·
[fbessez/Tinder](https://github.com/fbessez/Tinder) ·
[NastyDevs OpenAPI](https://nastydevs.github.io/tinder-api-documentation/)
