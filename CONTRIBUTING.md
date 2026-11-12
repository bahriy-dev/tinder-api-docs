# Contributing

Thanks for helping keep this handbook accurate. Here, **accuracy comes before
coverage.**

## What we accept

- Fixes for outdated or wrong endpoint details (with evidence in the PR)
- New endpoints, headers or response fields (with evidence in the PR)
- New catalog projects that meet the criteria in
  [Appendix C](book/src/appendix/c-methodology.md)
- Spelling, wording and link fixes

## What we don't accept

- Ways to create accounts, solve CAPTCHAs, bypass paid features or expose
  other people's data
- Anything containing real tokens, phone numbers, profile photos or messages
- Endpoint claims without evidence

## Updating an endpoint

1. Find the chapter under `book/src/chapters/`.
2. Update the information, and put your evidence (a code line, document or
   commit link) in the pull request description.
3. Update the status marker (🟢 / 🟡 / 🔴).
4. Update the row in the
   [reference matrix](book/src/chapters/10-reference-matrix.md).
5. For notable changes, add an entry to the
   [changelog](book/src/appendix/d-changelog.md).

## Adding a catalog project

1. Don't type metadata by hand. Read it from the GitHub API:

   ```bash
   gh api repos/OWNER/REPO --jq '[.stargazers_count,.pushed_at[:10],.archived,.license.spdx_id]'
   ```

2. Add the project and its category to `data/projects.csv`.
3. Run `./scripts/refresh-stats.sh > data/stats.tsv`.
4. Add the row to the right table in
   [Appendix A](book/src/appendix/a-catalog.md).

## Checking locally

```bash
mdbook build book    # must build without errors
mdbook serve book    # preview at http://localhost:3000
```

## Style

- Write in plain, direct English and address the reader as "you".
- Keep endpoint, header and code names in their original form, as `code`.
- When sources disagree, describe both versions.

## Pull request checklist

- [ ] Evidence for every new fact is in the PR description
- [ ] Status markers and the reference matrix are up to date
- [ ] `mdbook build book` succeeds
- [ ] No tokens, phone numbers or real personal data
