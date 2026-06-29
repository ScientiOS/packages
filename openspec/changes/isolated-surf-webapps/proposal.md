## Why

Running web applications in isolated browser environments provides security, clean caching, and better desktop integration (proper WM/dmenu class identification). Doing this manually for every application using `xbps-src` packages requires repetitive boilerplate and is prone to errors, such as leaking environment variables (e.g. `XDG_CONFIG_HOME`) when a webapp spawns external processes or tools. A dedicated build style provides a declarative API for packagers to define a web application cleanly while automatically handling isolation, user overrides, styles, and safe process spawning.

## What Changes

- Introduce a new `xbps-src` build style: `surf-webapp.sh` in the `void-packages` overlay or repo tree.
- Packagers will be able to declare web applications simply by setting `build_style=surf-webapp` and defining properties like `surf_webapp_name`, `surf_webapp_url`, `surf_webapp_js`, etc.
- The build style will automatically generate a desktop file and an isolated wrapper script that safely handles `XDG_CONFIG_HOME`, `XDG_CACHE_HOME`, and `XDG_DATA_HOME` variable scoping, link interception to default browsers, and injection of optional user CSS.
- Create a sample/reference implementation for a `surf-app-whatsapp` package.

## Capabilities

### New Capabilities
- `surf-webapp-packaging`: The declarative build style and runtime wrapper framework for packaging isolated surf-based webapps in Void Linux.

### Modified Capabilities
- *(None)*

## Impact

- **Build System**: Adds a new build style `common/build-style/surf-webapp.sh` in the `srcpkgs` (or `void-packages` fork) directory.
- **Packages**: Introduces the `surf-app-whatsapp` package. Future webapp packages will heavily rely on this single central build style.
- **Runtime**: Webapps packaged this way will automatically create isolated profiles under `~/.config/surf-app-profiles/<app_id>`. Target link handling (`_blank`) safely unwinds the sandboxed `XDG_*` variables to avoid corrupting external browser sessions.