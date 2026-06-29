## 1. Fix CSS Framework Path

- [x] 1.1 Update `common/build-style/surf-webapp.sh` to correctly map `STYLE_DEST` using `.surf/styles/default.css` instead of `surf/styles/default.css`.
- [x] 1.2 Update the `mkdir -p` command in `common/build-style/surf-webapp.sh` to construct the new hidden path correctly before creating the symlink.

## 2. Apply Targeted Styling to WhatsApp

- [x] 2.1 Create `srcpkgs/surf-app-whatsapp/files/user.css`.
- [x] 2.2 Populate `user.css` with the targeted styling payload (105% root, 1.005em generic text, and `font-weight: inherit !important`).
- [x] 2.3 Increment the package revision in `srcpkgs/surf-app-whatsapp/template` from `2` to `3` to trigger a re-build.