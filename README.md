<div align="center">

# Tinder API El Kitabı

**Tinder'ın resmî olmayan API'sini açık kaynak istemcilerin koduyla
karşılaştırarak anlatan Türkçe teknik kitap.**

[![Kitabı oku](https://img.shields.io/badge/kitab%C4%B1_oku-GitHub_Pages-0A7EA4?logo=mdbook&logoColor=white)](https://bahriy-dev.github.io/tinder-api-handbook/)
[![Build](https://github.com/bahriy-dev/tinder-api-handbook/actions/workflows/deploy.yml/badge.svg)](https://github.com/bahriy-dev/tinder-api-handbook/actions/workflows/deploy.yml)
[![Links](https://github.com/bahriy-dev/tinder-api-handbook/actions/workflows/links.yml/badge.svg)](https://github.com/bahriy-dev/tinder-api-handbook/actions/workflows/links.yml)
[![License: CC BY 4.0](https://img.shields.io/badge/metin-CC_BY_4.0-lightgrey.svg)](LICENSE)
[![Code: MIT](https://img.shields.io/badge/kod-MIT-blue.svg)](LICENSE-CODE)
[![Last verified](https://img.shields.io/badge/son_do%C4%9Frulama-2026--11--12-success)](book/src/ekler/c-yontem.md)

**[📖 Kitabı çevrimiçi oku](https://bahriy-dev.github.io/tinder-api-handbook/)** ·
[İçindekiler](book/src/SUMMARY.md) ·
[Referans matrisi](book/src/bolumler/10-referans-matrisi.md) ·
[English summary](#english-summary)

</div>

> [!IMPORTANT]
> Tinder'ın herkese açık bir geliştirici API'si yok. Bu kitap, uygulamanın
> kendi kullandığı özel API'yi belgeler. Otomatik erişim
> [Kullanım Koşulları](https://policies.tinder.com/terms)'nı ihlal edebilir.
> Kitap öğrenme, araştırma ve **kendi hesabın** üzerinde yapacağın kişisel
> denemeler için yazıldı. Önce
> [Sorumlu kullanım](book/src/bolumler/13-sorumlu-kullanim.md) bölümünü oku.
> Bu proje Tinder veya Match Group ile bağlantılı değildir.

## Bu kitabı farklı kılan ne?

Tinder API'si hakkındaki bilgiler GitHub'da onlarca depoya, eski gist'lere ve
issue yorumlarına dağılmış durumda. Çoğu da artık geçerli değil. Bu kitap
o bilgiyi topluyor ve **kaynak koda karşı doğruluyor**:

- 🔍 **6 birincil kaynağın kodu satır satır incelendi.** 2024 sonrası
  protobuf giriş akışı (`/v3/auth/login`) ilk kez Türkçe belgelendi.
- 🧭 **59 satırlık endpoint referans matrisi.** Her endpoint'i belgeleyen ve
  kullanan kaynaklar, metot farkları ve durumu tek tabloda.
- 🏷️ **Tazelik işaretleri.** Her bilgi 🟢 güncel, 🟡 belirsiz veya
  🔴 tarihsel olarak işaretli.
- 🐛 **Kaynaklarda bulunan hatalar.** Örneğin `tinder.py`'nin mesaj gövdesi
  `dict` yerine `set` olarak yazılmış. `tinder-mcp-server` ise aslında MCP
  SDK'sı kullanmıyor.
- 🧱 **Derlenmiş kod iskeletleri.** Güvenli varsayılanlarla (salt okunur, hız
  sınırı, devre kesici) TypeScript ve C# / .NET 8 istemcileri.
- 📚 **40 projelik doğrulanmış katalog.** Yıldız, son gönderim ve lisans
  bilgileri GitHub API'sinden alındı ve betikle yenilenebiliyor.

## İçindekiler

| # | Bölüm | Konu |
| :-: | --- | --- |
| | **Birinci kısım: Temeller** | |
| 1 | [Resmî olmayan bir API'yi anlamak](book/src/bolumler/01-temeller.md) | Tarihçe, mimari, sürümlendirme |
| 2 | [Kimlik doğrulama](book/src/bolumler/02-kimlik-dogrulama.md) | Token, `/v3` protobuf akışı, refresh, güvenli saklama |
| 3 | [Bir isteğin anatomisi](book/src/bolumler/03-istek-anatomisi.md) | Başlıklar, parametreler, yanıt zarfı, hata kodları, hız |
| | **İkinci kısım: Endpoint'ler** | |
| 4 | [Profil ve hesap](book/src/bolumler/04-profil.md) | `include` kapsamları, tercihler, `preference_filters` |
| 5 | [Keşif ve öneriler](book/src/bolumler/05-kesif.md) | `/v2/recs/core`, kart alanları, filtreli arama |
| 6 | [Etkileşimler](book/src/bolumler/06-etkilesimler.md) | Beğen, geç, Super Like, Boost ve metot farkları |
| 7 | [Eşleşmeler ve mesajlar](book/src/bolumler/07-eslesmeler-mesajlar.md) | Eşleşmeler, mesajlar, WebSocket |
| 8 | [Konum ve meta](book/src/bolumler/08-konum-meta.md) | `/v2/meta`, Passport |
| 9 | [Diğer endpoint'ler](book/src/bolumler/09-diger.md) | Fast-match, GIF, bağlı hesaplar, raporlama |
| 10 | [Referans matrisi](book/src/bolumler/10-referans-matrisi.md) | Bütün endpoint'ler ve kaynakları |
| | **Üçüncü kısım: Ekosistem ve uygulama** | |
| 11 | [Kütüphane incelemeleri](book/src/bolumler/11-kutuphaneler.md) | 7 projenin kod incelemesi ve seçim rehberi |
| 12 | [Kendi istemcini tasarlamak](book/src/bolumler/12-kendi-istemcin.md) | İlkeler, TS ve C# iskeletleri, test, MCP |
| 13 | [Sorumlu kullanım ve hukuk](book/src/bolumler/13-sorumlu-kullanim.md) | Kullanım Koşulları, KVKK, GDPR |
| A–D | [Ekler](book/src/ekler/a-katalog.md) | Proje kataloğu, sözlük, yöntem, değişiklik günlüğü |

## Hızlı başlangıç

**Bir kütüphane seçmek istiyorum:**

| Dil | Öneri |
| --- | --- |
| TypeScript / Node / Deno | [Miguelo981/tinder-api](https://github.com/Miguelo981/tinder-api) (`tinder-api-ts`) |
| Python | [tiagovla/tinder.py](https://github.com/tiagovla/tinder.py) (mesaj hatasını yamala) |
| C# / .NET | [12. bölümdeki iskelet](book/src/bolumler/12-kendi-istemcin.md#c--net-8-iskeleti) + [TinderSharp](https://github.com/ldellisola/TinderSharp) modelleri |
| Sadece anlamak | [Referans matrisi](book/src/bolumler/10-referans-matrisi.md) + [NastyDevs OpenAPI](https://nastydevs.github.io/tinder-api-documentation/) |

**Kitabı yerelde derlemek:**

```bash
cargo install mdbook --version 0.4.40
```

```bash
mdbook serve book --open
```

**Katalog verilerini yenilemek** ([GitHub CLI](https://cli.github.com/) gerekir):

```bash
./scripts/refresh-stats.sh > data/stats.tsv
```

## Depo yapısı

```text
tinder-api-handbook/
├── book/
│   ├── book.toml             # mdBook ayarları
│   └── src/
│       ├── SUMMARY.md        # İçindekiler
│       ├── bolumler/         # 13 bölüm
│       └── ekler/            # Katalog, sözlük, yöntem, değişiklikler
├── data/
│   ├── projects.csv          # Katalogdaki projeler ve kategorileri
│   └── stats.tsv             # Son doğrulanan GitHub meta verileri
├── scripts/
│   └── refresh-stats.sh      # Meta verileri GitHub API'den yeniler
└── .github/                  # CI (Pages, bağlantı kontrolü), şablonlar
```

## Katkı

Hata, eskimiş bir endpoint veya eklenmesi gereken bir proje mi buldun?
[CONTRIBUTING.md](CONTRIBUTING.md) dosyasını oku ve bir
[issue](https://github.com/bahriy-dev/tinder-api-handbook/issues/new/choose)
aç. Token, telefon numarası veya gerçek profil içeren hiçbir şeyi paylaşma.
Güvenlik konuları için [SECURITY.md](SECURITY.md).

## Lisans

- **Kitap metni:** [CC BY 4.0](LICENSE). Kaynak göstererek paylaşabilir ve
  uyarlayabilirsin.
- **Kod örnekleri ve betikler:** [MIT](LICENSE-CODE)
- Kitapta adı geçen projelerin her biri kendi lisansına tabidir.

Atıf için: [CITATION.cff](CITATION.cff)

*Tinder, Match Group, LLC'nin ticari markasıdır; burada yalnızca anlatılan
sistemi tanımlamak için kullanılmıştır.*

---

## English summary

**Tinder API Handbook** is a Turkish-language technical book about Tinder's
private, undocumented API. It cross-checks six primary open-source sources at
the code level. It covers the 2024+ protobuf login flow (`/v3/auth/login`),
gives a 59-row endpoint matrix with per-source method differences, reviews
seven libraries in depth (and reports bugs found in them), and includes
compiled TypeScript and C# client skeletons with safe defaults. It ends with
a verified catalog of 40 projects. Read it at
**[bahriy-dev.github.io/tinder-api-handbook](https://bahriy-dev.github.io/tinder-api-handbook/)**.
For personal, educational use on your own account only. This project is not
affiliated with Tinder or Match Group.
