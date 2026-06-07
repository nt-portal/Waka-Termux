#!/bin/bash

set -e

BASHRC="$HOME/.bashrc"
WAKA_CFG="$HOME/.wakatime.cfg"

echo "Starting WakaTime installation..."

pkg update -y
pkg install python -y

pip install wakatime

touch "$BASHRC"

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$BASHRC"; then
  echo '' >>"$BASHRC"
  echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$BASHRC"
fi

if ! grep -q "WakaTime tracking" "$BASHRC"; then
  cat >>"$BASHRC" <<'EOF'

if command -v wakatime >/dev/null 2>&1; then
    set +m

    __wakatime_track() {
        local _path="$PWD"
        (
            wakatime \
                --plugin "termux-bash/1.5" \
                --entity "$_path" \
                --entity-type app \
                --project "$(basename "$_path")" \
                --language Bash \
                --category coding \
                --os Linux \
                --write \
                >/dev/null 2>&1
        ) </dev/null >/dev/null 2>&1 &
        disown 2>/dev/null
    }

    __wakatime_timer() {
        while true; do
            local _path="$PWD"
            wakatime \
                --plugin "termux-bash/1.5" \
                --entity "$_path" \
                --entity-type app \
                --project "$(basename "$_path")" \
                --language Bash \
                --category coding \
                --os Linux \
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
fi
EOF
fi

if ! grep -q "api_key" "$WAKA_CFG" 2>/dev/null; then
  cat >"$WAKA_CFG" <<'EOF'
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

source ~/.bashrc

echo "----------------------------------------------------"
echo "Instalasi selesai!"
echo "Silakan buka editor termux seperti nano atau neovim"
echo "lalu edit ~/.wakatime.cfg dan isi API key kamu."
echo "Dapatkan API key di: https://wakatime.com/settings/account"
echo "Setelah itu jalankan: source ~/.bashrc"
echo "----------------------------------------------------"
