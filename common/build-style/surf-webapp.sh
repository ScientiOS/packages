# common/build-style/surf-webapp.sh

do_install() {
	if [ -z "$surf_webapp_url" ]; then
		msg_error "$pkgname: surf_webapp_url must be set\n"
	fi
	if [ -z "$surf_webapp_name" ]; then
		msg_error "$pkgname: surf_webapp_name must be set\n"
	fi

	local app_id="${pkgname#surf-app-}"
	local icon_name="${surf_webapp_icon:-${app_id}}"

	# 1. Base surf command args
	local surf_args=""

	# Handle JS
	if [ "${surf_webapp_js}" = "no" ]; then
		surf_args="$surf_args -s"
	else
		surf_args="$surf_args -S" # Default yes
	fi

	# Handle Plugins
	if [ "${surf_webapp_plugins}" = "yes" ]; then
		surf_args="$surf_args -P"
	else
		surf_args="$surf_args -p" # Default no
	fi

	# 2. Wrapper Script
	vmkdir usr/libexec/surf-apps
	local wrapper_path="usr/libexec/surf-apps/${app_id}"

	cat <<'EOF' > "${DESTDIR}/${wrapper_path}"
#!/bin/sh

# --- PHASE 1: LINK INTERCEPTION ---
if [ "$#" -gt 0 ]; then
	# 1. Restore the original XDG variables if they were saved
	if [ -n "$REAL_XDG_DATA_HOME" ]; then
		export XDG_DATA_HOME="$REAL_XDG_DATA_HOME"
	else
		unset XDG_DATA_HOME
	fi

	if [ -n "$REAL_XDG_CACHE_HOME" ]; then
		export XDG_CACHE_HOME="$REAL_XDG_CACHE_HOME"
	else
		unset XDG_CACHE_HOME
	fi

	if [ -n "$REAL_XDG_CONFIG_HOME" ]; then
		export XDG_CONFIG_HOME="$REAL_XDG_CONFIG_HOME"
	else
		unset XDG_CONFIG_HOME
	fi
	
	unset REAL_XDG_DATA_HOME REAL_XDG_CACHE_HOME REAL_XDG_CONFIG_HOME

	# 2. Extract the last argument and open in default browser
	for url in "$@"; do :; done
	exec xdg-open "$url"
fi

# --- PHASE 2: ISOLATED APP LAUNCH ---
PROFILE_DIR="$HOME/.config/surf-app-profiles/APP_ID_PLACEHOLDER"
ISOLATED_DATA="$PROFILE_DIR/data"
ISOLATED_CACHE="$PROFILE_DIR/cache"
ISOLATED_CONFIG="$PROFILE_DIR/config"

mkdir -p "$ISOLATED_DATA" "$ISOLATED_CACHE" "$ISOLATED_CONFIG/surf/styles"

STYLE_SRC="/usr/share/surf-apps/APP_ID_PLACEHOLDER/user.css"
STYLE_DEST="$ISOLATED_CONFIG/surf/styles/default.css"

if [ -f "$STYLE_SRC" ]; then
	ln -sf "$STYLE_SRC" "$STYLE_DEST"
else
	rm -f "$STYLE_DEST"
fi

# Export original variables so Phase 1 can restore them if a link is clicked
export REAL_XDG_DATA_HOME="$XDG_DATA_HOME"
export REAL_XDG_CACHE_HOME="$XDG_CACHE_HOME"
export REAL_XDG_CONFIG_HOME="$XDG_CONFIG_HOME"

# Set the isolated paths for this surf instance
export XDG_DATA_HOME="$ISOLATED_DATA"
export XDG_CACHE_HOME="$ISOLATED_CACHE"
export XDG_CONFIG_HOME="$ISOLATED_CONFIG"

# We dynamically use bash or zsh to access the 'exec -a' built-in.
# This avoids a hard dependency on any specific shell while preserving
# the ability to intercept links (which requires spoofing argv[0]).
if command -v bash >/dev/null 2>&1; then
	exec bash -c "exec -a \"\$0\" surf -c \"\$1\" SURF_ARGS_PLACEHOLDER \"SURF_URL_PLACEHOLDER\"" "$0" "$PROFILE_DIR/cookies.txt"
elif command -v zsh >/dev/null 2>&1; then
	exec zsh -c "exec -a \"\$0\" surf -c \"\$1\" SURF_ARGS_PLACEHOLDER \"SURF_URL_PLACEHOLDER\"" "$0" "$PROFILE_DIR/cookies.txt"
else
	# Fallback if neither bash nor zsh is found. Link interception will fail,
	# but the webapp itself will still launch and remain isolated.
	exec surf -c "$PROFILE_DIR/cookies.txt" SURF_ARGS_PLACEHOLDER "SURF_URL_PLACEHOLDER"
fi
EOF

	# Replace placeholders in the wrapper
	sed -i -e "s|APP_ID_PLACEHOLDER|${app_id}|g" \
	       -e "s|SURF_ARGS_PLACEHOLDER|${surf_args}|g" \
	       -e "s|SURF_URL_PLACEHOLDER|${surf_webapp_url}|g" \
	       "${DESTDIR}/${wrapper_path}"

	chmod +x "${DESTDIR}/${wrapper_path}"

	# 3. Create Desktop File
	vmkdir usr/share/applications
	cat <<-EOF > "${DESTDIR}/usr/share/applications/${app_id}.desktop"
[Desktop Entry]
Name=${surf_webapp_name}
Comment=${surf_webapp_name} Web App (Isolated)
Exec=/usr/libexec/surf-apps/${app_id}
Icon=${icon_name}
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF

	# 4. Handle custom styles
	if [ -f "${FILESDIR}/user.css" ]; then
		vinstall "${FILESDIR}/user.css" 644 "usr/share/surf-apps/${app_id}"
	fi
}
