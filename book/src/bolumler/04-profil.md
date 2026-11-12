# Profil ve hesap

## Kendi profilini okumak 🟢

```http
GET /v2/profile?locale=tr&include=user,account,likes,boost,super_likes
```

`include` parametresi, yanıtın hangi bölümleri içereceğini belirler. Hiçbiri
verilmezse yanıt çok sınırlı olur. tinder-api-ts'in varsayılan listesi:

| Kapsam | İçerik |
| --- | --- |
| `user` | Ad, biyografi, fotoğraflar, doğum tarihi, cinsiyet, keşif tercihleri |
| `account` | Telefon, e-posta, hesap durumu |
| `likes` | Kalan beğeni hakkı ve sıfırlanma zamanı |
| `super_likes` | Kalan Super Like hakkı |
| `boost` | Boost hakkı ve aktif boost |
| `travel` | Passport (konum değiştirme) durumu 💳 |
| `plus_control` | Ücretli gizlilik ayarları (yaşı ve mesafeyi gizleme) 💳 |
| `readreceipts` | Okundu bilgisi hakları 💳 |
| `spotify`, `instagram` | Bağlı hesaplar |
| `notifications`, `email_settings` | Bildirim tercihleri |
| `available_descriptors` | Profilde seçilebilen tanımlayıcılar (burç, eğitim vb.) |
| `profile_meter` | Profil tamamlanma göstergesi |
| `feature_access`, `paywalls`, `offerings`, `purchase`, `misc_merchandising` | Abonelik ve satış ekranları |
| `onboarding`, `tutorials` | İlk kullanım adımları |
| `tinder_u` | Tinder U (üniversite) durumu |
| `contact_cards`, `bouncerbypass`, `all_in_gender` | Kaynakta açıklanmamış iç kapsamlar |

> **Pratik öneri:** Sadece ihtiyacın olan kapsamları iste. Yanıt küçülür ve
> gereksiz veri işlememiş olursun. Çoğu senaryoda `user,likes,boost` yeterli.

## Profil ve keşif tercihlerini güncellemek 🟢

Güncel kaynakta güncellemeler **iki ayrı endpoint'e** ve iki ayrı gövde
biçimine bölünmüş:

| Endpoint | Gövde | Ne güncellenir |
| --- | --- | --- |
| `POST /v2/profile` | `{"user": {…}}` | Kendi profilin ve temel keşif ayarların: yaş aralığı, mesafe, cinsiyet filtresi, biyografi, görünürlük, otomatik genişletme, Global mod |
| `POST /v2/profile/user` | `{"preference_filters": {…}}` | Önerileri daraltan **gelişmiş filtreler**: ilgi alanları, tanımlayıcılar (burç, eğitim…), "biyografisi olanlar", fotoğraf sayısı 💳 |

Örnek: temel keşif ayarları

```json
{
  "user": {
    "age_filter_min": 25,
    "age_filter_max": 35,
    "distance_filter": 30,
    "gender_filter": 1,
    "bio": "Kahve, kod ve uzun yürüyüşler.",
    "discoverable": true
  }
}
```

| Alan | Değerler |
| --- | --- |
| `age_filter_min`, `age_filter_max` | 18 ve üstü yaş |
| `distance_filter` | **Mil** cinsinden; uygulama km gösterse de API mil saklar (36 mil ≈ 58 km). tinder-api-ts km'yi `1.609344`'e bölüp yuvarlıyor. Üst sınır yaklaşık 100 mil (≈160 km). |
| `gender_filter` | `0` erkek, `1` kadın, `-1` herkes |
| `bio` | Profil metni |
| `discoverable` | `false` ise öneri destelerinde görünmezsin |
| Otomatik genişletme | Öneri azalınca yaş ve mesafeyi esnet |
| Global mod | Dünya genelinden öneri ve eşleşmek istediğin diller |

> **💳 Premium sınırı:** tinder-api-ts'e göre tercih güncellemeleri (özellikle
> `preference_filters`) ücretsiz hesapta `403` döner. Kütüphane bunu
> `TinderPremiumRequiredError` olarak ayırıyor. Kendi kodunda da `403`'ü
> "yetki yok" olarak ele al ve tekrar deneme.

### Eski `/profile` seçenekleri 🔴

fbessez'in 2018 belgesinde `POST /profile` ile şunlar da yapılabiliyordu:

| Gövde | Etki |
| --- | --- |
| `{"hide_age": true}` | Yaşı gizle 💳 |
| `{"hide_distance": true}` | Mesafeyi gizle 💳 |
| `{"hide_ads": true}` | Reklamları gizle 💳 |
| `{"blend": "recency"}` / `{"blend": "optimal"}` | Öneri sıralama modu 💳 |
| `{"discoverable_party": "liked"}` | Sadece beğendiklerine görün 💳 |

Bu alanların bugün `plus_control` kapsamı altında `/v2/profile` üzerinden
yönetildiği tahmin ediliyor. Güncel bir kaynakla doğrulanmadı.

## Diğer profil endpoint'leri

| İstek | Amaç | Durum |
| --- | --- | :---: |
| `PUT /profile/job` · `DELETE /profile/job` | İş bilgisi ekle veya kaldır | 🔴 |
| `PUT /profile/school` · `DELETE /profile/school` | Okul ekle veya kaldır | 🔴 |
| `POST /v2/profile/job` · `POST /v2/profile/school` | v2 karşılıkları | 🟡 (NastyDevs) |
| `GET /v2/profile/spotify` · `PUT /v2/profile/spotify/theme` | Spotify ayarları ve profil şarkısı | 🔴 |
| `PUT /profile/username` · `DELETE /profile/username` | Web profil kullanıcı adı | 🔴 |
| `GET /profile/photos` · `DELETE /media` | Fotoğrafları listele, fotoğraf sil | 🟡 |
| `POST /v2/profile/email_settings` | E-posta bildirim ayarları | 🟡 |
| `POST /v2/account/account-email/confirm` | E-posta doğrulama | 🟡 |
| `POST /v2/account/recovery/send` | Hesap kurtarma e-postası | 🟡 |
| `DELETE /v2/profile` | **Hesabı kalıcı olarak siler** | 🟡 ⚠️ |

> **⚠️ `DELETE /v2/profile`:** NastyDevs şemasına göre bu istek hesabı siler.
> Kendi istemcinde bu yolu hiç tanımlama veya açık bir onay adımının arkasına
> koy. NastyDevs ayrıca hesabı defalarca silip yeniden açmanın telefon
> numarasına kalıcı engel getirdiğini not ediyor.

## Başka bir kullanıcının profili 🟡

```http
GET /user/{user_id}?locale=tr
```

tinder.py, NastyDevs ve fbessez tarafından belgeleniyor. Yanıt, öneri
kartındakine benzer bir `results` nesnesi döner: ad, yaş, fotoğraflar,
biyografi, mesafe. Bu veriler başka bir kişiye ait. Yalnızca uygulamada
zaten gördüğün bilgiyi görüntülemek için kullan; saklama veya toplama
([13. bölüm](13-sorumlu-kullanim.md)).

---

**Kaynaklar:** [tinder-api-ts `src/constants.ts`, `src/tinder.ts`](https://github.com/Miguelo981/tinder-api) ·
[NastyDevs OpenAPI](https://nastydevs.github.io/tinder-api-documentation/) ·
[fbessez/Tinder](https://github.com/fbessez/Tinder)
