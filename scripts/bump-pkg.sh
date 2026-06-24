#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <package-name>"
    exit 1
fi

PKG="$1"
TEMPLATE_FILE="srcpkgs/$PKG/template"

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file for $PKG not found at $TEMPLATE_FILE"
    exit 1
fi

if [ ! -x "srcpkgs/$PKG/update" ]; then
    echo "Error: Update script for $PKG not found or not executable"
    exit 1
fi

# Get current version from template
CURRENT_VERSION=$(grep '^version=' "$TEMPLATE_FILE" | cut -d= -f2 | tr -d '"')

if [ -z "$CURRENT_VERSION" ]; then
    echo "Error: Could not determine current version for $PKG"
    exit 1
fi

# Get latest version from update script
NEW_VERSION=$("./srcpkgs/$PKG/update")

if [ -z "$NEW_VERSION" ]; then
    echo "Error: Could not determine latest version for $PKG"
    exit 1
fi

echo "Current version: $CURRENT_VERSION"
echo "New version: $NEW_VERSION"

if [ "$CURRENT_VERSION" = "$NEW_VERSION" ]; then
    echo "Package $PKG is up to date"
    echo "BUMPED=false" >> "$GITHUB_ENV"
    exit 0
fi

# Compare versions
# Use sort -V to compare versions. The first output line is the older version.
OLDER_VERSION=$(printf "%s\n%s" "$CURRENT_VERSION" "$NEW_VERSION" | sort -V | head -n1)

if [ "$OLDER_VERSION" != "$CURRENT_VERSION" ]; then
    echo "Current version ($CURRENT_VERSION) is newer than upstream ($NEW_VERSION)? Ignoring."
    echo "BUMPED=false" >> "$GITHUB_ENV"
    exit 0
fi

echo "Bumping $PKG from $CURRENT_VERSION to $NEW_VERSION"

# Update version and reset revision to 1
sed -i "s/^version=.*/version=$NEW_VERSION/" "$TEMPLATE_FILE"
sed -i "s/^revision=.*/revision=1/" "$TEMPLATE_FILE"

# Extract the distfiles URL
DISTFILES_URL=$(grep '^distfiles=' "$TEMPLATE_FILE" | cut -d= -f2 | tr -d '"' | sed "s/\${version}/$NEW_VERSION/g" | sed "s/\${pkgname}/$PKG/g")

if [ -z "$DISTFILES_URL" ]; then
    echo "Error: Could not determine distfiles URL"
    exit 1
fi

echo "Downloading $DISTFILES_URL to calculate new checksum..."

# Create a temporary directory for the download
TEMP_DIR=$(mktemp -d)
TEMP_FILE="$TEMP_DIR/distfile"

# Download the file
if ! curl -L -f -o "$TEMP_FILE" "$DISTFILES_URL"; then
    echo "Error: Failed to download $DISTFILES_URL"
    # Revert template changes
    sed -i "s/^version=.*/version=$CURRENT_VERSION/" "$TEMPLATE_FILE"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Calculate SHA-256 checksum
NEW_CHECKSUM=$(sha256sum "$TEMP_FILE" | awk '{print $1}')

if [ -z "$NEW_CHECKSUM" ]; then
    echo "Error: Failed to calculate checksum"
    # Revert template changes
    sed -i "s/^version=.*/version=$CURRENT_VERSION/" "$TEMPLATE_FILE"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "New checksum: $NEW_CHECKSUM"

# Update checksum in template
sed -i "s/^checksum=.*/checksum=$NEW_CHECKSUM/" "$TEMPLATE_FILE"

# Clean up
rm -rf "$TEMP_DIR"

echo "Successfully bumped $PKG to $NEW_VERSION"
# Export variables for GitHub Actions
if [ -n "$GITHUB_ENV" ]; then
    echo "BUMPED=true" >> "$GITHUB_ENV"
    echo "NEW_VERSION=$NEW_VERSION" >> "$GITHUB_ENV"
fi
exit 0