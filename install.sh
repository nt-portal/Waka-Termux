#!/bin/bash

# WakaTime Termux & Linux Installer
# Optimized for Termux, Ubuntu, and Debian

set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "Starting WakaTime installation..."

# Detect environment and install dependencies
if command_exists pkg; then
    echo "Detected Termux environment."
    pkg update && pkg upgrade -y
    pkg install -y python python-pip nano
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
    pip3 install --user wakatime
elif command_exists pip; then
    pip install --user wakatime
else
    echo "Error: pip not found. Please install python-pip manually."
    exit 1
fi

# Ensure ~/.local/bin is in PATH for the current session and future ones
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
                --category Coding \
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
