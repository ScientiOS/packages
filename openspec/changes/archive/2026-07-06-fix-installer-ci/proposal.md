## Why

The GitHub Action CI workflow (`build-repo.yml`) in the `packages` repository is currently failing when attempting to build the `scientios-install` package. The failure occurs because the installer source code lives in a separate repository (`ScientiOS/installer`) that is not being fetched by the `xbps-src` template or cloned by the CI runner. As a result, the Go compiler finds an empty directory and errors out with "no Go files", which blocks the entire CI pipeline including updates for other packages.

## What Changes

- Modify `.github/workflows/build-repo.yml` in the `packages` repository to add an `actions/checkout` step that clones the `ScientiOS/installer` repository into the workspace alongside `scientios-repo`.
- Update `srcpkgs/scientios-install/template` in the `packages` repository to enable the `do_fetch()` block, which will copy the installer source code from `../../../installer` (the cloned sibling directory) into the `wrksrc` build directory.

## Capabilities

### New Capabilities
- None (This is a CI/infrastructure fix, not a new functional capability).

### Modified Capabilities
- None

## Impact

- **CI Pipeline:** The `build-repo.yml` workflow will successfully build the `scientios-install` package and complete the job.
- **Local Building:** Local builds using `xbps-src` will also be able to build the installer if the user has the `installer` repo cloned adjacent to the `packages` repo.
- **Dependencies:** The action will now explicitly depend on the `ScientiOS/installer` repository being accessible by the GitHub Actions runner.