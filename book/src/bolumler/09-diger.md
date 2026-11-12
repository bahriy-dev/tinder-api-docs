# Diğer endpoint'ler

Bu bölüm, ana akışın dışında kalan ama kaynaklarda görülen endpoint'leri
topluyor.

## "Seni beğenenler" (Likes You) 💳

| İstek | Amaç | Durum |
| --- | --- | :---: |
| `POST /v2/fast-match/count` · `GET /v2/fast-match/count` | Seni beğenen kişi sayısı | 🟡 (tinder.py POST, fbessez GET) |
| `GET /v2/fast-match/teaser?type=recently-active` | Tek bir bulanık önizleme | 🟡 |
| `GET /v2/fast-match/teasers` | Önizleme listesi | 🟡 |
| `GET /v2/fast-match/preview` | Önizleme küçük resmi | 🔴 |
| `GET /v2/my-likes` | Beğenilerle ilgili özet | 🟡 |

> **Sınır:** Bu endpoint'ler ücretsiz hesapta yalnızca **bulanık**
> önizleme döner. Geçmişte bazı projeler, bulanık olmayan görselleri API
> açıklarıyla elde etti. Tinder bu açıkları kapattı ve böyle araçlar bu
> kitapta bilerek yer almıyor ([13. bölüm](13-sorumlu-kullanim.md)).

## Sohbet içi GIF'ler 🔴

| İstek | Amaç |
| --- | --- |
| `GET /giphy/trending?limit={n}` | Popüler GIF'ler |
| `GET /giphy/search?limit={n}&query={q}` | GIF arama |

Tinder sohbetteki GIF'ler için Giphy kullanıyor ve bu istekleri kendi
sunucusu üzerinden geçiriyor.

## Bağlı hesaplar

| İstek | Amaç | Durum |
| --- | --- | :---: |
| `GET /instagram/authorize` | Instagram bağlantısını başlat | 🔴 |
| `POST /instagram/authenticate` · `POST /instagram/deauthorize` | Instagram bağla / kaldır | 🟡 |
| `GET /v2/profile/spotify` · `PUT /v2/profile/spotify/theme` | Spotify ayarları ve profil şarkısı | 🔴 |

## Bildirimler

| İstek | Amaç | Durum |
| --- | --- | :---: |
| `PUT /v2/push/notifications` | Bildirim tercihleri (kesin işlevi belgelenmemiş) | 🟡 |
| `POST /v2/push/devices/web/{device_code}` · `DELETE …` | Web push cihazı kaydı | 🟡 |

## Raporlama

| İstek | Gövde | Durum |
| --- | --- | :---: |
| `POST /report/{user_id}` | `{"cause": <sayı>, "text": "<açıklama>"}` | 🔴 |
| `POST /report/user/{user_id}` | Benzer | 🟡 |

Rapor sebepleri sınırlı bir sayı kümesiyle ifade ediliyor. Gerçek bir sorunu
bildirmek için uygulamanın kendi raporlama ekranı her zaman daha doğru bir
seçim. Otomatik raporlama kötüye kullanıma çok açık.

## Kayıt (onboarding)

NastyDevs şemasında yeni hesap açma adımları (`/v2/onboarding/fields`,
`/v2/onboarding/photo`, `/v2/onboarding/complete`, `/v2/onboarding/user`)
belgelenmiş. Bu kitap bunları **bilerek ayrıntılandırmıyor**. Programatik
hesap açmanın neredeyse tek kullanım alanı sahte veya toplu hesap
üretmek. Hesabını uygulamadan aç.

## Diğerleri

| İstek | Amaç | Durum |
| --- | --- | :---: |
| `GET /user/{user_id}/common_connections` | Ortak bağlantılar | 🔴 |
| `POST /user/{user_id}/share` | Profil paylaşım bağlantısı | 🔴 |
| `GET /group/friends` | Facebook arkadaşları (eski "Social") | 🔴 |
| `GET /v1/activity/feed?direction=past&eventTypes=1023` | Etkinlik akışı | 🔴 |
| `POST /v2/incentives/eligibility` | Promosyon kodu uygunluğu | 🟡 |
| `POST /v2/auth/verify-captcha` | CAPTCHA doğrulama (kullanma, bkz. 2. bölüm) | 🟡 |
| `POST /v2/auth/logout` | Oturumu kapat | 🟡 |

---

**Kaynaklar:** [tinder.py](https://github.com/tiagovla/tinder.py) ·
[NastyDevs OpenAPI](https://nastydevs.github.io/tinder-api-documentation/) ·
[fbessez/Tinder](https://github.com/fbessez/Tinder) ·
[pynder](https://github.com/charliewolf/pynder)
