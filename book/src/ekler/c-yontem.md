# Ek C: Yöntem ve kaynaklar

## Kitap nasıl hazırlandı?

**1. Tarama (12 Kasım 2026).** GitHub CLI ile yıldıza göre sıralanmış
aramalar yapıldı: `tinder api`, `tinder-api`, `tinder client`, `tinder bot`,
`pynder`, `tinder python`, `tinder sdk`. Ardından dokümantasyon projelerindeki
bağlantılar takip edildi.

**2. Eleme.** Değişiklik içermeyen fork'lar, kopyalar, ilgisiz projeler ve
[13. bölümdeki](../bolumler/13-sorumlu-kullanim.md#kitapta-bilerek-yer-almayanlar)
kategorilere giren projeler çıkarıldı.

**3. Meta veri doğrulaması.** Kalan 40 proje için yıldız sayısı, son gönderim
tarihi, arşiv durumu ve lisans GitHub REST API'sinden okundu
(`gh api repos/{owner}/{repo}`). `scripts/refresh-stats.sh` bu adımı
tekrarlıyor.

**4. Kaynak kod incelemesi.** Altı birincil kaynak klonlanıp endpoint'ler,
başlıklar, gövdeler ve hata işleme kodu doğrudan okundu:

| Kaynak | İncelenen dosyalar |
| --- | --- |
| [Miguelo981/tinder-api](https://github.com/Miguelo981/tinder-api) | `src/constants.ts`, `src/tinder.ts`, `src/auth.ts`, `src/protobuf.ts`, `src/adapters/update-profile.ts`, `src/interfaces/*` |
| [tiagovla/tinder.py](https://github.com/tiagovla/tinder.py) | `tinder/http.py`, `tinder/gateway.py` |
| [charliewolf/pynder](https://github.com/charliewolf/pynder) | `pynder/api.py`, `pynder/models/user.py` |
| [glassBead-tc/tinder-mcp-server](https://github.com/glassBead-tc/tinder-mcp-server) | `src/index.ts`, `src/config/index.ts`, `src/services/*`, `package.json` |
| [NastyDevs/tinder-api-documentation](https://github.com/NastyDevs/tinder-api-documentation) | `tinder-api-swagger.yaml`, `README.md` |
| [fbessez/Tinder](https://github.com/fbessez/Tinder) | `README.md` endpoint tablosu |

**5. Çapraz kontrol.** Her endpoint için en az bir kaynak aranarak
[referans matrisi](../bolumler/10-referans-matrisi.md) oluşturuldu. Kaynaklar
çeliştiğinde en güncel **kod** esas alındı ve fark açıkça yazıldı.

**6. Kod örnekleri.** 12. bölümdeki TypeScript örnekleri `deno check` ile,
C# örneği .NET 8 hedefiyle (`TreatWarningsAsErrors`) derlendi. Canlı API'ye
karşı **çalıştırılmadı**.

## Sınırlamalar

- Hiçbir istek gerçek bir Tinder hesabıyla denenmedi.
- Yıldız sayıları eski projeleri öne çıkarır. Az yıldızlı 🟢 bir proje daha
  iyi bir seçim olabilir.
- `pushed_at` önemsiz commit'lerle (biçimlendirme botları vb.) güncellenmiş
  olabilir. Örneğin `ultralytics/tinder`'ın içeriği 2018'e ait.
- Yanıt şemaları kaynak koddaki tip tanımlarından alındı. Gerçek yanıtlar
  daha fazla alan içerebilir.

## Ana kaynaklar

- rtt, [Tinder API Documentation gist](https://gist.github.com/rtt/10403467) (2014)
- F. Bessez, [fbessez/Tinder](https://github.com/fbessez/Tinder) (2018–2019)
- NastyDevs, [Tinder API Documentation (OpenAPI)](https://nastydevs.github.io/tinder-api-documentation/)
- Rednit Team, [tinder-api-docs](https://github.com/rednit-team/tinder-api-docs)
- Miguelo981, [tinder-api](https://github.com/Miguelo981/tinder-api) (2026)
- tiagovla, [tinder.py](https://github.com/tiagovla/tinder.py) ve [belgeleri](https://tinder-py.readthedocs.io/)
- charliewolf, [pynder](https://github.com/charliewolf/pynder) ve [issue kayıtları](https://github.com/charliewolf/pynder/issues)
- Tinder, [Kullanım Koşulları](https://policies.tinder.com/terms)
