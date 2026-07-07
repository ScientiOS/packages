## Context

The `scientios-install` package is built via GitHub Actions (`build-repo.yml`) alongside all other void-packages templates. Its source code lives in a separate repository (`ScientiOS/installer`). Currently, the GitHub Action only checks out the main packages repo. The `scientios-install` package template doesn't specify an upstream `distfiles` to download a release tarball, but it does contain a commented-out `do_fetch()` block intended for local development which copies `../../../installer`.

This leads to the builder picking up zero Go files and failing the build.

## Goals / Non-Goals

**Goals:**
- Fix the GitHub Action CI build for `scientios-install` so it doesn't block the repository automation.
- Allow building the package seamlessly using the same multi-repo structure utilized locally (sibling `installer` and `packages` repos).

**Non-Goals:**
- Re-architecting the package to use proper tagged release `distfiles` tarballs from GitHub is excluded from this change, as the installer repo might still be heavily in-development or private.

## Decisions

**Decision 1: Checkout the `installer` repo directly in the CI Workflow**
- *Rationale:* Keeping the repos separate but making them available side-by-side matches local developer flows. We will add an `actions/checkout@v4` step to `build-repo.yml` configured to check out `ScientiOS/installer` to a directory named `installer`.

**Decision 2: Uncomment `do_fetch()` in the XBPS template**
- *Rationale:* Since the repository is now checked out alongside the `scientios-repo` (packages repo) in CI, the relative path `../../../installer` holds true. Uncommenting the existing `do_fetch` block bridges the gap cleanly for CI without imposing `distfiles` requirements yet.

## Risks / Trade-offs

- **Risk:** If `ScientiOS/installer` is a private repository, the GitHub Action will fail because the default `GITHUB_TOKEN` won't have cross-repo permissions.
  - **Mitigation:** Document that a Personal Access Token (PAT) may need to be supplied as a secret in the CI environment if the repository remains private.