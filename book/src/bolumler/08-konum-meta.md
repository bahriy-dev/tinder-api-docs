# Konum, meta ve Passport

## Konum güncellemek

Konum endpoint'i zaman içinde en çok değişen alanlardan biri:

| Dönem | İstek | Gövde | Durum |
| --- | --- | --- | :---: |
| 2014–2020 | `POST /user/ping` | `{"lat": 41.01, "lon": 28.97}` | 🔴 |
| 2021– | `POST /v2/meta` | `{"lat": 41.01, "lon": 28.97}` | 🟢 |

tinder-api-ts'deki `setLocation`, `POST /v2/meta?locale=tr` kullanıyor. Yani
konum güncellemesi ile hesap meta verisini almak **aynı istekte** oluyor.

> **Konum hassas bir veridir.** Konumunu sık ve tutarsız biçimde değiştirmek
> (ör. birkaç dakika içinde farklı şehirler) şüpheli davranış olarak
> işaretlenebilir. NastyDevs bu yolla ücretsiz "konum değiştirme"
> yapılabildiğini not ediyor. Bu, ücretli Passport özelliğini atlatmak
> anlamına gelir. Kitabın kurallarına göre yapılmaması gereken bir şey.

## Meta yanıtı 🟢

`POST /v2/meta` yanıtı hesabın durumuna dair geniş bir özet döner:

| Bölüm | İçerik |
| --- | --- |
| `readreceipts` | Okundu bilgisi açık mı |
| `profile` | Düzenleme sınırları: `can_edit_jobs`, `can_edit_email`, `school_name_max_length`, `job_title_max_length`… |
| `super_like` | Super Like etkin mi, `alc_mode` |
| `location_prechecks` | Konumla ilgili ön kontrol kodları |
| `age_verification` | Yaş doğrulama durumu |
| `biometric_consent` | Biyometrik veri (ör. fotoğraf doğrulama) izni |
| `voter_registration` | ABD'ye özel seçmen kaydı bilgilendirmesi |

Eski `GET /meta` endpoint'i (🔴) kalan kaydırma hakkı ve görülen kişi
sayısı gibi verileri dönüyordu. `GET /v2/meta` (🟡) buna "Top Picks" gibi ek
bilgiler ekliyordu.

## Passport (seyahat modu) 💳 🔴

| İstek | Gövde | Amaç |
| --- | --- | --- |
| `POST /passport/user/travel` | `{"lat": …, "lon": …}` | Kaydırma konumunu başka bir şehre taşı |
| `POST /passport/user/reset` | `{}` | Gerçek konuma dön |

Ücretli abonelik gerektirir. Kaynaklar 2018 tarihli.

## Popüler yerler 🟡

```http
GET /location/popular
```

NastyDevs'e göre Passport ekranındaki popüler şehir listesini döner.

---

**Kaynaklar:** [tinder-api-ts `src/constants.ts`, `src/interfaces/location.ts`](https://github.com/Miguelo981/tinder-api) ·
[fbessez/Tinder](https://github.com/fbessez/Tinder) ·
[NastyDevs](https://github.com/NastyDevs/tinder-api-documentation)
