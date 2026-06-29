## MODIFIED Requirements

### Requirement: Optional User Stylesheet Injection
The framework SHALL optionally inject a user stylesheet into the isolated webapp if one is provided in the source package.

#### Scenario: Webapp with custom CSS
- **WHEN** the package provides `files/user.css`
- **THEN** the wrapper creates a symlink from `/usr/share/surf-apps/<app_id>/user.css` to the isolated profile's `.surf/styles/default.css` before running `surf`.