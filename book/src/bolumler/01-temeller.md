# Resmî olmayan bir API'yi anlamak

## "Resmî olmayan API" ne demek?

Tinder'ın iOS, Android ve web uygulamaları verilerini aynı sunucudan alır:
`api.gotinder.com`. Uygulama ile sunucu arasındaki bu sözleşme bir API'dir,
ama dışarıya açılmamıştır:

- **Belgesi yoktur.** Bilinen her şey, trafiği izleyen geliştiricilerin
  notlarından gelir.
- **Sürüm garantisi yoktur.** Bir endpoint bir gün bile önceden haber
  verilmeden kaldırılabilir veya biçim değiştirebilir.
- **Erişim izni yoktur.** API anahtarı, OAuth uygulaması veya geliştirici
  portalı bulunmaz. Kullanılan tek kimlik, normal kullanıcı oturumudur.

Bu üç gerçek, kitabın geri kalanının çerçevesini çiziyor. Buradaki her bilgi
"belirli bir tarihte, belirli bir kaynakta böyle görüldü" anlamına gelir.

## Kısa tarihçe

| Dönem | Ne oldu | Etkisi |
| --- | --- | --- |
| 2014 | [rtt'nin gist'i](https://gist.github.com/rtt/10403467) ilk kapsamlı endpoint listesini yayınladı. | Neredeyse bütün sonraki projelerin ortak atası oldu. |
| 2014–2017 | `pynder`, `tinderjs`, `tinder_pro` gibi ilk kütüphaneler çıktı. Giriş Facebook token'ıyla yapılıyordu. | 🔴 Bu dönemin kütüphanelerinin çoğu bugün çalışmıyor. |
| 2018 | [fbessez/Tinder](https://github.com/fbessez/Tinder) belgeyi güncelledi ve en çok yıldız alan referans oldu. | `/v2/...` endpoint'leri ve SMS ile giriş belgelendi. |
| 2019–2020 | Facebook Account Kit kapandı. Tinder kendi telefon OTP akışına (`/v2/auth/sms/...`) geçti. CAPTCHA (Arkose Labs) eklendi. | Otomatik giriş zorlaştı. Topluluk tarayıcıdan token kopyalamaya yöneldi. |
| 2021–2023 | `tinder.py` (async), `tinder4j` ve NastyDevs'in OpenAPI şeması çıktı. | İlk makine tarafından okunabilir şema yayınlandı. |
| 2024–2026 | Giriş `/v3/auth/login` üzerinden **protobuf** biçimine taşındı ([Miguelo981/tinder-api](https://github.com/Miguelo981/tinder-api)). İlk MCP sunucusu yayınlandı. | Uygulama API'si büyük ölçüde JSON olarak kaldı. Değişen asıl kısım giriş katmanı oldu. |

## Mimari genel bakış

```text
┌────────────────────┐   HTTPS + JSON     ┌─────────────────────────┐
│  İstemci           │ ─────────────────▶ │ api.gotinder.com        │
│  (uygulama / web / │  X-Auth-Token      │  /v2/profile, /v2/recs, │
│   kütüphane)       │ ◀───────────────── │  /like, /v2/matches …   │
│                    │                    └─────────────────────────┘
│                    │   HTTPS + protobuf ┌─────────────────────────┐
│                    │ ─────────────────▶ │ /v3/auth/login          │
│                    │  (giriş akışı)     │  SMS, e-posta, CAPTCHA  │
│                    │                    └─────────────────────────┘
│                    │   WebSocket        ┌─────────────────────────┐
│                    │ ◀════════════════▶ │ keepalive.gotinder.com  │
└────────────────────┘  (yeni mesaj vb.)  └─────────────────────────┘
```

Üç ayrı katman var:

1. **Uygulama API'si (REST + JSON).** Profil, öneriler, beğeniler,
   eşleşmeler, mesajlar. Kitabın büyük kısmı bu katmanla ilgili.
2. **Kimlik doğrulama geçidi (protobuf).** Telefon numarasıyla giriş, OTP,
   e-posta doğrulaması ve CAPTCHA. Ayrıntısı [2. bölümde](02-kimlik-dogrulama.md).
3. **Gerçek zamanlı kanal (WebSocket).** Yeni mesaj ve eşleşme bildirimleri.
   Ayrıntısı [7. bölümde](07-eslesmeler-mesajlar.md#gerçek-zamanlı-kanal-websocket).

## Sürümlendirme

Tinder'ın yolları tutarlı bir sürüm şeması izlemiyor:

| Önek | Örnek | Durum |
| --- | --- | --- |
| *(yok)* | `/like/{id}`, `/pass/{id}`, `/user/matches/{id}`, `/boost` | 🟢 Eski görünse de 2026 kaynaklarında hâlâ kullanılıyor |
| `/v1/` | `/v1/activity/feed` | 🔴 Nadir |
| `/v2/` | `/v2/profile`, `/v2/recs/core`, `/v2/matches`, `/v2/meta` | 🟢 Ana uygulama API'si |
| `/v3/` | `/v3/auth/login` | 🟢 Yalnızca giriş |

Pratik kural: **Bir şeyin `/v2` sürümü varsa onu kullan.** Öneksiz yollar
yalnızca beğenme, geçme, mesaj gönderme ve boost gibi tek amaçlı işlemlerde
hâlâ birincil yol.

## Bilgiyi doğrulama yöntemi

Bu kitap her endpoint için üç soru soruyor:

1. **Kim belgeledi?** Belge projeleri: fbessez, NastyDevs, ultralytics, Rednit
2. **Kim kullanıyor?** Kaynak kodu: tinder-api-ts (2026), tinder.py (2023),
   pynder (2021), MCP sunucusu (2025)
3. **En son ne zaman görüldü?** Kaynağın son gönderim tarihi

Bir endpoint yalnızca bir belgede geçiyor ama hiçbir güncel kodda
kullanılmıyorsa 🟡 veya 🔴 olarak işaretlenir.

---

**Kaynaklar:** [rtt gist](https://gist.github.com/rtt/10403467) ·
[fbessez/Tinder](https://github.com/fbessez/Tinder) ·
[Miguelo981/tinder-api](https://github.com/Miguelo981/tinder-api) ·
[NastyDevs/tinder-api-documentation](https://github.com/NastyDevs/tinder-api-documentation)
