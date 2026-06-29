## Context

ScientiOS packages webapps using `surf` to isolate tracking and provide desktop application experiences. Until now, this required custom `do_install` boilerplate in `xbps-src` packages to generate the isolated profiles and handle wrapper scripts. Furthermore, existing scripts could leak modified `XDG_*` environment variables when spawning default browsers to handle external links (`target="_blank"`), corrupting the user's primary browser profile configuration.

## Goals / Non-Goals

**Goals:**
- Provide a unified, simple build style in `xbps-src` (`build_style=surf-webapp`) for packaging isolated webapps.
- Fully abstract the creation of `.desktop` files and wrapper scripts.
- Securely sandbox `surf`'s environment without leaking that sandbox to external tools.

**Non-Goals:**
- Ad-blocking features built into the `surf` profile (for now).
- Supporting browsers other than `surf` via this build style.

## Decisions

### Centralized xbps-src Build Style
We will create a `common/build-style/surf-webapp.sh` file. This intercepts the `do_install` phase for any package declaring `build_style=surf-webapp`. It reads `surf_webapp_url`, `surf_webapp_name`, `surf_webapp_js`, and `surf_webapp_plugins` from the package template to generate the necessary system files.
- *Alternative considered*: A user-space generator tool. Rejected because we want system-wide package management guarantees (dependency on `surf`) and integration into Void's build system.

### Two-Phase Wrapper Execution
The wrapper script (`/usr/libexec/surf-apps/<app_id>`) will operate in two modes:
1. **Launch Phase (0 args)**: It saves the real `XDG_*` variables into `REAL_XDG_*`, then uses `env` to launch `surf` with overridden `XDG_*` vars pointing to `~/.config/surf-app-profiles/<app_id>`. It uses `exec -a "$0" surf ...` to mask the binary name so `surf` invokes this wrapper again when opening new windows.
2. **Intercept Phase (>0 args)**: When `surf` spawns a new window for an external link, it calls the wrapper. The wrapper detects arguments, restores `XDG_*` from `REAL_XDG_*` (unwinding the sandbox), and executes `xdg-open` with the link.

### Profile Storage Path
Isolated application profiles will be stored in `~/.config/surf-app-profiles/<app_id>/`.
- *Alternative considered*: `~/.surf_profiles`. Rejected in favor of the standard `.config` XDG base directory.

### CSS Injection
If a `user.css` exists in the package's `files/` directory, the build style installs it to `/usr/share/surf-apps/<app_id>/user.css`. The wrapper script, on every launch, checks for this file and symlinks it to the isolated profile's `surf/styles/default.css`, ensuring real-time updates when the package is upgraded.

## Risks / Trade-offs

- **Risk**: Sandboxed file choosers (`GTK`) invoked by `surf` will not see standard user bookmarks because they are running in the isolated `XDG_CONFIG_HOME`.
  - **Mitigation**: Acceptable trade-off for true isolation. Users can navigate from `$HOME` normally.
- **Risk**: Advanced users manually modifying the symlink inside `~/.config/surf-app-profiles/<app_id>/config/surf/styles/` will have it overwritten on the next launch if the package provides a system style.
  - **Mitigation**: Document that custom overrides must be applied via package configuration or standard `xbps` tools.
