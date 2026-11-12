# Kimlik doğrulama

Uygulama API'sine yapılan neredeyse her istek tek bir başlıkla doğrulanır:

```http
X-Auth-Token: 3f9c2a1e-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

Bu token bir UUID biçimindedir ve **hesabına tam erişim** sağlar: profil,
eşleşmeler, mesajlar, konum. Bu bölüm token'ın nasıl elde edildiğini ve
nasıl korunması gerektiğini anlatıyor.

> **Uyarı:** Token'ını hiçbir web sitesine, issue'ya, ekran görüntüsüne veya
> git deposuna koyma. Token'ı ele geçiren kişi senin adına mesaj okuyup
> gönderebilir.

## Giriş yöntemlerinin evrimi

| Dönem | Yöntem | Endpoint | Durum |
| --- | --- | --- | :---: |
| 2014–2019 | Facebook access token ile token değişimi | `POST /auth`, sonra `POST /v2/auth/login/facebook` | 🔴 |
| 2018–2020 | Facebook Account Kit ile SMS | `POST /auth/login/accountkit` | 🔴 Account Kit kapandı |
| 2019–2023 | Tinder'ın kendi SMS OTP akışı (JSON) | `POST /v2/auth/sms/send`, `/v2/auth/sms/validate`, `/v2/auth/login/sms` | 🟡 |
| 2024– | Protobuf tabanlı kimlik geçidi | `POST /v3/auth/login` | 🟢 |
| Her dönem | Tarayıcıdan kendi token'ını kopyalamak | – | 🟢 En sağlam yol |

## Yöntem 1: Tarayıcıdan kendi token'ını almak (önerilen)

Kişisel deneyler için en basit, en az kırılgan ve CAPTCHA'ya takılmayan yol
budur. `tinder-api-ts` ve `tinder.py` de bu yolu önerir.

1. [tinder.com](https://tinder.com) adresinde **kendi hesabınla** normal
   şekilde giriş yap.
2. Geliştirici araçlarını aç (`F12` veya `Cmd+Option+I`).
3. **Application → Local Storage → `https://tinder.com`** bölümüne git.
4. Şu anahtarları bul:

| Anahtar | İçerik | Kullanım |
| --- | --- | --- |
| `TinderWeb/APIToken` | `X-Auth-Token` değeri | Bütün uygulama API istekleri |
| `TinderWeb/uuid` | Kalıcı cihaz kimliği | `persistent-device-id` başlığı |
| Yenileme token'ı (anahtar adı değişebilir) | Refresh token | Süre dolunca yeni token almak |

Token'ı bir ortam değişkenine koy, koda asla gömme:

```bash
# .env (bu dosyayı .gitignore'a eklemeyi unutma)
TINDER_AUTH_TOKEN=...
TINDER_DEVICE_ID=...
```

## Yöntem 2: Protobuf kimlik geçidi (`/v3/auth/login`) 🟢

2024'ten bu yana mobil uygulama, girişi tek bir endpoint üzerinden ve JSON
yerine **Protocol Buffers** ile yapıyor. Bu akışın açık kaynaktaki tek
güncel uygulaması [tinder-api-ts](https://github.com/Miguelo981/tinder-api)
paketindeki `LoginSession` sınıfı (`src/auth.ts`).

### Akış

```text
İstemci                                   /v3/auth/login
  │  1. PhoneRequest(telefon)                    │
  │ ───────────────────────────────────────────▶ │
  │ ◀─────────────── SmsSent(maskeli tel, OTP uzunluğu)
  │                                              │
  │  2. OtpRequest(telefon, sms_kodu)            │
  │ ───────────────────────────────────────────▶ │
  │ ◀──── a) Success(auth_token, refresh_token, user_id)
  │ ◀──── b) EmailRequired(maskeli e-posta, jwt)  ──┐
  │ ◀──── c) CaptchaRequired(Arkose)  → DUR         │
  │                                                 │
  │  3. EmailCode(e-posta_kodu, jwt)   ◀────────────┘
  │ ───────────────────────────────────────────▶ │
  │ ◀──────────── Success(auth_token, refresh_token, user_id)
```

### İstek özellikleri

| Özellik | Değer (tinder-api-ts, Temmuz 2026) |
| --- | --- |
| Metot ve yol | `POST /v3/auth/login?locale=tr` |
| `Content-Type` / `Accept` | `application/x-protobuf` |
| İstemci kimliği | `platform: ios`, `tinder-version`, `app-version`, iOS `User-Agent` |
| Oturum başlıkları | `persistent-device-id`, `app-session-id`, `funnel-session-id`, `app-session-time-elapsed` |
| Gövde | Bir `AuthGatewayRequest` protobuf mesajı (telefon, OTP veya e-posta kodu alt mesajı) |
| Yanıt | Bir `AuthGatewayResponse` mesajı: `sms_sent`, `success`, `email_required` veya `captcha` alanlarından biri |

`.proto` şeması yayınlanmadığı için tinder-api-ts, mesajları elle yazılmış
küçük bir protobuf kodlayıcısıyla (`src/protobuf.ts`) oluşturuyor. Bu yüzden
alan numaraları değişirse akış sessizce bozulabilir. Kendi kodunda yanıtta
beklediğin alan yoksa **açık bir hata fırlat**.

### Üç olası sonuç

| Yanıt | Anlamı | Ne yapmalı |
| --- | --- | --- |
| **Success** | `auth_token` + `refresh_token` döndü | İkisini de güvenle sakla |
| **EmailRequired** | Hesabın e-postasına ek kod gönderildi; yanıtta bir `jwt` var | Kullanıcıdan e-posta kodunu al, `jwt` ile birlikte gönder |
| **CaptchaRequired** | Sunucu trafiği şüpheli buldu (Arkose Labs) | **Dur.** Tarayıcıdan normal giriş yap ve Yöntem 1'e geç. CAPTCHA'yı otomatik çözmeye çalışmak Kullanım Koşulları'nın açık ihlalidir. |

## Yöntem 3: JSON SMS akışı (`/v2/auth/...`) 🟡

2019–2023 kaynaklarında belgelenen eski akış. Yeni projelerde kullanma, ama
eski kodu okurken işine yarar:

| Adım | İstek | Gövde | Yanıttan alınan |
| --- | --- | --- | --- |
| 1 | `POST /v2/auth/sms/send?auth_type=sms` | `{"phone_number": "905…"}` | – |
| 2 | `POST /v2/auth/sms/validate?auth_type=sms` | `{"otp_code": "123456", "phone_number": "905…"}` | `refresh_token` |
| 3 | `POST /v2/auth/login/sms` | `{"refresh_token": "…"}` | `api_token` (= `X-Auth-Token`) |

*Kaynaklar: fbessez/Tinder, NastyDevs OpenAPI şeması, meister245/tinder-token*

## Token yaşam döngüsü

- `X-Auth-Token` **sınırlı süre** geçerlidir. Süre dolunca istekler
  `401 Unauthorized` döner.
- NastyDevs'in notlarına göre refresh token ile yeni token alındığında
  **refresh token da yenilenir**. Her seferinde yeni çifti sakla. Eski
  refresh token'ı tekrar kullanma.
- Web'den çıkış yapmak (`POST /v2/auth/logout`) token'ı geçersiz kılar.

```text
         ┌─────────── 401 ───────────┐
         ▼                           │
 [refresh_token] ──▶ yeni çift ──▶ [auth_token] ──▶ istekler
         ▲                │
         └── sakla ◀──────┘
```

## Güvenli saklama kontrol listesi

- [ ] Token ortam değişkeninde veya işletim sisteminin anahtar zincirinde
      (macOS Keychain, Windows Credential Manager) duruyor
- [ ] `.env` dosyası `.gitignore`'da
- [ ] Loglarda token maskeleniyor (`3f9c…xxxx`)
- [ ] Hata raporlarında istek başlıkları gizleniyor
- [ ] Token yalnızca `https://api.gotinder.com` adresine gönderiliyor

---

**Kaynaklar:** [tinder-api-ts `src/auth.ts`](https://github.com/Miguelo981/tinder-api) ·
[NastyDevs OpenAPI](https://nastydevs.github.io/tinder-api-documentation/) ·
[fbessez/Tinder](https://github.com/fbessez/Tinder) ·
[meister245/tinder-token](https://github.com/meister245/tinder-token)
