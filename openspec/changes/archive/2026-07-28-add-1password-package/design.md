## Context

ScientiOS builds custom Void Linux packages for software that is unavailable in the standard repositories. 1Password distributes a `.deb` package and a `.tar.gz` archive for Linux. Managing proprietary packages securely and maintaining updates can be challenging due to shifting download URLs (e.g., `latest.deb`). The existing build pipeline (`xbps-src`) natively unpacks `.deb` files securely. We want to integrate 1Password without disrupting the existing auto-bump workflow established for other applications like Zen Browser and Slack.

## Goals / Non-Goals

**Goals:**
- Provide a robust `xbps-src` template for 1Password desktop.
- Download static, versioned binaries to calculate exact checksums during builds.
- Hook into the existing GitHub Actions auto-update CI pipeline to keep the package updated natively.

**Non-Goals:**
- Re-architect the `auto-bump` or `xebuild` pipelines.
- Build 1Password from source (it's proprietary).
- Build or distribute the 1Password CLI as a separate package in this proposal (only the desktop application).

## Decisions

- **Decision 1: Use the `.deb` distribution instead of `.tar.gz`.**
  - *Rationale:* The Void Linux package build environment automatically decompresses `.deb` archives (via `ar` or `bsdtar`) during the extraction phase. The layout matches `opt/` and `usr/` paths closely, minimizing custom mapping in `do_install()`. We already do this successfully for `slack-desktop`.
- **Decision 2: Fetch package versions from the Debian repository `Packages` index.**
  - *Rationale:* Providers often host a single `latest.deb` URL which breaks reproducible checksums. However, their internal APT repository (`dists/stable/main/binary-amd64/Packages`) contains the exact version numbers and allows us to construct a static `pool/` URL. This makes the build 100% reproducible and enables auto-updates.

## Risks / Trade-offs

- **Risk: 1Password changes their APT repository structure.**
  - *Mitigation:* The nightly `auto-bump` CI will fail to find a new version or fail the checksum process. A developer will be alerted via standard CI failure notifications and can adjust the `update` regex.
- **Risk: Extracted `.deb` layout changes over time.**
  - *Mitigation:* `xbps-src` builds are isolated. If the internal layout shifts (e.g., binaries move out of `/opt/1Password`), the `do_install` steps will fail during CI, preventing a broken package from being merged.
