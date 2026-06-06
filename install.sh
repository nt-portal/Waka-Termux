#!/bin/bash

set -e

BASHRC="$HOME/.bashrc"
WAKA_CFG="$HOME/.wakatime.cfg"

echo "Starting WakaTime installation..."

pkg update -y
pkg upgrade -y
pkg install -y python python-pip

pip install wakatime

touch "$BASHRC"
touch "$WAKA_CFG"

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$BASHRC"; then
    echo '' >> "$BASHRC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$BASHRC"
fi

if ! grep -q "WakaTime tracking" "$BASHRC"; then
    echo '
if command -v wakatime >/dev/null 2>&1; then
    set +m

    export WAKATIME_LAST_DIR="$PWD"

    cd() {
        builtin cd "$@" || return
        export WAKATIME_LAST_DIR="$PWD"
    }

    __wakatime_track() {
        (
            wakatime \
                --plugin "termux-shell/1.5" \
                --entity "$WAKATIME_LAST_DIR" \
                --entity-type app \
                --project "$(basename "$WAKATIME_LAST_DIR")" \
                --language Bash \
                --category coding \
                --write \
                >/dev/null 2>&1
        ) </dev/null >/dev/null 2>&1 &
        disown 2>/dev/null
    }

    __wakatime_timer() {
        while true; do
            wakatime \
                --plugin "termux-shell/1.5" \
                --entity "$WAKATIME_LAST_DIR" \
                --entity-type app \
                --project "$(basename "$WAKATIME_LAST_DIR")" \
                --language Bash \
                --category coding \
                --write \
                >/dev/null 2>&1

            sleep 120
        done
    }

    PROMPT_COMMAND="__wakatime_track${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

    if [ -z "$WAKATIME_TIMER_STARTED" ]; then
        export WAKATIME_TIMER_STARTED=1
        __wakatime_timer </dev/null >/dev/null 2>&1 &
        disown 2>/dev/null
    fi

fi' >> "$BASHRC"
fi

if [ ! -f "$WAKA_CFG" ]; then
    echo '[settings]
api_key = waka_api
debug = false
hidefilenames = true
ignore =
    COMMIT_EDITMSG$
    PULLREQ_EDITMSG$
    MERGE_MSG$
    TAG_EDITMSG$' >> "$WAKA_CFG"
fi

source ~/.bashrc

echo "----------------------------------------------------"
echo "Instalasi selesai!"
echo "Silakan buka editor termux seperti nano atau neovim"
echo "lalu edit ~/.wakatime.cfg dan isi API key kamu."
echo "Dapatkan API key di: https://wakatime.com/settings/account"
echo "Setelah itu jalankan: source ~/.bashrc"
echo "----------------------------------------------------"
