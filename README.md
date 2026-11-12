<div align="center">

# Tinder API Documentation: The Unofficial Handbook (2026)

**The most complete, up-to-date guide to Tinder's private API: authentication,
endpoints, request and response formats, client libraries for Python,
Node.js, TypeScript and C#, and responsible use.**

[![Read the handbook](https://img.shields.io/badge/read-the_handbook-0A7EA4?logo=mdbook&logoColor=white)](https://bahriy-dev.github.io/tinder-api-docs/)
[![Build](https://github.com/bahriy-dev/tinder-api-docs/actions/workflows/deploy.yml/badge.svg)](https://github.com/bahriy-dev/tinder-api-docs/actions/workflows/deploy.yml)
[![Links](https://github.com/bahriy-dev/tinder-api-docs/actions/workflows/links.yml/badge.svg)](https://github.com/bahriy-dev/tinder-api-docs/actions/workflows/links.yml)
[![Text: CC BY 4.0](https://img.shields.io/badge/text-CC_BY_4.0-lightgrey.svg)](LICENSE)
[![Code: MIT](https://img.shields.io/badge/code-MIT-blue.svg)](LICENSE-CODE)
[![Last verified](https://img.shields.io/badge/last_verified-2026--11--12-success)](book/src/appendix/c-methodology.md)

**[📖 Read online](https://bahriy-dev.github.io/tinder-api-docs/)** ·
[Contents](book/src/SUMMARY.md) ·
[Endpoint reference](book/src/chapters/10-reference-matrix.md) ·
[Authentication](book/src/chapters/02-authentication.md)

</div>

> [!IMPORTANT]
> Tinder has no public developer API. This handbook documents the private API
> the Tinder apps use themselves. Automated access may break Tinder's
> [Terms of Use](https://policies.tinder.com/terms). The handbook is for
> learning, research and personal experiments on **your own account**. Read
> [Responsible use](book/src/chapters/13-responsible-use.md) first. Not
> affiliated with Tinder or Match Group.

## What you'll find here

Knowledge about the Tinder API is scattered across old gists, abandoned
libraries and issue threads, and most of it is outdated. This handbook
brings it together and **checks it against real client code**:

- 🔐 **How Tinder login works in 2026.** The protobuf authentication flow
  (`/v3/auth/login`): SMS OTP, email verification, CAPTCHA and refresh
  tokens, plus how to get your own `X-Auth-Token`.
- 🧭 **A 59-endpoint reference.** Every known endpoint with its HTTP method,
  status (🟢 current, 🟡 uncertain, 🔴 historical) and a chapter that
  explains it.
- 📦 **Request and response formats.** Headers, the `/v2` envelope,
  recommendations (`/v2/recs/core`), like and pass (`s_number`), matches,
  messages, location (`/v2/meta`), Boost and the WebSocket channel.
- 🐍 **Library reviews.** Tinder API clients for Python, Node.js / TypeScript,
  C# / .NET and MCP, compared by code quality, and two bugs found in them.
- 🧱 **Compiled client skeletons.** TypeScript and C# (.NET 8) with safe
  defaults: read-only mode, rate limiting and a circuit breaker.
- 📚 **A catalog of 40 projects.** Stars, last push and license, verified
  through the GitHub API and refreshable with one script.

## Contents

| # | Chapter | Topics |
| :-: | --- | --- |
| | **Part I: Foundations** | |
| 1 | [Understanding an unofficial API](book/src/chapters/01-foundations.md) | History, architecture, versioning |
| 2 | [Authentication](book/src/chapters/02-authentication.md) | `X-Auth-Token`, the `/v3` protobuf login, refresh tokens, secure storage |
| 3 | [Anatomy of a request](book/src/chapters/03-request-anatomy.md) | Headers, parameters, response envelope, status codes, rate limits |
| | **Part II: Endpoints** | |
| 4 | [Profile and account](book/src/chapters/04-profile.md) | `include` scopes, discovery settings, `preference_filters` |
| 5 | [Discovery and recommendations](book/src/chapters/05-discovery.md) | `/v2/recs/core`, card fields, filtered search |
| 6 | [Interactions](book/src/chapters/06-interactions.md) | Like, pass, Super Like, Boost |
| 7 | [Matches and messages](book/src/chapters/07-matches-messages.md) | `/v2/matches`, messages, WebSocket |
| 8 | [Location and meta](book/src/chapters/08-location-meta.md) | `/v2/meta`, Passport |
| 9 | [Other endpoints](book/src/chapters/09-other.md) | Likes You, GIFs, connected accounts, reporting |
| 10 | [Endpoint reference matrix](book/src/chapters/10-reference-matrix.md) | All 59 endpoints in one place |
| | **Part III: Ecosystem and practice** | |
| 11 | [Library reviews](book/src/chapters/11-libraries.md) | 7 projects reviewed from their code |
| 12 | [Designing your own client](book/src/chapters/12-your-own-client.md) | Principles, TypeScript and C# skeletons, testing, MCP |
| 13 | [Responsible use and the law](book/src/chapters/13-responsible-use.md) | Terms of Use, GDPR, CCPA, KVKK |
| A–D | [Appendices](book/src/appendix/a-catalog.md) | Project catalog, glossary, methodology, changelog |

## Quick start

**Pick a library:**

| Language | Recommendation |
| --- | --- |
| TypeScript / Node.js / Deno | `tinder-api-ts` ([review](book/src/chapters/11-libraries.md#1-tinder-api-ts)) |
| Python | `tinder.py`, with the message bug patched ([review](book/src/chapters/11-libraries.md#2-tinderpy)) |
| C# / .NET | [The chapter 12 skeleton](book/src/chapters/12-your-own-client.md#c--net-8-skeleton) |
| Just learning | [The endpoint reference](book/src/chapters/10-reference-matrix.md) |

**Build the book locally:**

```bash
cargo install mdbook --version 0.4.40
```

```bash
mdbook serve book --open
```

**Refresh the catalog metadata** (requires the [GitHub CLI](https://cli.github.com/)):

```bash
./scripts/refresh-stats.sh > data/stats.tsv
```

## Repository layout

```text
tinder-api-docs/
├── book/
│   ├── book.toml             # mdBook configuration
│   ├── theme/head.hbs        # SEO metadata
│   └── src/
│       ├── SUMMARY.md        # Table of contents
│       ├── chapters/         # 13 chapters
│       └── appendix/         # Catalog, glossary, methodology, changelog
├── data/
│   ├── projects.csv          # Catalog projects and categories
│   └── stats.tsv             # Last verified GitHub metadata
├── scripts/
│   └── refresh-stats.sh      # Refreshes metadata from the GitHub API
└── .github/                  # CI (Pages, link check), templates
```

## Contributing

Found an outdated endpoint, a mistake or a project that should be listed?
Read [CONTRIBUTING.md](CONTRIBUTING.md) and open an
[issue](https://github.com/bahriy-dev/tinder-api-docs/issues/new/choose).
Never share tokens, phone numbers or real profiles. For security matters,
see [SECURITY.md](SECURITY.md).

## License

- **Text:** [CC BY 4.0](LICENSE). Share and adapt it with attribution.
- **Code samples and scripts:** [MIT](LICENSE-CODE)
- Projects mentioned in the handbook keep their own licenses.

To cite: [CITATION.cff](CITATION.cff)

*Tinder is a trademark of Match Group, LLC, used here only to identify the
system described. This project is not affiliated with, endorsed by or
sponsored by Match Group.*
