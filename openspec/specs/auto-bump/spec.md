# Capability: Auto-Bump

## Purpose

TBD: Provide automated tracking and bumping of third-party software packages in
the ScientiOS repository using GitHub Actions, ensuring packages remain up to
date without manual maintainer intervention.

## Requirements

### Requirement: Package Discovery

The system SHALL identify all packages capable of automated version bumping by
searching for the presence of an `update` script inside their package directory.

#### Scenario: Package has update script

- **WHEN** a package directory contains a file named `update`
- **THEN** the discovery mechanism MUST include it in the list of packages to
  check.

#### Scenario: Package lacks update script

- **WHEN** a package directory does not contain a file named `update`
- **THEN** the discovery mechanism MUST ignore it.

### Requirement: Version Comparison

The system SHALL execute the package's `update` script to retrieve the latest
upstream version and compare it with the current version defined in the XBPS
`template`.

#### Scenario: Upstream version is newer

- **WHEN** the upstream version string evaluates as newer than the current
  version
- **THEN** the system MUST trigger the bump sequence.

#### Scenario: Upstream version is identical or older

- **WHEN** the upstream version string evaluates as identical or older than the
  current version
- **THEN** the system MUST exit the bump sequence gracefully and perform no
  changes.

### Requirement: Template Patching

The system SHALL update the XBPS `template` with the new version, reset the
revision to 1, and recalculate the SHA-256 checksum of the new distfile.

#### Scenario: Successful checksum generation

- **WHEN** the distfile is downloaded and verified
- **THEN** the system MUST calculate its SHA-256 checksum and replace the
  existing `checksum=` value in the template.

#### Scenario: Download failure

- **WHEN** the distfile URL returns a 404 or fails to download
- **THEN** the system MUST fail the bump process for this package and report an
  error.

### Requirement: Independent Pull Requests

The system SHALL create a distinct Pull Request for each package that has been
successfully bumped.

#### Scenario: Successful PR creation

- **WHEN** the template is patched and the changes are staged
- **THEN** the system MUST create a new branch, commit the changes, and open a
  PR titled "Update <pkg> to <version>".
