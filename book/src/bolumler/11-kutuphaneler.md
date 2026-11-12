# Kütüphane incelemeleri

Bu bölümde en önemli yedi proje ayrıntılı olarak inceleniyor. İncelemeler
README'ye değil **kaynak koda** dayanıyor. Hiçbiri canlı API ile
çalıştırılmadı. Bütün projelerin listesi için [Ek A](../ekler/a-katalog.md).

## Özet karşılaştırma

| | tinder-api-ts | tinder.py | pynder | MCP sunucusu | NastyDevs | fbessez | TinderSharp |
| --- | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| Dil | TypeScript | Python | Python | TypeScript | OpenAPI | Markdown + Python | C# |
| Son gönderim | 2026-07 | 2023-11 | 2021-06 | 2025-05 | 2025-03 | 2023-01 | 2022-12 |
| Güncel giriş akışı | ✅ `/v3` | ➖ yalnızca token | ❌ Facebook | ❌ `/v2` | ➖ `/v2` | ❌ | ❌ |
| Tipler / modeller | ✅ | ✅ | ✅ | ✅ Zod | ✅ şema | ❌ | ✅ |
| Hata türleri | ✅ | ✅ | ➖ | ✅ | – | – | ➖ |
| Hız sınırlama / yeniden deneme | ❌ | ➖ 5xx'te 3 deneme | ❌ | ✅ | – | – | ❌ |
| Testler | ✅ | ✅ | ❌ | ✅ | – | – | ❌ |
| Lisans | MIT | GPL-3.0 | Özel | Belirsiz | Yok | MIT | Unlicense |
| Genel not | **A** | **B** | **C** (tarihsel) | **C** | **B** (referans) | **B** (tarihsel) | **C** |

---

## 1. Miguelo981/tinder-api (`tinder-api-ts`)

**Ne?** Node.js ve Deno için TypeScript istemcisi. npm'de `tinder-api-ts`,
JSR'de `@miguelo/tinder-api` adıyla yayınlanıyor.

**Neden önemli?** İncelenen projeler içinde 2024 sonrası protobuf giriş
akışını uygulayan **tek** açık kaynak kod.

| Özellik | Durum |
| --- | --- |
| SMS ile giriş + e-posta doğrulaması (`LoginSession`) | ✅ `/v3/auth/login` |
| CAPTCHA'yı algılama | ✅ `TinderCaptchaRequiredError` fırlatıyor; çözmeye çalışmıyor |
| Profil okuma (kapsamlarla) | ✅ |
| Tercih güncelleme (iki endpoint) | ✅ km/mil dönüşümüyle |
| Öneriler, beğenme, geçme, Super Like | ✅ |
| Eşleşmeler, mesaj okuma ve gönderme | ✅ |
| Konum (`/v2/meta`), Boost | ✅ |
| Proxy desteği | ✅ Deno `HttpClient` / undici `ProxyAgent` |
| Hız sınırlama, yeniden deneme | ❌ Kullanıcıya bırakılmış |

**Kod kalitesi.** Uç noktalar tek bir `TINDER_ROUTER` sabitinde toplanmış.
İstek yapan tek bir `request()` fonksiyonu var. HTTP hataları türlerine
ayrılıyor. `searchWithFilters`, tercihleri geri yüklemek için `try/finally`
benzeri bir desen kullanıyor. Protobuf kodlayıcısı elle yazılmış ve küçük
(85 satır). Şema değişirse kırılabilir.

**Dikkat:** Varsayılan `locale` değeri `es-ES`. Türkçe yanıt için her
istekte `locale: "tr"` ver veya `baseOptions.defaultLocale` ayarla.

```ts
import { TinderAPI } from "tinder-api-ts";

const tinder = new TinderAPI({
  xAuthToken: process.env.TINDER_AUTH_TOKEN!,
  baseOptions: { defaultLocale: "tr" },
});

const { data } = await tinder.getMatches({ count: 20, message: 1 });
console.log(data.data.matches.length, "eşleşme");
```

**Karar:** Yeni bir JS/TS projesi için en iyi başlangıç noktası. Lisansı
MIT, kodunu okuyup kendi istemcine uyarlayabilirsin.

---

## 2. tiagovla/tinder.py

**Ne?** discord.py'den esinlenmiş, `asyncio` tabanlı Python istemcisi.
PyPI'da `tinder.py` adıyla yayınlanıyor; Read the Docs'ta belgesi var.

| Özellik | Durum |
| --- | --- |
| Giriş | Tarayıcıdan kopyalanan token ile |
| Öneriler (`/v2/recs/core`), beğenme, geçme | ✅ |
| Eşleşmeler, eşleşmeyi kaldırma | ✅ |
| Mesaj gönderme | ⚠️ **Hatalı** (aşağıya bak) |
| Beğeni önizlemeleri (`fast-match`), `my-likes`, `explore` | ✅ |
| WebSocket | ➖ Bağlanıyor ve ping atıyor; olayları çözmüyor |
| Konum (`/v2/meta`) | ✅ |
| Hız sınırlama | ➖ `429` desteği yok; yalnızca `500/502`'de artan beklemeyle 3 deneme. `403` ve `404` ayrı hata türleri. |

**Bulunan hata.** `http.py` içindeki `send_message`:

```python
payload = {"message", message}   # ❌ Bu bir set, dict değil
payload = {"message": message}   # ✅ Doğrusu
```

Ayrıca kaynakta bir `TODO` yorumu var: `/v2/matches/{id}/messages`, `/like/{id}/super` gibi endpoint'ler henüz desteklenmiyor.

**Karar:** Async mimarisi ve modelleri iyi, ama 2023'ten beri
güncellenmedi. GPL-3.0 lisansı nedeniyle kodunu kopyalarsan senin projenin de
GPL olması gerekir. Mimarisinden ilham al, kodunu kopyalama.

---

## 3. charliewolf/pynder

**Ne?** En bilinen Python istemcisi (600+ yıldız).

**Durum.** Giriş Facebook token'ına dayalı (`POST /auth`). Endpoint'lerin
çoğu öneksiz eski yollar (`/user/recs`, `/updates`, `/user/ping`). 2021'den
beri güncellenmedi. **Bugün çalışması beklenmez.**

**Değeri.** [Issue takibi](https://github.com/charliewolf/pynder/issues),
2015–2021 arası API değişikliklerinin en zengin kaydı. Bir endpoint'in ne
zaman, nasıl değiştiğini araştırırken ilk bakılacak yer.

**Karar:** Tarihsel referans. Yeni projede kullanma.

---

## 4. glassBead-tc/tinder-mcp-server

**Ne?** README'ye göre Tinder API'si için bir Model Context Protocol (MCP)
sunucusu.

**Kaynak kodunda görülenler:**

| İddia | Gerçek |
| --- | --- |
| "MCP server" | Resmî MCP SDK'sı (`@modelcontextprotocol/sdk`) **kullanılmıyor**. Sunucu, `/mcp/...` yolları olan bir **Express HTTP** sunucusu. Bir MCP istemcisi (ör. Claude) buna doğrudan bağlanamaz. Arada bir köprü gerekir. |
| Kimlik doğrulama | Eski `/v2/auth/sms/...` ve `/v2/auth/login/facebook` akışları. Güncel `/v3` akışı yok. |
| CAPTCHA | `/v2/auth/verify-captcha` çağrısını içeriyor. Bu kitabın önerdiği "dur" yaklaşımına ters. |
| Lisans | `package.json`'da MIT yazıyor, ama depoda LICENSE dosyası yok |
| Kurulum | README'deki klonlama adresinde hâlâ `yourusername` yer tutucusu duruyor |
| Kalite | Zod şemaları, hız sınırlayıcı, önbellek ve kapsamlı test dosyaları var |

**Karar:** Mimari fikirler (şema doğrulama, önbellek, hız sınırlama) için
okunmaya değer. Olduğu gibi kullanılacak bir ürün değil. Gerçek bir MCP
entegrasyonu için resmî SDK ile, salt okunur araçlardan oluşan küçük bir
sunucu yazmak daha doğru ([12. bölüm](12-kendi-istemcin.md#yapay-zekâ-ajanları-için-mcp-notları)).

---

## 5. NastyDevs/tinder-api-documentation

**Ne?** `tinder-api-swagger.yaml`: Tinder API'si için yazılmış **tek OpenAPI
şeması**. [Web sayfası](https://nastydevs.github.io/tinder-api-documentation/)
olarak da açılabiliyor.

**Güçlü yanları:** 39 yol ve metot kombinasyonu; hesap yönetimi, push ve
Instagram gibi başka yerde olmayan endpoint'ler; README'deki pratik notlar
(OTP davranışı, refresh token yenilenmesi, yumuşak blok süresi, hesap
silme cezası).

**Zayıf yanları:** Birçok endpoint `summary: TODO`. Giriş akışı `/v2`
döneminde kalmış. Lisans dosyası yok.

**Kullanım ipucu:** Şemayı bir OpenAPI üreticisine (ör. `openapi-generator`,
NSwag) verip tipli bir istemci iskeleti oluşturabilirsin. Ama üretilen kodu
mutlaka tinder-api-ts ile karşılaştır, çünkü `like` ve `pass` metotları
farklı.

---

## 6. fbessez/Tinder

**Ne?** 2018–2019 tarihli, en çok yıldız alan (860+) endpoint belgesi ve
küçük bir Python sarmalayıcısı.

**Değeri:** Ücretli özellikler (`hide_age`, `blend`, Passport), Spotify,
iş/okul ve kullanıcı adı gibi başka hiçbir kaynağın belgelemediği alanlar.
Topluluğun ortak dili büyük ölçüde bu belgeden geliyor.

**Dikkat:** İçerik 2018–2019'da kalmış. Belgedeki `GET /like/{id}` artık
`POST`, `/user/ping` artık `/v2/meta`.

---

## 7. ldellisola/TinderSharp

**Ne?** .NET Standard 2.0 için C# sarmalayıcısı (Unlicense, yani kamu malı).

**Durum:** 2022'den beri güncellenmedi. Giriş modelleri Facebook ve `/v2` SMS dönemine ait (`FacebookAuthentication`, `SMSAuthentication`). Test projesi yok, yalnızca bir `SandBox` konsol uygulaması var. Eşleşme yanıtları için özel bir JSON dönüştürücüsü (`MatchResponseConverter`) içeriyor.

**Değeri:** .NET ekosisteminde tek ciddi örnek. Unlicense olduğu için model
sınıflarını serbestçe alıp `System.Text.Json` ve `HttpClient` tabanlı modern
bir .NET 8+ istemcisine taşıyabilirsin. [12. bölüm](12-kendi-istemcin.md)
bunun için bir iskelet veriyor.

---

## Seçim rehberi

```text
Dil?
├── TypeScript / Node / Deno ──▶ tinder-api-ts
├── Python ──────────────────▶ tinder.py (mesaj hatasını yamala)
│                              veya NastyDevs şemasından istemci üret
├── C# / .NET ───────────────▶ Kendi istemcin (12. bölüm)
│                              + TinderSharp modelleri
└── Yalnızca anlamak ────────▶ Bu kitap + NastyDevs + fbessez
```
