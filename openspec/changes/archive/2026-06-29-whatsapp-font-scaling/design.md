## Context

Recent changes to the `surf-webapp` framework achieved 100% environment sandbox isolation for web applications by overriding the `HOME` variable. However, because vanilla `surf` falls back to `~/.surf/styles/` internally when `XDG_CONFIG_HOME` isn't respected natively, our framework's wrapper script misconfigured the CSS symlink path as `$ISOLATED_CONFIG/surf/styles/default.css` instead of `$ISOLATED_CONFIG/.surf/styles/default.css`.

Simultaneously, `surf-app-whatsapp` renders painfully small text with broken (bold) font weights on modern high-DPI displays due to `fontconfig` resolving to `DejaVu Sans` when `surf` tries to map generic sans-serif aliases in its WebKit2GTK viewport. Native zoom functionality (`-z`) via WebKit2GTK is either broken in the target version of `surf` or being aggressively overridden by WhatsApp's React DOM state.

## Goals / Non-Goals

**Goals:**
- Fix the CSS injection path generation bug inside the `surf-webapp` build style.
- Inject a targeted CSS payload into the `surf-app-whatsapp` package to resolve its small font and broken weight rendering.

**Non-Goals:**
- Do not modify global user `fontconfig` settings.
- Do not implement custom native zooming (`-z`) flags inside the `surf-webapp` framework since they are ineffective for this specific web application.

## Decisions

### 1. Fix CSS Framework Path
The `build_style` wrapper script will be modified to construct the `STYLE_DEST` path utilizing `.surf/styles/default.css` instead of `surf/styles/default.css` to account for `surf`'s default fallback logic when executing under an overridden `$HOME`.

### 2. Targeted CSS Payload for WhatsApp
Instead of relying on the native `-z` flag, the `surf-app-whatsapp` package will include a `files/user.css` containing a surgically targeted font sizing override.
The payload will use `105%` scaling at the `:root` level and `1.005em` at layout levels. Crucially, it will utilize `font-weight: inherit !important;` to ensure that fallback fonts (like `DejaVu Sans`) do not aggressively bold themselves when the size is manipulated.

## Risks / Trade-offs

- **Risk: WebApp DOM Instability**: WhatsApp Web is a highly obfuscated React application that aggressively injects its own CSS parameters. The `!important` overriding tags might break certain visual components if WhatsApp's DOM tree updates fundamentally in the future.
  *Mitigation*: The CSS changes are highly scoped (targeting basic typography tags rather than obscure classes) and focus entirely on relative scaling (`em` and `%`) rather than absolute `px` constraints.