# ScientiOS Packages

This repository contains custom [XBPS](https://github.com/void-linux/xbps)
package templates for applications and tools used by ScientiOS that are not
available in the official [Void Linux](https://voidlinux.org/) repositories.

## Overview

- **Custom Packages**: A curated collection of `template` files for software
  required by the ScientiOS ecosystem.
- **Local Building**: Designed to be built locally using `xebuild` and the
  `XBPS_DISTDIR` environment variable, keeping this repository clean of the
  official `void-packages` tree.
- **Automated CI/CD**: Packages are automatically built, signed, and published
  via CI/CD pipelines whenever changes are pushed to this repository.

## Local Development

To build these packages locally on a Void Linux system, you do not need to clone
the official `void-packages` repository inside this directory. Instead, use
`xtools` and environment variables.

### Prerequisites

1. Install `xtools`:

   ```bash
   sudo xbps-install -Su xtools
   ```

2. Clone and bootstrap the official `void-packages` repo somewhere on your
   system (e.g., in your home directory):

   ```bash
   git clone https://github.com/void-linux/void-packages.git ~/void-packages
   cd ~/void-packages
   ./xbps-src binary-bootstrap
   ```

3. Export the `XBPS_DISTDIR` environment variable (you can add this to your
   `~/.bashrc` or `~/.zshrc`):
   ```bash
   export XBPS_DISTDIR="$HOME/void-packages"
   ```

### Building a Package

Navigate to the specific package directory inside `srcpkgs/` and run `xebuild`:

```bash
cd srcpkgs/<package-name>
xebuild pkg
```

The resulting binary `.xbps` files will be placed in
`$XBPS_DISTDIR/hostdir/binpkgs`.

## CI/CD Pipeline

This repository implements an automated pipeline that:

1. Sets up the `void-packages` build environment inside a container.
2. Injects the custom templates from this repository.
3. Builds the packages using `xbps-src`.
4. Signs the resulting `.xbps` files and repository index.
5. Publishes the updated repository for consumption by ScientiOS users.

## Usage

To use this custom repository on your Void Linux machine, create a repository
configuration file at `/etc/xbps.d/scientios.conf`:

```ini
repository=https://packages.scientios.org/
```

_Note: Ensure you have added the corresponding public key to
`/var/db/xbps/keys/` to verify package signatures._
