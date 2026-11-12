# Appendix C: Methodology

## How this book was made

**1. Discovery (12 November 2026).** GitHub was searched with the GitHub CLI,
sorted by stars, for `tinder api`, `tinder-api`, `tinder client`,
`tinder bot`, `pynder`, `tinder python` and `tinder sdk`. Links in the
documentation projects were then followed.

**2. Filtering.** Forks without meaningful changes, copies, unrelated
projects and anything in the categories listed in
[chapter 13](../chapters/13-responsible-use.md#what-this-book-deliberately-leaves-out)
were removed.

**3. Metadata.** For the remaining 40 projects, stars, last push date,
archive status and license were read from the GitHub REST API
(`gh api repos/{owner}/{repo}`). `scripts/refresh-stats.sh` repeats this step.

**4. Code review.** Six primary projects were cloned. Their endpoints,
headers, request bodies and error handling were read directly in the code.

**5. Cross-checking.** Every endpoint was checked against at least one
source to build the [reference matrix](../chapters/10-reference-matrix.md).
Where sources disagree, the most recent **code** wins and the difference is
spelled out.

**6. Code samples.** The TypeScript samples in chapter 12 were type-checked
with `deno check`. The C# sample was compiled against .NET 8 with
`TreatWarningsAsErrors`. None were **run** against the live API.

## Limitations

- No request was tried against a real Tinder account.
- Star counts favor older projects. A 🟢 project with few stars may be the
  better choice.
- `pushed_at` can be bumped by trivial commits (formatting bots and the
  like).
- Response schemas come from type definitions in client code. Real responses
  may contain more fields.
