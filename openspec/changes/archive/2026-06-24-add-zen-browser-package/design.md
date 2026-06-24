## Context

Zen Browser is a privacy-oriented, optimized fork of Firefox. Compiling it natively is extremely resource-intensive and prone to breakage due to the massive dependency tree (Rust, Node, LLVM, etc.) associated with the Mozilla engine. ScientiOS relies on `xbps-src` for package management, which natively supports binary repackaging via `template` definitions.

## Goals / Non-Goals

**Goals:**
- Provide a fast, easy-to-install Zen Browser package using the official pre-compiled x86_64 binary.
- Ensure the package feels like a native desktop application with an icon and `.desktop` entry.
- Lean on `xbps-src`'s automatic dependency resolution (via `shlibs`) to avoid unnecessary package bloat.

**Non-Goals:**
- Compiling Zen Browser from source code.
- Supporting architectures other than `x86_64` in this initial release.
- Modifying the host OS or creating global wrapper scripts to forcefully detect display servers (Wayland vs. X11); the package should remain display-server agnostic.

## Decisions

**1. Binary vs Source Packaging**
- *Decision*: We will package the pre-compiled `zen.linux-x86_64.tar.xz` release.
- *Rationale*: A source build requires hours of compile time and complex maintenance of a `mach` build environment. The binary route is trivial to maintain and fast to build.

**2. Dependency Management**
- *Decision*: Leave the `depends` variable largely empty in the template.
- *Rationale*: Zen Browser dynamically links to libraries like `libX11`, `libwayland-client`, `gtk+3`, and `libasound.so.2` (ALSA). `xbps-src` uses `objdump` post-installation to generate dependencies based on `shlibs`. Hardcoding them is redundant and can break if Mozilla changes their dynamic link targets in the future.

**3. Display Server Integration (.desktop File)**
- *Decision*: The generated `.desktop` file will have a vanilla `Exec=/usr/bin/zen-browser %u` command without forcing environment variables like `MOZ_ENABLE_WAYLAND=1`.
- *Rationale*: Packaging a custom wrapper script or hardcoding the variable in the `.desktop` file can cause crashes if a user boots an X11 session instead of Wayland. The responsibility for global environment variables belongs to the OS session configuration, not the individual application package.

## Risks / Trade-offs

- **Risk**: The binary release may dynamically link to a newer glibc or dependency version than what is currently available in ScientiOS.
  - *Mitigation*: The initial package test run via `xbps-src` will fail or warn if a required shared library cannot be resolved. We will monitor the test build.
- **Trade-off**: By not forcing `MOZ_ENABLE_WAYLAND=1` via a wrapper, Zen Browser might default to Xwayland on some Wayland setups, resulting in blurry fonts or missing native gestures.
  - *Mitigation*: This is acceptable for this package. A future OS-level change (`/etc/profile.d/mozilla-wayland.sh`) will be proposed separately to fix this globally for all Mozilla derivatives.