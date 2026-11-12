# Sorumlu kullanım ve hukuk

Tinder'ın API'si özel bir API. Onu kullanmak, en iyi ihtimalle gri bir
alanda durmak demek. Bu bölüm, kitabın dayandığı kuralları ve dikkate alınması
gereken hukuki çerçeveyi özetliyor. **Hukuki tavsiye değildir.**

## Beş kural

1. **Yalnızca kendi hesabın.** Kendi oturumunu kullan ve kendi verin
   üzerinde işlem yap. Başkasının token'ını kullanma, otomasyon için hesap
   açma.
2. **Başkalarının gizliliğine saygı.** Profiller, fotoğraflar ve mesajlar
   veri kümesine dahil olmayı kabul etmemiş gerçek insanlara ait. Onları
   kazıma, saklama, yayınlama, model eğitiminde kullanma.
3. **Korumaları aşmama.** CAPTCHA'yı, hız sınırlarını, telefon doğrulamasını
   veya ödeme duvarlarını aşmaya çalışma. API "dur" dediğinde (`403`, `429`,
   CAPTCHA) dur.
4. **Spam ve aldatma yok.** İnsan gibi davranan otomatik mesajlar gönderme.
   Toplu beğeni veya toplu mesaj botu çalıştırma.
5. **Küçük ölçek.** Kişisel deneyler, öğrenme ve sorumlu bildirimle yapılan
   güvenlik araştırması. Bu kitap yalnızca bunları destekliyor.

## Kullanım Koşulları

Tinder'ın [Kullanım Koşulları](https://policies.tinder.com/terms), hizmete
resmî uygulamalar dışında otomatik yollarla erişimi kısıtlıyor. Resmî olmayan
istemcilerle kullanılan hesaplar askıya alınabilir veya kalıcı olarak
kapatılabilir. Engeller çoğu zaman telefon numarasına bağlanıyor. Güncel
koşulları kendin oku.

## Veri koruma

API üzerinden eriştiğin kişisel verileri işliyorsan veri koruma mevzuatı sana
da uygulanabilir:

| Bölge | Düzenleme | Öne çıkan nokta |
| --- | --- | --- |
| Türkiye | **KVKK** (6698 sayılı Kanun) | Cinsel hayata ilişkin veriler ve biyometrik veriler **özel nitelikli kişisel veri** (m. 6). Açık rıza olmadan işlenmesi kural olarak yasak. |
| AB / AEA | **GDPR** | Cinsel yönelim ve biyometrik veri özel kategori (m. 9). Kişisel ev içi faaliyet istisnası dar yorumlanıyor. |
| Kaliforniya | **CCPA / CPRA** | Hassas kişisel bilgi kategorileri ve tüketici hakları |

Bir flört uygulamasındaki her profil, kişinin cinsel yönelimi hakkında dolaylı
bilgi taşır. Bu yüzden **başkalarının verisini saklamamak** yalnızca etik bir
tercih değil, çoğu durumda hukuki bir zorunluluk.

## Kitapta bilerek yer almayanlar

| Konu | Neden |
| --- | --- |
| Hesap oluşturma, `onboarding` ayrıntıları | Programatik hesap açmanın neredeyse tek kullanımı sahte veya toplu hesap |
| CAPTCHA çözme | Açık bir koruma atlatma |
| "Seni beğenenler" bulanıklığını kaldırma | Ücretli özelliği atlatma; başkalarının fotoğraflarını izinsiz açma |
| Ücretsiz Passport (konum hilesi) | Ücretli özelliği atlatma |
| Toplu beğeni ve mesaj botları | Spam; diğer kullanıcıların deneyimini bozar |
| Profil kazıma ve veri kümesi oluşturma | Gizlilik ihlali, KVKK/GDPR riski |

## Güvenlik açığı bildirmek

Tinder'da bir güvenlik açığı bulursan bunu
[Tinder'ın güvenlik sayfası](https://www.gotinder.com/security) veya Match
Group'un hata ödül programı üzerinden **gizlice** bildir. Diğer kullanıcıları
açığa çıkaran çalışan bir istismar kodu yayınlama.

Bu kitabı hazırlarken incelenen bazı projeler kendilerini "araştırma" veya
"kavram kanıtı" olarak tanıtıyordu. README'leri okununca ücretli özellikleri
atlatan araçlar oldukları görüldü. Bu yüzden listeye alınmadılar. Bir
projeyi değerlendirirken başlığına değil, **ne yaptığına** bak.
