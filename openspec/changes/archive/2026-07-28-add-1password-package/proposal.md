## Why

ScientiOS relies on a custom XBPS package repository (`srcpkgs`) for software not available in the official Void Linux repositories. 1Password is a highly requested proprietary password manager that provides a Debian `.deb` distribution but no native XBPS package. By adding a 1Password package template to the ScientiOS repository, users will be able to install and update it seamlessly via `xbps-install`. Adding an auto-update script will also ensure the package stays current automatically via the daily CI/CD auto-bump workflow.

## What Changes

- Add a new package directory `srcpkgs/1password`.
- Implement a Void Linux template (`srcpkgs/1password/template`) that downloads the official 1Password `.deb` package and repackages it for ScientiOS.
- Implement an automated update script (`srcpkgs/1password/update`) that extracts the latest version from the official 1Password Debian repository.
- Ensure the package integrates correctly with the application menu and system icons.

## Capabilities

### New Capabilities
- `1password-package`: Adds the 1Password application to the ScientiOS custom package repository, including an auto-updater.

### Modified Capabilities
- None

## Impact

- **Affected Code:** Creates a new directory and files within `srcpkgs/`. No existing packages are modified.
- **Dependencies:** Requires `xdg-utils` (standard for desktop apps) and leverages the build system's native `.deb` extraction capabilities during `do_install`.
- **Systems:** Integrates with the existing GitHub Actions auto-bump CI/CD pipeline.
