# Capability: surf-webapp-packaging

**Purpose**: Establish a declarative framework to package, build, and isolate web applications running on the `surf` browser using `xbps-src`.

## Requirements

### Requirement: Declarative Webapp Build Style
Packagers SHALL be able to define a web application using the `surf-webapp` build style without writing shell logic.

#### Scenario: Building a webapp
- **WHEN** a package uses `build_style=surf-webapp` and defines `surf_webapp_url` and `surf_webapp_name`
- **THEN** `xbps-src` produces a package containing a desktop file and wrapper script

### Requirement: Application Execution Environment Scoping
Webapps SHALL execute `surf` with strictly scoped and overriden `HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, and `XDG_CONFIG_HOME` pointing to `~/.config/surf-app-profiles/<app_id>`.

#### Scenario: Launching an isolated webapp
- **WHEN** the user executes the webapp wrapper
- **THEN** it sets `HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, and `XDG_CONFIG_HOME` for the `surf` process exclusively to the isolated profile path.

### Requirement: External Link Interception
The webapp wrapper SHALL intercept links that open in a new window (`target="_blank"`) and redirect them to the default desktop browser (`xdg-open`).

#### Scenario: Intercepting a new window request
- **WHEN** `surf` calls its `argv[0]` (the wrapper) with URL arguments
- **THEN** the wrapper calls `xdg-open` with the URL and immediately exits without starting another `surf` instance.

### Requirement: Unwinding Sandboxed Variables
When intercepting a link to an external browser, the wrapper SHALL restore the original `HOME` and `XDG_` environment variables of the user.

#### Scenario: Launching external browser
- **WHEN** the wrapper calls `xdg-open` to handle an intercepted URL
- **THEN** the environment passed to `xdg-open` must contain the original `HOME`, `XDG_CONFIG_HOME`, `XDG_CACHE_HOME`, and `XDG_DATA_HOME` values that the user had before launching the webapp, or unset them if they were not originally set.

### Requirement: Application Display Name
The `.desktop` file SHALL contain exactly the `surf_webapp_name` in its `Name=` field, to properly identify the application in menus and launchers.

#### Scenario: Application name in DMenu
- **WHEN** a user searches for the application
- **THEN** the name matching `surf_webapp_name` (e.g., "WhatsApp") is displayed without suffices.

### Requirement: Optional User Stylesheet Injection
The framework SHALL optionally inject a user stylesheet into the isolated webapp if one is provided in the source package.

#### Scenario: Webapp with custom CSS
- **WHEN** the package provides `files/user.css`
- **THEN** the wrapper creates a symlink from `/usr/share/surf-apps/<app_id>/user.css` to the isolated profile's `surf/styles/default.css` before running `surf`.