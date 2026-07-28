## ADDED Requirements

### Requirement: Smart Repository Build Pipeline

The CI pipeline SHALL determine which packages to build by comparing package
versions against the live remote repository.

#### Scenario: Package version is newer

- **WHEN** the `version` or `revision` in `srcpkgs/<pkg>/template` is newer than
  the version in the downloaded `x86_64-repodata`
- **THEN** the pipeline SHALL build the updated package

#### Scenario: Package is missing from remote

- **WHEN** the package name does not exist in the downloaded `x86_64-repodata`
- **THEN** the pipeline SHALL build the new package

#### Scenario: Package is unchanged

- **WHEN** the exact `<pkg>-<version>_<revision>.x86_64.xbps` is found in the
  downloaded repository
- **THEN** the pipeline SHALL skip building the package

### Requirement: Lossless Deployment

The CI pipeline SHALL deploy both existing and newly built packages together so
that no old packages are deleted from the repository.

#### Scenario: Deploying updated packages

- **WHEN** the pipeline has finished building changed packages
- **THEN** the pipeline SHALL merge newly built packages with the downloaded
  ones, run `xbps-rindex` to update metadata, and deploy the entire directory
  back to GitHub Pages
