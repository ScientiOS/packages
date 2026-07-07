## Context

`vm-curator` is a Rust-based TUI tool for managing QEMU/KVM virtual machines. It is specifically designed to facilitate robust GPU passthrough on desktop Linux distributions without relying on abstractions like `libvirt`. Given that ScientiOS builds upon an XBPS packaging ecosystem with a `srcpkgs` collection, providing a package for `vm-curator` allows users to natively fetch, build, and integrate this virtualization tooling within their environment.

## Goals / Non-Goals

**Goals:**
- Provide a `srcpkgs` template file to build `vm-curator` using Cargo.
- Clearly establish build dependencies (`makedepends`).
- Guarantee a successful out-of-the-box user experience by enforcing the presence of the necessary runtime utilities (`depends`).

**Non-Goals:**
- Making modifications to the upstream `vm-curator` codebase.
- Establishing system-level hooks (like default udev rules or service files), beyond what the package strictly provides and requires natively. 

## Decisions

### Packaging Style
- **Decision:** Utilize the `cargo` build style in the XBPS template.
- **Rationale:** `vm-curator` is written in Rust. The `cargo` build style simplifies pulling the crate dependencies, building a release binary, and staging it correctly into the `DESTDIR`.

### Dependency Strategy
- **Decision:** Explicitly specify `eudev-libudev-devel` for `makedepends`, and `qemu`, `ovmf`, `polkit`, `kmod`, and `bash` for `depends`.
- **Rationale:** While `shlibs` detection in XBPS handles dynamic linking (e.g., `libudev`), rust crates occasionally diverge from expected linkage patterns depending on the backend usage (`dlopen` vs standard linking). Enforcing explicit toolchain tools (`qemu`, `ovmf` for UEFI) ensures that when a user starts `vm-curator`, the underlying hypervisor binaries and permission escalation protocols (`polkit`) are actually present.

### Checksums and Distribution Files
- **Decision:** Sourced from the official `vm-curator` GitHub release tags.
- **Rationale:** We will fetch the version 1.2.0 `tar.gz` and generate its SHA256 checksum utilizing `xgbs-src xgensum` (or calculate it manually) to enforce artifact integrity.

## Risks / Trade-offs

- **Risk: Shared Library Drifting:** Depending explicitly on `eudev-libudev` via `depends` instead of relying entirely on automatic `shlibs` might lead to redundant declarations if the automatic system picks it up perfectly.
  - **Mitigation:** XBPS easily handles redundant dependency overlap; there's no harm in explicit guarantees for crucial utilities.
- **Risk: Hardcoded Version:** Version 1.2.0 will be fixed in the template.
  - **Mitigation:** The template can easily be bumped like any standard XBPS package. Future iterations can integrate with an update-check script if ScientiOS implements one for `srcpkgs`.
