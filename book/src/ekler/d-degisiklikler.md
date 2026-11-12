# Ek D: Değişiklik günlüğü

Biçim [Keep a Changelog](https://keepachangelog.com/tr-TR/1.1.0/) yaklaşımını,
sürümler [Semantic Versioning](https://semver.org/lang/tr/) kurallarını izler.

## [1.0.0] - 2026-11-12

### Eklendi

- 13 bölüm: temeller, kimlik doğrulama (`/v3` protobuf akışı dahil), istek
  anatomisi, profil, keşif, etkileşimler, eşleşmeler ve WebSocket, konum ve
  meta, diğer endpoint'ler, referans matrisi, kütüphane incelemeleri, kendi
  istemcini yazma, sorumlu kullanım
- 5 kaynağı karşılaştıran, 59 satırlık endpoint referans matrisi
- 7 projenin kaynak koduna dayanan ayrıntılı incelemesi
- Derlenerek doğrulanmış TypeScript ve C# (.NET 8) istemci iskeletleri
- 40 projelik doğrulanmış katalog (Ek A), sözlük (Ek B), yöntem (Ek C)
- `scripts/refresh-stats.sh` ile tekrarlanabilir meta veri doğrulaması

### Kaynaklarda bulunanlar

- `tinder.py` `send_message` gövdesi `dict` yerine `set` olarak yazılmış
- `tinder-mcp-server` resmî MCP SDK'sını kullanmıyor; bir Express sunucusu
