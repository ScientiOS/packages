## 1. Setup Build Style Framework

- [x] 1.1 Create `common/build-style/surf-webapp.sh` with validation for `surf_webapp_url` and `surf_webapp_name`.
- [x] 1.2 Implement generating the `.desktop` file using package variables.
- [x] 1.3 Add logic to copy `files/user.css` to `/usr/share/surf-apps/<app_id>/user.css` if it exists.

## 2. Implement Wrapper Script Generation

- [x] 2.1 Implement wrapper phase 1 logic: checking for arguments and unwinding `REAL_XDG_*` variables, then running `xdg-open`.
- [x] 2.2 Implement wrapper phase 2 logic: generating the profile path dynamically under `~/.config/surf-app-profiles/`.
- [x] 2.3 Implement CSS symlink logic inside wrapper phase 2.
- [x] 2.4 Implement `surf` execution using `env` and `exec -a "$0"` with correct `surf` arguments based on `surf_webapp_js` and `surf_webapp_plugins`.

## 3. Reference Implementation

- [x] 3.1 Create `srcpkgs/surf-app-whatsapp/template` using the new `build_style=surf-webapp`.
- [x] 3.2 Create dummy build logic or let `xbps-src` use the default since `do_install` handles the whole process. Ensure the package successfully compiles via `./xbps-src pkg surf-app-whatsapp`.
- [x] 3.3 Verify generated desktop file.
- [x] 3.4 Verify generated wrapper script functionality (launch, isolation, link interception).