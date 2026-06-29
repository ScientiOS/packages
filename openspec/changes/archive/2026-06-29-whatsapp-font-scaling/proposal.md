## Why

The `surf-app-whatsapp` package currently uses default `surf` font rendering, which appears uncomfortably tiny and improperly weighted (bold) on many high-DPI modern displays because `fontconfig` falls back to `DejaVu Sans`. Additionally, the recently implemented `$HOME` isolation capability inside the `surf-webapp` build style broke the framework's CSS injection path by assuming `surf/styles/` instead of `.surf/styles/` after the `HOME` rewrite. We need to fix the CSS injection framework path so that we can ship a custom CSS override with the WhatsApp package to ensure legible, perfectly scaled fonts.

## What Changes

- Update `common/build-style/surf-webapp.sh` to construct the isolated CSS destination path correctly as `.surf/styles/default.css` instead of `surf/styles/default.css`.
- Add `srcpkgs/surf-app-whatsapp/files/user.css` to provide targeted text scaling (105% root, 1.005em for layout text) while preserving font weights (`font-weight: inherit`).
- Update `srcpkgs/surf-app-whatsapp/template` to increment the package revision, triggering a rebuild.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `surf-webapp-packaging`: Modify the requirement around "Optional User Stylesheet Injection" to ensure it respects the correct hidden directory path caused by `$HOME` variable unwinding and `surf` fallback behavior.

## Impact

- `common/build-style/surf-webapp.sh` (Fixing the CSS symlink generation path)
- `srcpkgs/surf-app-whatsapp/files/user.css` (New file)
- `srcpkgs/surf-app-whatsapp/template` (Revision bump)