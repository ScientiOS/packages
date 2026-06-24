## Context

Currently, external packages in the ScientiOS repository (like `slack-desktop`
and `zen-browser`) must be updated manually. This causes lag between upstream
stable releases and our customized versions. We need to implement an automated
pipeline within GitHub Actions to continuously poll for updates, modify the
package templates, and submit Pull Requests.

## Goals / Non-Goals

**Goals:**

- Automate the discovery of new upstream package versions.
- Automate the editing of XBPS `template` variables (`version`, `revision`,
  `checksum`).
- Create distinct, isolated Pull Requests per package for clear testing and
  merging workflows.

**Non-Goals:**

- We are NOT bypassing human review. PRs must still be merged manually or by the
  existing CI rules.
- We are NOT automating complex major version upgrades where file structures
  change entirely (if `do_install` steps need changing, human intervention in
  the PR is required).

## Decisions

**1. Using GitHub Actions Matrix for Parallel Jobs** _Rationale_: A matrix
strategy allows us to spin up parallel independent runners for every package. If
`slack-desktop`'s URL breaks and the job fails, it doesn't prevent `zen-browser`
from being updated and PR'd. _Alternative_: A sequential loop inside a single
job. Rejected because a failure on package #1 would abort the updates for
package #2 onwards, unless handled via complex bash script exit codes.

**2. Decentralized `update` scripts** _Rationale_: Every piece of software
provides updates differently (GitHub releases, raw JSON APIs, scraping HTML
changelogs). The logic to find the latest version should reside in
`srcpkgs/<package>/update`. _Alternative_: A large Python or Bash script parsing
a custom config file. Rejected because keeping the logic collocated with the
package `template` is standard Void Linux practice and much easier to maintain.

**3. `peter-evans/create-pull-request` Action** _Rationale_: This is a
battle-tested GitHub action that simplifies staging changes, creating branches,
checking if a PR already exists, and opening a PR.

## Risks / Trade-offs

- **Risk: Upstream URL Format Changes** → _Mitigation_: The `bump-pkg.sh` script
  must check the exit code of `wget` or `curl` before calculating the checksum.
  If the download fails, the script exits non-zero and no PR is created.
- **Risk: `grep`-based parsers breaking** → _Mitigation_: HTML structures like
  Slack's release notes may change, breaking the regex. If the script fails to
  parse a version, it will exit gracefully or just not bump anything. We accept
  this as a maintenance cost.
- **Risk: GitHub API Rate Limits** → _Mitigation_: The updates run on a schedule
  (e.g., once daily), avoiding aggressive polling.

## Migration Plan

1. Implement `scripts/bump-pkg.sh` and the GitHub workflow
   `.github/workflows/auto-bump.yml`.
2. Add `update` scripts to existing packages (`slack-desktop`, `zen-browser`).
3. Manually trigger the workflow to verify PR generation.
4. Merge the changes to `main`.
