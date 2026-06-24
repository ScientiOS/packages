# zen-browser-package

## Purpose
TBD - Zen Browser package specification.

## Requirements

### Requirement: Package Definition and Sourcing
The package manager SHALL recognize `zen-browser` as a valid package derived from the official pre-compiled x86_64 binary release.

#### Scenario: Verify package template properties
- **WHEN** building the package via `xbps-src`
- **THEN** it resolves the version `1.21.3b` (or latest), architecture `x86_64`, and downloads the tarball from the official GitHub releases page.

### Requirement: Installation and Layout
The installation procedure SHALL place the application payload isolated in `/usr/lib/` and expose the binary globally via a symlink.

#### Scenario: Validate filesystem mapping
- **WHEN** the package is installed
- **THEN** the entire binary distribution resides in `/usr/lib/zen-browser`
- **THEN** a symlink exists at `/usr/bin/zen-browser` pointing to `/usr/lib/zen-browser/zen`.

### Requirement: Desktop Environment Integration
The package SHALL provide native desktop integration via an application launcher and icon.

#### Scenario: Desktop entry execution
- **WHEN** the desktop environment evaluates applications
- **THEN** `zen-browser.desktop` is available in `/usr/share/applications/`
- **THEN** its `Exec` parameter is set to `/usr/bin/zen-browser %u`
- **THEN** it is visible in the network/web browser categories.

#### Scenario: Icon extraction
- **WHEN** the package is installed
- **THEN** `default128.png` from the tarball's internal paths is extracted and available as `zen-browser.png` in `/usr/share/pixmaps/`.