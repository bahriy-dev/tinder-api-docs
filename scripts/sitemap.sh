#!/usr/bin/env bash
# Usage: ./scripts/sitemap.sh [base-url]
set -euo pipefail

cd "$(dirname "$0")/.."
base=${1:-https://bahriy-dev.github.io/tinder-api-docs}
today=$(date -u +%Y-%m-%d)

{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
  echo "  <url><loc>$base/</loc><lastmod>$today</lastmod><priority>1.0</priority></url>"
  find dist -name '*.html' ! -name 'index.html' ! -name '404.html' ! -name 'print.html' ! -name 'toc.html' \
    | sed 's#^dist/##' | sort | while read -r page; do
      echo "  <url><loc>$base/$page</loc><lastmod>$today</lastmod></url>"
    done
  echo '</urlset>'
} > dist/sitemap.xml

echo "sitemap: $(grep -c '<url>' dist/sitemap.xml) pages" >&2
