## 1. Setup

- [x] 1.1 Verify the target download URL and calculate the SHA256 checksum for `zen.linux-x86_64.tar.xz` (version `1.21.3b` or latest).

## 2. Template Creation

- [x] 2.1 Create the file `srcpkgs/zen-browser/template`.
- [x] 2.2 Populate template metadata (`pkgname`, `version`, `revision`, `archs="x86_64"`, `distfiles`, `checksum`, `short_desc`, `maintainer`, `license`, `homepage`).
- [x] 2.3 Define `do_build()` as a no-op (`:`).

## 3. Installation Routine (`do_install`)

- [x] 3.1 Implement extraction/copy logic to place all tarball contents into `${DESTDIR}/usr/lib/zen-browser`.
- [x] 3.2 Implement symlink creation from `${DESTDIR}/usr/lib/zen-browser/zen` to `${DESTDIR}/usr/bin/zen-browser`.
- [x] 3.3 Implement icon installation via `vinstall` to extract `browser/chrome/icons/default/default128.png` and install it as `zen-browser.png` in `${DESTDIR}/usr/share/pixmaps`.

## 4. Desktop Integration

- [x] 4.1 Write a heredoc in `do_install()` to generate `${DESTDIR}/usr/share/applications/zen-browser.desktop`.
- [x] 4.2 Ensure `.desktop` contents map `Exec=/usr/bin/zen-browser %u`, `Icon=zen-browser`, and appropriate `Categories`/`MimeType`.