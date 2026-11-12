# Katkı rehberi

Kitabı doğru ve güncel tutmaya yardım ettiğin için teşekkürler. Bu projede
**doğruluk, kapsamdan önce gelir.**

## Neler kabul edilir?

- Eskimiş veya hatalı bir endpoint bilgisinin düzeltilmesi (kaynakla birlikte)
- Yeni bir endpoint, başlık veya yanıt alanı (kaynak kod veya belge bağlantısıyla)
- Kataloğa yeni bir proje ([Ek C](book/src/ekler/c-yontem.md)'deki ölçütlere uygun)
- Yazım, anlatım ve bağlantı düzeltmeleri

## Neler kabul edilmez?

- Hesap oluşturma, CAPTCHA çözme, ücretli özellikleri atlatma veya başkalarının
  verisini ifşa etme yöntemleri
- Gerçek token'lar, telefon numaraları, profil fotoğrafları veya mesajlar içeren
  her türlü içerik
- Kaynak gösterilmeyen endpoint iddiaları

## Bir endpoint'i güncellemek

1. İlgili bölümü `book/src/bolumler/` altında bul.
2. Bilgiyi güncelle ve bölüm sonundaki **Kaynaklar** satırına kaynağı ekle.
3. Durum işaretini (🟢 / 🟡 / 🔴) güncelle.
4. [Referans matrisi](book/src/bolumler/10-referans-matrisi.md)'ndeki satırı
   güncelle.
5. Önemli bir değişiklikse [Ek D](book/src/ekler/d-degisiklikler.md)'ye ekle.

## Kataloğa proje eklemek

1. Meta veriyi elle yazma, GitHub API'sinden al:

   ```bash
   gh api repos/OWNER/REPO --jq '[.stargazers_count,.pushed_at[:10],.archived,.license.spdx_id]'
   ```

2. Projeyi `data/projects.csv` dosyasına kategorisiyle ekle.
3. `./scripts/refresh-stats.sh > data/stats.tsv` komutunu çalıştır.
4. [Ek A](book/src/ekler/a-katalog.md)'daki ilgili tabloya satırı ekle.

## Yerelde kontrol

```bash
mdbook build book    # derleme hatası olmamalı
mdbook serve book    # http://localhost:3000 adresinde önizleme
```

## Yazım kuralları

- Kitap **Türkçe** yazılır. Endpoint, başlık ve kod adları özgün hâliyle
  `kod` biçiminde kalır.
- Okura "sen" diye hitap edilir. Kısa ve doğrudan cümleler kullanılır.
- İddia varsa kaynak da vardır. Kaynaklar çelişiyorsa ikisi de yazılır.

## Pull request kontrol listesi

- [ ] Her yeni bilgi için kaynak bağlantısı var
- [ ] Durum işaretleri ve referans matrisi güncel
- [ ] `mdbook build book` hatasız
- [ ] Hiçbir token, telefon numarası veya gerçek kişisel veri yok
