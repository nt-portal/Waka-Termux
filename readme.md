# WakaTime for Termux

WakaTime for Termux allows you to automatically track your coding activity directly from your shell. Monitor your productivity and keep track of how much time you spend on different projects.

---

## Prerequisites

It is recommended to use the version of Termux from F-Droid or GitHub, as the Play Store version is outdated.

- [F-Droid](https://f-droid.org/packages/com.termux)
- [GitHub Releases](https://github.com/termux/termux-app/releases)

---

## Installation

1. **Sign Up**: Register for a WakaTime account at [wakatime.com](https://wakatime.com).
2. **Run the Installer**:

   ```bash
   curl -sL https://github.com/nt-portal/Waka-Termux/raw/main/install.sh | bash
   ```

3. **Configure**: The installer will open `~/.wakatime.cfg`. Paste your API key there. You can find your API key in your [WakaTime account settings](https://wakatime.com/settings/account).

4. **Restart Shell**: Run `source ~/.bashrc` or restart your terminal to start tracking.

---

## Features

- Automatic tracking of shell activity.
- Project detection based on the current directory.
- Background execution to avoid terminal lag.

---

<p align="center">Made with ❤️ by TDev</p>
