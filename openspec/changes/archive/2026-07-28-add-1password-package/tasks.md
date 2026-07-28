## 1. Setup and Package Configuration

- [x] 1.1 Create the directory structure `srcpkgs/1password`
- [x] 1.2 Implement the `srcpkgs/1password/update` script using `curl` and `grep` against the Debian `Packages` file
- [x] 1.3 Make the `update` script executable

## 2. Implement Package Template

- [x] 2.1 Create the `srcpkgs/1password/template` file with basic package metadata (pkgname, version, revision, depends)
- [x] 2.2 Configure `distfiles` to use the static Debian pool URL containing `${version}`
- [x] 2.3 Add the initial SHA256 checksum for the exact 1Password version specified in the template
- [x] 2.4 Implement the `do_install()` block to map `opt/1Password` and `usr/share` files directly into `$DESTDIR`
- [x] 2.5 Implement symlink creation from `/opt/1Password/1password` to `$DESTDIR/usr/bin/1password`

## 3. Local Verification

- [x] 3.1 Run `xebuild` locally on `1password` to verify it downloads and builds the Void template correctly
- [x] 3.2 Run the `update` script manually to verify it successfully fetches the latest version
- [x] 3.3 Install the built package locally and verify the desktop launcher opens 1Password successfully
