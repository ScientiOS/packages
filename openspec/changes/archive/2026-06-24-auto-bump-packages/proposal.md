## Why

Keeping custom ScientiOS packages up-to-date manually is tedious and
error-prone, resulting in outdated packages like `slack-desktop` staying in the
repository. An automated system running continuously will relieve maintainers
from manual updates, ensuring users always receive the latest stable releases of
third-party software.

## What Changes

- Add an automated GitHub Actions workflow (`auto-bump.yml`) running on a
  schedule.
- Implement a package discovery mechanism that identifies packages containing an
  `update` script.
- Execute package updates in parallel (using GitHub Actions matrix jobs) to
  isolate bumps and failures.
- Introduce `update` scripts for `slack-desktop` and `zen-browser` that find
  their respective latest upstream versions.
- Develop a centralized bumper script (`scripts/bump-pkg.sh`) that updates
  version numbers, downloads the latest file, calculates the new SHA-256
  checksum, and edits the XBPS `template`.
- Automatically create individual Pull Requests for each package update.

## Capabilities

### New Capabilities

- `auto-bump`: Automated GitHub Actions pipeline, bumper script, and package
  update logic to retrieve the latest upstream releases, update XBPS templates,
  and submit PRs automatically.

### Modified Capabilities

_(None)_

## Impact

- Adds `.github/workflows/auto-bump.yml` for scheduled execution.
- Introduces `scripts/bump-pkg.sh` as the main version bump workhorse.
- Adds `update` files to `srcpkgs/slack-desktop/` and `srcpkgs/zen-browser/` to
  enable them for automated bumping.
- Does not affect the end-user deployment logic since it leverages Pull Requests
  for CI testing before merging.
