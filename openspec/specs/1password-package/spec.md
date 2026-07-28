# 1password-package

## Purpose
TBD: Adds the 1Password application to the ScientiOS custom package repository, including an auto-updater.

## Requirements

### Requirement: 1Password Package Builder
The system SHALL provide a package template that uses Void Linux `xbps-src` tooling to build a 1Password package from the official Debian distribution.

#### Scenario: Build successful package
- **WHEN** the `xebuild` or `xbps-src` command runs for `1password`
- **THEN** the system downloads the exact versioned `.deb` file and builds a valid Void Linux package incorporating the binary, application desktop entry, and icons.

### Requirement: 1Password Version Updater
The system SHALL include an `update` script in the package directory that scrapes the official 1Password Debian repository for new versions.

#### Scenario: Fetch latest version
- **WHEN** the `update` script is executed
- **THEN** it outputs the latest stable 1Password package version (e.g., `8.12.28`) from the Debian `Packages` file.

### Requirement: Desktop Integration
The package SHALL provide correct desktop menu entries and icons for the application so it integrates with desktop environments natively.

#### Scenario: Desktop entry installation
- **WHEN** the package is installed
- **THEN** a `.desktop` file exists in `/usr/share/applications/` and the application binary is symlinked in `/usr/bin/`.