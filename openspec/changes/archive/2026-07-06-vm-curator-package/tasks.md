## 1. Directory and Template Creation

- [x] 1.1 Create the directory `srcpkgs/vm-curator`
- [x] 1.2 Create `srcpkgs/vm-curator/template` file.
- [x] 1.3 Populate the basic template metadata: `pkgname`, `version=1.2.0`, `revision=1`, `build_style=cargo`, `short_desc`, `maintainer`, `license="MIT"`, `homepage`.
- [x] 1.4 Add `distfiles` pulling from `https://github.com/mroboff/vm-curator/archive/refs/tags/v${version}.tar.gz`.

## 2. Dependencies Setup

- [x] 2.1 Add `makedepends="eudev-libudev-devel"` to the template.
- [x] 2.2 Add `depends="qemu bash ovmf polkit kmod"` to the template.

## 3. Checksums and Finalization

- [x] 3.1 Calculate the SHA256 checksum of the v1.2.0 `tar.gz` archive.
- [x] 3.2 Add the calculated checksum to the `checksum` field in the template.
- [x] 3.3 Ensure the `post_install()` hook correctly installs the `LICENSE` file.