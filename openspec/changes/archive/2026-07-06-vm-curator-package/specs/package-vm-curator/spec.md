## ADDED Requirements

### Requirement: Package Definition and Build Sourcing
The packaging system SHALL provide a valid package template for `vm-curator` that fetches the `v1.2.0` source from the official repository and initiates a Cargo-based build.

#### Scenario: Building the package
- **WHEN** `xbps-src pkg vm-curator` is executed
- **THEN** the source is downloaded, cargo compiles the binary cleanly using `eudev-libudev-devel`, and the resulting executable is staged to `/usr/bin/vm-curator` in the destination directory.

### Requirement: Runtime Dependency Enforcement
The package SHALL specify explicit runtime dependencies required for core operations and advanced hypervisor features.

#### Scenario: Installing the package
- **WHEN** the built package is installed onto a system via `xbps-install`
- **THEN** the package manager resolves and ensures the installation of `qemu`, `ovmf`, `polkit`, `kmod`, and `bash`.
