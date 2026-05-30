# slack-desktop

**Slack** is a proprietary messaging app for teams, bringing all your
communication and tools into one place.

## Details

- **Version:** 4.49.89
- **License:** Proprietary (Restricted)
- **Upstream:** [slack.com](https://slack.com/)

## Installation

Because Slack is proprietary software, it is located in the `nonfree`
sub-repository. You must configure your XBPS to include this specific path.

1. Add the `nonfree` repository:
   ```bash
   echo "repository=https://scientios.github.io/packages/nonfree/" | sudo tee /etc/xbps.d/10-scientios-nonfree.conf
   ```
2. Install the package:
   ```bash
   sudo xbps-install -Sy slack-desktop
   ```
