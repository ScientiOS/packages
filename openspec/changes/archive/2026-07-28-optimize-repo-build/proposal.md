## Why

The GitHub Actions workflow for building the ScientiOS package repository
currently rebuilds every package on every push, regardless of whether a package
actually changed. As the repository grows, this blind rebuild approach is
incredibly slow and wastes CI resources. We need a way to only build what has
actually changed, without dropping old packages due to GitHub Pages deployment
behaviors or fragile CI caches.

## What Changes

We are optimizing the `build-repo.yml` workflow to implement a stateless,
self-healing "Robust Pages Workflow":

- The CI will fetch the existing repository contents (`.xbps` and
  `x86_64-repodata`) from the live GitHub Pages site using `wget` before
  building.
- Instead of building all packages, the CI will parse the `version` and
  `revision` from each package's `template` and compare it against the
  downloaded repository.
- Only missing or newer packages will be built.
- The newly built packages will be merged with the downloaded packages,
  re-indexed, and the entire set will be deployed back to GitHub Pages.

## Capabilities

### New Capabilities

- `repo-build-pipeline`: Smart building of only changed packages based on
  version/revision comparison against the live repository.

### Modified Capabilities

None.

## Impact

- **GitHub Actions (`.github/workflows/build-repo.yml`)**: Will be significantly
  refactored to include the sync step, version comparison step, and smart build
  loop.
- CI pipeline will be much faster and consume fewer minutes.
- The deployment architecture remains unchanged from the user perspective (still
  hosted on GitHub Pages).
