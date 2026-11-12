# Appendix D: Changelog

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and versions follow [Semantic Versioning](https://semver.org/).

## [2.0.0] - 2026-11-12

### Changed

- The whole book is now in English.
- Per-chapter source lists were removed. The book stands on its own; the
  project catalog stays in Appendix A.
- The reference matrix now shows method, path, status and chapter.
- The repository was renamed to `tinder-api-docs`, and search metadata was
  added (page descriptions, Open Graph tags, a sitemap).

## [1.0.0] - 2026-11-12

### Added

- 13 chapters: foundations, authentication (including the `/v3` protobuf
  flow), request anatomy, profile, discovery, interactions, matches and
  WebSocket, location and meta, other endpoints, the reference matrix,
  library reviews, writing your own client, and responsible use
- A 59-row endpoint reference matrix
- In-depth reviews of 7 projects, based on their source code
- TypeScript and C# (.NET 8) client skeletons that compile
- A verified catalog of 40 projects, a glossary and a methodology appendix
- `scripts/refresh-stats.sh` for repeatable metadata checks
