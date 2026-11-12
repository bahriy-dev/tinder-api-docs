#!/usr/bin/env bash
# Re-verifies every project in data/projects.csv against the GitHub API.
# Requires the GitHub CLI (https://cli.github.com) and `gh auth login`.
# Usage: ./scripts/refresh-stats.sh > data/stats.tsv
set -euo pipefail

cd "$(dirname "$0")/.."
today=$(date -u +%Y-%m-%d)
one_year_ago=$(date -u -v-1y +%Y-%m-%d 2>/dev/null || date -u -d '1 year ago' +%Y-%m-%d)
three_years_ago=$(date -u -v-3y +%Y-%m-%d 2>/dev/null || date -u -d '3 years ago' +%Y-%m-%d)

printf 'repo\tcategory\tstatus\tstars\tlast_push\tlicense\tlanguage\n'
tail -n +2 data/projects.csv | while IFS=, read -r repo category; do
  if ! row=$(gh api "repos/$repo" --jq \
    '[.stargazers_count, .pushed_at[:10], .archived, (.license.spdx_id // "none"), (.language // "-")] | @tsv' 2>/dev/null); then
    printf '%s\t%s\tMISSING\t\t\t\t\n' "$repo" "$category"
    echo "warning: $repo could not be fetched (renamed, deleted or private?)" >&2
    continue
  fi
  IFS=$'\t' read -r stars pushed archived license language <<<"$row"
  if [[ $archived == true ]]; then status=archived
  elif [[ $pushed > $one_year_ago ]]; then status=active
  elif [[ $pushed > $three_years_ago ]]; then status=stale
  else status=inactive
  fi
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$repo" "$category" "$status" "$stars" "$pushed" "$license" "$language"
done
echo "verified on $today" >&2
