# Endpoint referans matrisi

Bu tablo, kitapta geçen her endpoint'i kaynaklarıyla birlikte gösteriyor.
Bir hücredeki ✓ işareti, o kaynağın endpoint'i **belgelediği veya kodunda
kullandığı** anlamına gelir.

**Kaynaklar ve son gönderim tarihleri**

| Kısaltma | Kaynak | Tür | Son gönderim |
| --- | --- | --- | --- |
| **TS** | [Miguelo981/tinder-api](https://github.com/Miguelo981/tinder-api) | Kod | 2026-07 |
| **PY** | [tiagovla/tinder.py](https://github.com/tiagovla/tinder.py) | Kod | 2023-11 |
| **ND** | [NastyDevs/tinder-api-documentation](https://github.com/NastyDevs/tinder-api-documentation) | OpenAPI | 2025-03 |
| **FB** | [fbessez/Tinder](https://github.com/fbessez/Tinder) | Belge | 2023-01 (içerik 2018–2019) |
| **PN** | [charliewolf/pynder](https://github.com/charliewolf/pynder) | Kod | 2021-06 |

## Kimlik doğrulama

| Metot | Yol | TS | PY | ND | FB | PN | Durum | Bölüm |
| --- | --- | :-: | :-: | :-: | :-: | :-: | :-: | --- |
| POST | `/v3/auth/login` (protobuf) | ✓ | | | | | 🟢 | [2](02-kimlik-dogrulama.md) |
| POST | `/v2/auth/sms/send` | | | ✓ | ✓ | | 🟡 | [2](02-kimlik-dogrulama.md) |
| POST | `/v2/auth/sms/validate` | | | ✓ | ✓ | | 🟡 | [2](02-kimlik-dogrulama.md) |
| POST | `/v2/auth/login/sms` | | | ✓ | ✓ | | 🟡 | [2](02-kimlik-dogrulama.md) |
| POST | `/v2/auth/login/facebook` | | | ✓ | | | 🔴 | [2](02-kimlik-dogrulama.md) |
| POST | `/auth` (Facebook) | | | | ✓ | ✓ | 🔴 | [2](02-kimlik-dogrulama.md) |
| POST | `/v2/auth/verify-captcha` | | | ✓ | | | 🟡 | [9](09-diger.md) |
| POST | `/v2/auth/logout` | | | ✓ | | | 🟡 | [9](09-diger.md) |

## Profil ve hesap

| Metot | Yol | TS | PY | ND | FB | PN | Durum | Bölüm |
| --- | --- | :-: | :-: | :-: | :-: | :-: | :-: | --- |
| GET | `/v2/profile?include=…` | ✓ | | ✓ | | | 🟢 | [4](04-profil.md) |
| POST | `/v2/profile` | ✓ | | ✓ | | | 🟢 | [4](04-profil.md) |
| POST | `/v2/profile/user` | ✓ | | | | | 🟢 💳 | [4](04-profil.md) |
| DELETE | `/v2/profile` ⚠️ | | | ✓ | | | 🟡 | [4](04-profil.md) |
| GET / POST | `/profile` | | ✓ | | ✓ | ✓ | 🔴 | [4](04-profil.md) |
| PUT / DELETE | `/profile/job`, `/profile/school` | | | | ✓ | | 🔴 | [4](04-profil.md) |
| POST | `/v2/profile/job`, `/v2/profile/school` | | | ✓ | | | 🟡 | [4](04-profil.md) |
| PUT / DELETE | `/profile/username` | | | | ✓ | | 🔴 | [4](04-profil.md) |
| GET | `/profile/photos` | | | ✓ | | | 🟡 | [4](04-profil.md) |
| DELETE | `/media` | | | ✓ | | | 🟡 | [4](04-profil.md) |
| POST | `/v2/profile/email_settings` | | | ✓ | | | 🟡 | [4](04-profil.md) |
| POST | `/v2/account/account-email/confirm` | | | ✓ | | | 🟡 | [4](04-profil.md) |
| POST | `/v2/account/recovery/send` | | | ✓ | | | 🟡 | [4](04-profil.md) |
| GET | `/user/{id}` | | ✓ | ✓ | ✓ | ✓ | 🟡 | [4](04-profil.md) |

## Keşif ve etkileşim

| Metot | Yol | TS | PY | ND | FB | PN | Durum | Bölüm |
| --- | --- | :-: | :-: | :-: | :-: | :-: | :-: | --- |
| GET | `/v2/recs/core` | ✓ | ✓ | ✓ | | | 🟢 | [5](05-kesif.md) |
| GET | `/user/recs` | | ✓ | | ✓ | ✓ | 🔴 | [5](05-kesif.md) |
| GET | `/v2/explore` | | ✓ | | | | 🟡 | [5](05-kesif.md) |
| POST (TS, PY) · GET (ND, FB) | `/like/{id}` | ✓ | ✓ | ✓ | ✓ | ✓ | 🟢 | [6](06-etkilesimler.md) |
| GET (TS, ND, FB) · POST (PY) | `/pass/{id}` | ✓ | ✓ | ✓ | ✓ | ✓ | 🟢 | [6](06-etkilesimler.md) |
| POST | `/like/{id}/super` | ✓ | | ✓ | ✓ | ✓ | 🟢 💳 | [6](06-etkilesimler.md) |
| POST | `/boost` | ✓ | | ✓ | | | 🟢 💳 | [6](06-etkilesimler.md) |
| POST | `/message/{id}/like` | | | | ✓ | ✓ | 🔴 | [6](06-etkilesimler.md) |

## Eşleşmeler ve mesajlar

| Metot | Yol | TS | PY | ND | FB | PN | Durum | Bölüm |
| --- | --- | :-: | :-: | :-: | :-: | :-: | :-: | --- |
| GET | `/v2/matches` | ✓ | ✓ | ✓ | ✓ | | 🟢 | [7](07-eslesmeler-mesajlar.md) |
| GET | `/v2/matches/{id}/messages` | ✓ | | | | | 🟢 | [7](07-eslesmeler-mesajlar.md) |
| POST | `/user/matches/{id}` (gönder) | ✓ | ✓ | | ✓ | ✓ | 🟢 | [7](07-eslesmeler-mesajlar.md) |
| DELETE | `/user/matches/{id}` (eşleşmeyi kaldır) | | ✓ | | ✓ | | 🟢 | [7](07-eslesmeler-mesajlar.md) |
| GET | `/matches/{id}` | | | | ✓ | | 🟡 | [7](07-eslesmeler-mesajlar.md) |
| GET | `/message/{id}` | | | | ✓ | | 🟡 | [7](07-eslesmeler-mesajlar.md) |
| POST / GET | `/updates` | | ✓ | | ✓ | ✓ | 🔴 | [7](07-eslesmeler-mesajlar.md) |
| GET | `/ws/generate` + `wss://keepalive.gotinder.com/ws` | | ✓ | ✓ | | | 🟡 | [7](07-eslesmeler-mesajlar.md) |

## Konum ve meta

| Metot | Yol | TS | PY | ND | FB | PN | Durum | Bölüm |
| --- | --- | :-: | :-: | :-: | :-: | :-: | :-: | --- |
| POST | `/v2/meta` (konum + meta) | ✓ | ✓ | ✓ | | | 🟢 | [8](08-konum-meta.md) |
| GET | `/v2/meta`, `/meta` | | | | ✓ | ✓ | 🔴 | [8](08-konum-meta.md) |
| POST | `/user/ping` | | | | ✓ | ✓ | 🔴 | [8](08-konum-meta.md) |
| POST | `/passport/user/travel`, `/passport/user/reset` | | | | ✓ | | 🔴 💳 | [8](08-konum-meta.md) |
| GET | `/location/popular` | | | ✓ | | | 🟡 | [8](08-konum-meta.md) |

## Diğer

| Metot | Yol | TS | PY | ND | FB | PN | Durum | Bölüm |
| --- | --- | :-: | :-: | :-: | :-: | :-: | :-: | --- |
| POST / GET | `/v2/fast-match/count` | | ✓ | | ✓ | | 🟡 💳 | [9](09-diger.md) |
| GET | `/v2/fast-match/teaser(s)` | | ✓ | | | | 🟡 | [9](09-diger.md) |
| GET | `/v2/fast-match/preview` | | | | ✓ | | 🔴 | [9](09-diger.md) |
| GET | `/v2/my-likes` | | ✓ | | | | 🟡 | [9](09-diger.md) |
| PUT | `/v2/push/notifications` | | ✓ | ✓ | | | 🟡 | [9](09-diger.md) |
| POST / DELETE | `/v2/push/devices/web/{code}` | | | ✓ | | | 🟡 | [9](09-diger.md) |
| GET | `/giphy/trending`, `/giphy/search` | | | | ✓ | | 🔴 | [9](09-diger.md) |
| GET / POST | `/instagram/…` | | | ✓ | ✓ | | 🔴 | [9](09-diger.md) |
| GET / PUT | `/v2/profile/spotify…` | | | | ✓ | | 🔴 | [9](09-diger.md) |
| POST | `/report/{id}`, `/report/user/{id}` | | | ✓ | ✓ | ✓ | 🔴 | [9](09-diger.md) |
| GET | `/user/{id}/common_connections` | | | | ✓ | | 🔴 | [9](09-diger.md) |
| POST | `/user/{id}/share` | | | | | ✓ | 🔴 | [9](09-diger.md) |
| GET | `/group/friends` | | | | | ✓ | 🔴 | [9](09-diger.md) |
| GET | `/v1/activity/feed` | | | | ✓ | | 🔴 | [9](09-diger.md) |
| POST | `/v2/incentives/eligibility` | | | ✓ | | | 🟡 | [9](09-diger.md) |
| – | `/v2/onboarding/…` (kayıt) | | | ✓ | | | Bilerek kapsam dışı | [9](09-diger.md) |

## Kapsama özeti

| Kaynak | Matriste işaretli satır sayısı | Güçlü olduğu alan |
| --- | ---: | --- |
| TS | 13 | Güncel giriş, profil ve tercihler, temel akış |
| PY | 17 | Eşleşmeler, beğeni önizlemeleri, WebSocket |
| ND | 31 | Geniş kapsam, hesap yönetimi, makine tarafından okunabilir şema |
| FB | 30 | Tarihsel genişlik, ücretli özellikler |
| PN | 15 | Erken dönem çekirdek akış |
