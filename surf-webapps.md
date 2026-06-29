# Isolated Surf Webapps in Void Linux

This guide explains how to package isolated webapps using the `surf` browser in
Void Linux via `xbps-src`.

By creating a package for each webapp, we achieve:

1. **Isolated Profiles**: Separate `XDG_DATA_HOME` and `XDG_CACHE_HOME` so apps
   don't share cookies, local storage, or cache.
2. **Proper Window Class**: We trick `surf` into using a custom executable name
   so window managers (like Sway, i3, or GNOME) correctly identify the app.
3. **Link Interception**: External links clicked inside the webapp are sent to
   the system's default browser instead of opening in a new `surf` window.
4. **Dependency Management**: Installation guarantees `surf` and required
   utilities are present.

## Package Template Structure

Below is an example of an `xbps-src` template for a WhatsApp webapp package.

Create the package directory in your local `void-packages` tree, e.g.,
`srcpkgs/surf-app-whatsapp/template`:

```bash
# Template file for 'surf-app-whatsapp'
pkgname=surf-app-whatsapp
version=1.0
revision=1
build_style=meta
depends="surf desktop-file-utils"
short_desc="WhatsApp webapp profile running on isolated surf browser"
maintainer="Your Name <your@email.com>"
license="Public Domain"
homepage="https://voidlinux.org"

do_install() {
	# 1. Create the wrapper script to intercept links
	vmkdir usr/libexec/surf-apps
	cat <<-'EOF' > "${DESTDIR}/usr/libexec/surf-apps/whatsapp"
	#!/bin/sh
	# Intercept links and send them to the default browser
	for url in "$@"; do :; done
	exec xdg-open "$url"
	EOF
	chmod +x "${DESTDIR}/usr/libexec/surf-apps/whatsapp"

	# 2. Create the Desktop Entry
	vmkdir usr/share/applications
	cat <<-'EOF' > "${DESTDIR}/usr/share/applications/whatsapp-surf.desktop"
	[Desktop Entry]
	Name=WhatsApp
	Comment=WhatsApp Web App
	# Note: exec -a overrides the argv[0] of surf so it uses our interceptor for new windows
	Exec=sh -c 'XDG_DATA_HOME="$HOME/.surf_profiles/whatsapp/data" XDG_CACHE_HOME="$HOME/.surf_profiles/whatsapp/cache" exec -a "/usr/libexec/surf-apps/whatsapp" surf -c "$HOME/.surf_profiles/whatsapp/cookies.txt" "https://web.whatsapp.com/"'
	Icon=whatsapp
	Terminal=false
	Type=Application
	Categories=Network;WebBrowser;
	EOF
}
```

## How to adapt for other webapps

To create a package for another app (e.g., Discord):

1. Duplicate the folder:
   `cp -r srcpkgs/surf-app-whatsapp srcpkgs/surf-app-discord`
2. Change the `pkgname`, `short_desc`, and paths in the `do_install` block.
3. Update the URL in the `.desktop` file to `https://discord.com/app`.
4. Update the `Icon=` field to match your theme's icon name for that app.
