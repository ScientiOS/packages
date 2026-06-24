## Why

ScientiOS currently lacks Zen Browser as an available package. Zen Browser is a popular, privacy-focused Firefox fork that users frequently request. Providing it natively via a binary package in our repository will improve the user desktop experience without burdening our build infrastructure with a massive source compilation of the Mozilla engine.

## What Changes

- Create a new `zen-browser` package in the `srcpkgs` directory.
- Implement an installation template that downloads, extracts, and integrates the pre-compiled `zen.linux-x86_64.tar.xz` binary release.
- Integrate the browser into the desktop environment by providing an extracted icon and a dynamically generated `.desktop` file.
- Exclude complex wrapper scripts for Wayland/X11 switching at the package level, relying instead on future global OS environment configurations for display server detection.

## Capabilities

### New Capabilities
- `zen-browser-package`: Defines the requirements, dependencies, and expected system integration of the new Zen Browser package on ScientiOS.

### Modified Capabilities
None.

## Impact

- **Affected code:** `srcpkgs/zen-browser/template` (new file)
- **Dependencies:** Relies on `xbps-src` auto-detection for runtime shared libraries (GTK3, libX11, etc.).
- **Systems:** Exposes the `zen-browser` command globally and adds it to the desktop applications menu. No existing packages or core systems are modified.