## Context

Currently, the `.github/workflows/build-repo.yml` builds every package in
`srcpkgs/` inside an isolated container, signs them, and uploads the resulting
`.xbps` files and index to GitHub Pages. GitHub Pages completely overwrites the
deployed site with whatever is given to it. Therefore, to safely deploy, the
workflow has to build every package. As the number of custom packages grows,
this CI build takes too long and wastes resources.

## Goals / Non-Goals

**Goals:**

- Only build packages that have been changed or are new.
- Preserve existing packages so they aren't deleted when the new set is
  published.
- Keep the deployment mechanism exactly the same (GitHub Pages without
  third-party services).
- Make the script stateless and self-healing.

**Non-Goals:**

- We are not changing the repository storage to GitHub Releases or any other
  backend.
- We are not migrating off `ghcr.io/void-linux/void-glibc-full` or changing the
  core `xbps-src` mechanics.

## Decisions

**1. Use `wget` to fetch existing repository state** We will download the
currently live `x86_64-repodata` and `.xbps` files from
`https://scientios.github.io/packages/` to the CI's local build environment
before starting `xbps-src`. _Rationale:_ This prevents us from relying on
volatile CI caches, which could drop old packages if evicted. By downloading
from the live site, the live site remains the single source of truth.

**2. Detect Changes via Version/Revision Parsing** We will parse the `version`
and `revision` strings from the package's `template` file, construct the target
XBPS filename (e.g. `zen-browser-1.0_1.x86_64.xbps`), and check if it exists in
the downloaded existing repository. _Rationale:_ This is safer than a Git diff
because it self-corrects: if a build fails for a specific version, it will try
building it again on the next run because the version isn't in the live
repository yet.

**3. Run `xbps-rindex` locally against the merged folder** We will place newly
built packages in the same directory as the downloaded existing packages, run
`xbps-rindex` across all of them to produce an updated `x86_64-repodata`, and
deploy that merged directory.

## Risks / Trade-offs

- **Risk**: Downloading the live repository will take time. _Mitigation_:
  Currently the repository is small. Even for medium repositories, `wget`
  fetching static files takes mere seconds. The time saved from not compiling
  massive packages heavily outweighs the download time.
- **Risk**: Broken `wget` step drops the whole repo. _Mitigation_: Add strict
  error handling. If `wget` fails completely (e.g., Pages is down), fail the CI
  run rather than deploying an empty set. But if the repo is empty (first run),
  we should handle a 404 gracefully.

## Migration Plan

1. Modify the `build-repo.yml` workflow.
2. Push to `main` branch.
3. Observe the action run. On the first run, it might encounter a 404 if it's
   pointing to a subpath that doesn't exist, or it will just download the
   current state.
4. Next commit (e.g. bumping a single package) should show only that package
   being built.
