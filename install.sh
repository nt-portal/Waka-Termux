#!/bin/bash

# WakaTime Termux & Linux Installer
# Optimized for Termux, Ubuntu, and Debian

set -e

# Define PREFIX and HOME
HOME="${HOME:-$HOME}"
PREFIX="${PREFIX:-/usr}"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "Starting WakaTime installation..."

# Detect environment and install dependencies
IS_TERMUX=false
if [ -d "/data/data/com.termux/files/usr" ] || command_exists pkg; then
    IS_TERMUX=true
    echo "Detected Termux environment."
    # Ensure PREFIX is set correctly for Termux
    [ -z "$PREFIX" ] || [ "$PREFIX" = "/usr" ] && PREFIX="/data/data/com.termux/files/usr"
    pkg update && pkg upgrade -y
    pkg install -y python nano
elif command_exists apt-get; then
    echo "Detected Debian/Ubuntu-based environment."
    SUDO=""
    if command_exists sudo; then
        SUDO="sudo"
    fi
    $SUDO apt-get update
    $SUDO apt-get install -y python3 python3-pip nano
else
    echo "Error: No supported package manager found (apt or pkg)."
    exit 1
fi

# Install wakatime CLI
echo "Installing wakatime CLI..."
if command_exists pip3; then
    PIP_BIN="pip3"
elif command_exists pip; then
    PIP_BIN="pip"
else
    echo "Error: pip not found. Please install python-pip manually."
    exit 1
fi

# In Termux, global install is safe (it stays in $PREFIX). In Linux, --user is safer.
if [ "$IS_TERMUX" = true ]; then
    $PIP_BIN install wakatime
else
    $PIP_BIN install --user wakatime
fi

# Ensure ~/.local/bin is in PATH (primarily for non-Termux or if --user was used)
BASHRC="$HOME/.bashrc"
LOCAL_BIN="$HOME/.local/bin"
export PATH="$LOCAL_BIN:$PATH"

if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" "$BASHRC"; then
    echo -e '\n# Add ~/.local/bin to PATH\nexport PATH="$HOME/.local/bin:$PATH"' >> "$BASHRC"
fi

# Add WakaTime tracking logic to .bashrc
TRACKING_BLOCK='
# WakaTime tracking
if command -v wakatime >/dev/null 2>&1; then
    set +m
    __wakatime_track() {
        (
            wakatime \
                --plugin "termux-shell/1.5" \
                --entity "$(pwd)" \
                --entity-type app \
                --project "$(basename "$(pwd)")" \
                --language Bash \
                --category coding \
                --write \
                >/dev/null 2>&1
        ) </dev/null >/dev/null 2>&1 &
        disown 2>/dev/null
    }
    PROMPT_COMMAND="__wakatime_track"
fi'

if ! grep -q "__wakatime_track" "$BASHRC"; then
    echo "$TRACKING_BLOCK" >> "$BASHRC"
fi

# Config file setup
WAKA_CFG="$HOME/.wakatime.cfg"
if [ ! -f "$WAKA_CFG" ]; then
    echo "Creating default .wakatime.cfg..."
    cat <<EOF > "$WAKA_CFG"
[settings]
api_key = waka_api
debug = false
hidefilenames = true
ignore =
    COMMIT_EDITMSG$
    PULLREQ_EDITMSG$
    MERGE_MSG$
    TAG_EDITMSG$
EOF
fi

# Interactive setup
echo "Opening .wakatime.cfg for API key configuration..."
if command_exists nano; then
    nano "$WAKA_CFG"
else
    echo "Please edit $WAKA_CFG and replace 'waka_api' with your actual API key."
fi

# Open WakaTime settings page
if command_exists am; then
    echo "Opening WakaTime settings in browser..."
    am start -a android.intent.action.VIEW -d "https://wakatime.com/settings/account" || true
else
    echo "Please get your API key from: https://wakatime.com/settings/account"
fi

echo "----------------------------------------------------"
echo "Installation complete!"
echo "Please restart your terminal or run: source ~/.bashrc"
echo "----------------------------------------------------"
