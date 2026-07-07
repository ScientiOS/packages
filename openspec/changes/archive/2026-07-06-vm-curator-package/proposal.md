## Why

`vm-curator` is a highly requested tool by power users running desktop Linux who want direct QEMU control without the overhead of `libvirt`, specifically tailored for single and multi-GPU passthrough setups. Adding it to the `srcpkgs` collection will allow users to easily install and update it via ScientiOS's package manager natively.

## What Changes

- Add a new package template `vm-curator` to `srcpkgs/` building from the upstream rust repository.
- Include accurate runtime dependencies (like `qemu`, `ovmf`, `polkit`, `kmod`, and `eudev-libudev`) to ensure users have a working environment post-installation.
- Establish the `build_style` using Cargo for a streamlined native build.

## Capabilities

### New Capabilities

- `package-vm-curator`: A new source package providing `vm-curator` (version 1.2.0) and accurately resolving its virtual machine dependencies out of the box.

### Modified Capabilities

None.

## Impact

- **New package in `srcpkgs/`**: `vm-curator`
- **Dependencies utilized**: Will leverage `eudev-libudev-devel` at build time and rely on existing system packages (`qemu`, `ovmf`, `polkit`, `kmod`, `bash`) at runtime.
