# Bir isteğin anatomisi

## Temel bilgiler

| | |
| --- | --- |
| Ana adres | `https://api.gotinder.com` |
| Taşıma | Yalnızca HTTPS |
| Gövde biçimi | JSON (giriş hariç; giriş protobuf kullanır) |
| Kimlik | `X-Auth-Token` başlığı |
| Dil | `?locale=tr` sorgu parametresi |

## Örnek istek

```http
GET /v2/recs/core?locale=tr&duos=0 HTTP/1.1
Host: api.gotinder.com
X-Auth-Token: 3f9c2a1e-…
Content-Type: application/json
Accept: application/json
platform: web
tinder-version: <Tinder Web sürümü>
persistent-device-id: 7b1d…
```

> Sürüm değerlerini kendi tarayıcının Network sekmesinden al. Örneğin
> tinder.py 2023'te web için `tinder-version: 2.54.0` gönderiyordu. Bu değer
> artık eskidir.

## Başlıklar

| Başlık | Zorunlu mu? | Açıklama |
| --- | :---: | --- |
| `X-Auth-Token` | ✅ | Oturum token'ı. Bütün güncel kaynaklar gönderiyor. |
| `Content-Type: application/json` | Çoğunlukla | fbessez'e göre eski `/like/{id}` ve `/pass/{id}` GET isteklerine **gönderilmemeli** (issue #63). tinder-api-ts ise her isteğe ekliyor. |
| `platform` | Önerilir | `web`, `ios` veya `android`. Gerçek istemciler her zaman gönderir. |
| `tinder-version`, `app-version` | Önerilir | Uygulama sürümü. Çok eski bir sürüm reddedilebilir veya işaretlenebilir. |
| `persistent-device-id` | Önerilir | Cihaz kimliği. Web'de `TinderWeb/uuid` değeri. |
| `User-Agent` | Önerilir | Platformla tutarlı olmalı. |
| `x-supported-image-formats` | İsteğe bağlı | `webp,jpeg`. Fotoğraf URL'lerinin biçimini etkiler. |

> **Neden önemli?** Başlıkları eksik veya tutarsız istekler otomasyon olarak
> algılanabilir. Bu, CAPTCHA'ya, `403` hatasına veya hesabın kapatılmasına yol
> açabilir. Kendi istemcinde başlıkları **tek bir yerde** tanımla ve
> tarayıcının gerçekte gönderdiklerine benzer tut.

## Sorgu parametreleri

| Parametre | Nerede | Açıklama |
| --- | --- | --- |
| `locale` | Neredeyse her yerde | Yanıttaki metinlerin dili (`tr`, `en`, `es-ES`). tinder-api-ts varsayılanı `es-ES`. |
| `include` | `GET /v2/profile` | Hangi profil bölümlerinin döneceği (bkz. [4. bölüm](04-profil.md)) |
| `count` | `/v2/matches`, `/v2/matches/{id}/messages` | Sayfa boyutu. Eşleşmede en fazla 100, mesajda tinder-api-ts varsayılanı 100. |
| `message` | `/v2/matches` | `1`: mesajlaşılmış eşleşmeler, `0`: yeni eşleşmeler |
| `s_number` | `/like`, `/pass` | Öneri kartındaki `s_number` değeri (bkz. [6. bölüm](06-etkilesimler.md)) |

> **Sayfalama:** İncelenen kaynakların hiçbiri sayfalama token'ı kullanmıyor.
> Hepsi tek bir `count` ile sınırlı liste çekiyor. Uzun listeler için
> tarayıcının Network sekmesinde yanıtın `data` nesnesindeki ek alanlara bak.

## Yanıt zarfı

`/v2/...` endpoint'leri genellikle aynı zarfı kullanır:

```json
{
  "meta": { "status": 200 },
  "data": { "...": "..." }
}
```

Öneksiz eski endpoint'ler (`/like/{id}` gibi) zarfsız düz bir nesne döner:

```json
{ "match": false, "likes_remaining": 99, "status": 200 }
```

> **İpucu:** Kendi istemcinde iki biçimi de tek bir `unwrap()` fonksiyonuyla
> normalize et: Yanıtta `data` varsa onu, yoksa gövdenin kendisini döndür.

## HTTP durum kodları

| Kod | Anlamı | Önerilen davranış |
| --- | --- | --- |
| `200` | Başarılı | – |
| `400` | Eksik veya hatalı parametre | İsteği düzelt, tekrar deneme |
| `401` | Token geçersiz veya süresi dolmuş | Refresh token ile yenile; olmazsa yeniden giriş |
| `403` | Yetki yok: premium özellik, şüpheli trafik veya CAPTCHA | **Dur.** Premium hatasıysa kullanıcıya bildir. Değilse otomasyonu kapat. |
| `404` | Endpoint veya kaynak yok | API değişmiş olabilir; güncel bir kaynakla karşılaştır |
| `429` | Hız sınırı | Üstel bekleme (ör. 2 s, 4 s, 8 s…) ve sınırlı sayıda tekrar |
| `5xx` | Sunucu hatası | Kısa beklemeyle en fazla 1–2 tekrar |

tinder-api-ts hataları türlerine göre ayırıyor. Bu iyi bir model:

| Hata sınıfı | Ne zaman oluşur |
| --- | --- |
| `TinderHttpError` | Genel HTTP hatası; `status` ve `body` alanlarını taşır |
| `TinderPremiumRequiredError` | Tercih güncellemesinde `403`: abonelik gerekiyor |
| `TinderNoBoostAvailableError` | Kullanılabilir Boost yok |
| `TinderCaptchaRequiredError` | Girişte CAPTCHA istendi |
| `TinderEmailRequiredError` | Girişte e-posta doğrulaması istendi |

## Hız ve nezaket

Tinder hız sınırlarını açıklamıyor. Topluluk deneyimine dayanan güvenli
varsayımlar:

- Ardışık istekler arasında **en az 1–3 saniye** bekle. Rastgele küçük bir
  sapma (jitter) ekle.
- Aynı anda **tek bir istek** gönder.
- `GET /v2/profile` ve `GET /v2/meta` gibi yanıtları **önbelleğe al**. Sık
  değişmezler.
- Ücretsiz hesaplarda günlük beğeni kotası var. Kalan hakkı her
  `/like` yanıtındaki `likes_remaining` alanından takip et.
- Öneri havuzu tükendiğinde (boş `results`) Tinder geçici bir "yumuşak blok"
  uygulayabilir. NastyDevs'in notlarına göre bu yaklaşık 30 dakika sürüyor.

---

**Kaynaklar:** [tinder-api-ts `src/tinder.ts`, `src/auth.ts`](https://github.com/Miguelo981/tinder-api) ·
[tinder.py `tinder/http.py`](https://github.com/tiagovla/tinder.py) ·
[fbessez/Tinder](https://github.com/fbessez/Tinder) ·
[NastyDevs notları](https://github.com/NastyDevs/tinder-api-documentation)
