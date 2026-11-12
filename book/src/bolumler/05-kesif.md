# Keşif ve öneriler

Kaydırdığın kart destesi tek bir endpoint'ten gelir.

## Öneri destesi 🟢

```http
GET /v2/recs/core?locale=tr&duos=0
```

| Parametre | Açıklama |
| --- | --- |
| `locale` | Yanıt dili |
| `duos` | `0` normal öneriler, `1` "Double Date / Duos" modu |

### Yanıt

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

### Önemli alanlar

| Alan | Neden önemli |
| --- | --- |
| `user._id` | Beğenme ve geçme isteklerinde kullanılan kimlik |
| `s_number` | Kartın oturuma özel numarası. Beğenme ve geçme isteklerinde geri gönderilir (bkz. [6. bölüm](06-etkilesimler.md)). |
| `content_hash` | Kart içeriğinin özeti. Bazı eski istemciler beğeniye ekliyordu. |
| `user.photos[].id` | Güncel kaynakta beğenilen içerik olarak (`liked_content_id`) gönderiliyor |
| `distance_mi` | Mil cinsinden yaklaşık mesafe. Gerçek konum değildir, yuvarlanmıştır. |
| `teasers` | Kartta gösterilen kısa bilgiler (iş, okul, ilgi alanı) |
| `experiment_info.user_interests` | Ortak ilgi alanları, `is_common` işaretiyle |
| `type` | Genellikle `user`. Reklam veya özel kartlar farklı türde gelebilir. |

### Boş deste

`results` boş dönerse:

1. Ayarlarındaki mesafe ve yaş aralığı çok dar olabilir.
2. Yakındaki herkesi görmüş olabilirsin.
3. Kısa sürede çok fazla istek göndermiş olabilirsin. Geçici bir yumuşak
   blok uygulanabilir. **Bekle; isteği tekrarlama.**

## Eski öneri endpoint'i 🔴

```http
GET /user/recs
```

pynder ve tinder.py'nin eski sürümleri kullanıyordu. `/v2/recs/core`
çıkalı beri tarihsel. Yeni kodda kullanma.

## Keşfet (Explore) 🟡

```http
GET /v2/explore?locale=tr
```

tinder.py'de mevcut. Uygulamanın "Keşfet" sekmesindeki tematik kartları
(ör. "Yeni arkadaşlar", "Uzun süreli ilişki") döner. Yanıt şeması
belgelenmedi.

## Filtreli arama: geçici tercih tekniği

tinder-api-ts'deki `searchWithFilters` ilginç bir desen kullanıyor:

```text
1. Mevcut tercihleri oku        GET  /v2/profile?include=user
2. Filtreleri geçici uygula     POST /v2/profile, /v2/profile/user
3. Desteyi çek                  GET  /v2/recs/core
4. Eski tercihleri geri yükle   POST /v2/profile, /v2/profile/user
   (adım 2 veya 3 hata verse bile)
```

Bu desenden çıkan ders: **Durumu değiştiren her işlemi bir `try/finally`
bloğuna al.** Kodun yarıda kesilirse hesabın beklenmedik ayarlarla kalmasın.

---

**Kaynaklar:** [tinder-api-ts `src/interfaces/search.ts`](https://github.com/Miguelo981/tinder-api) ·
[tinder.py `tinder/http.py`](https://github.com/tiagovla/tinder.py) ·
[pynder](https://github.com/charliewolf/pynder)
