# Önsöz

Tinder'ın geliştiricilere açık, belgelenmiş bir API'si yok. Yine de on yılı
aşkın süredir yüzlerce geliştirici, uygulamanın kendi sunucularıyla nasıl
konuştuğunu inceledi, not aldı ve kütüphaneler yazdı. Bu bilgiler bugün
GitHub'da onlarca depoya, eski gist'lere ve issue yorumlarına dağılmış
durumda. Birçoğu da artık geçerli değil.

Bu kitap o dağınık bilgiyi tek yerde topluyor. Ama yalnızca bir liste
değil: Her endpoint'i en az bir **kaynak kodla** karşılaştırdım, hangi
bilginin hangi döneme ait olduğunu işaretledim ve çelişkileri açıkça yazdım.

## Bu kitap kimin için?

- Tinder'ın istemci–sunucu mimarisini merak eden **yazılım geliştiriciler**
- Tersine mühendislikle belgelenmiş bir API'nin nasıl evrildiğini görmek
  isteyen **öğrenciler**
- Kendi hesabının verileri üzerinde küçük deneyler yapmak isteyenler
- Güvenlik ve gizlilik **araştırmacıları**

Toplu hesap açmak, ücretli özellikleri bedava açmak ya da başkalarının
verisini toplamak isteyenler için bu kitapta hiçbir şey yok. Nedenleri
[Sorumlu kullanım ve hukuk](bolumler/13-sorumlu-kullanim.md) bölümünde.

## Nasıl okunmalı?

| Hedefin | Okuma sırası |
| --- | --- |
| Genel resmi görmek | 1 → 2 → 10 → 11 |
| Bir istemci yazmak | 1 → 2 → 3 → 4–9 → 12 |
| Hazır bir kütüphane seçmek | 11 → Ek A |
| Bir endpoint'i hızlıca bulmak | 10 (referans matrisi) |

## İşaretler

Kitap boyunca her bilginin kaynağı ve tazeliği şu işaretlerle belirtilir:

| İşaret | Anlamı |
| :---: | --- |
| 🟢 **Güncel** | 2025–2026'da bakımı yapılan en az bir kaynak kodda kullanılıyor |
| 🟡 **Belirsiz** | Yalnızca 2020–2024 kaynaklarında var; hâlâ çalışıyor olabilir |
| 🔴 **Tarihsel** | 2020 öncesine ait ve büyük olasılıkla artık çalışmıyor |
| 💳 | Ücretli abonelik (Plus, Gold, Platinum) gerektiriyor |

> **Önemli:** Bu kitaptaki hiçbir istek, gerçek bir Tinder hesabıyla
> denenmedi. Bilgiler açık kaynak projelerin koduna ve belgelerine dayanıyor.
> Kaynaklar her bölümün sonunda ve [Ek C](ekler/c-yontem.md)'de listeleniyor.
> Son doğrulama tarihi **12 Kasım 2026**.

## Bu kitap Tinder ile bağlantılı değildir

Tinder, Match Group, LLC'nin ticari markasıdır. Bu kitap Match Group
tarafından onaylanmadı, desteklenmedi ve onunla hiçbir bağı yok. Marka adı
yalnızca anlatılan sistemi tanımlamak için kullanılıyor.

— Bahri Yilmaz
