#!/bin/bash

set -e

BASHRC="$HOME/.bashrc"
WAKA_CFG="$HOME/.wakatime.cfg"

pkg update -y
pkg install python -y
pip install wakatime

touch "$BASHRC"

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$BASHRC"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$BASHRC"
fi

cat >>"$BASHRC" <<'EOF'
if command -v wakatime >/dev/null 2>&1; then
    set +m
    __wakatime_get_project() {
        local _dir="${1:-$PWD}"
        if [ "$_dir" = "$HOME" ]; then
            echo "Home Termux"
        else
            basename "$_dir"
        fi
    }
    __wakatime_get_lang() {
        local _dir="${1:-$PWD}"
        if [ "$_dir" = "$HOME" ]; then
            echo "C"
        else
            echo "Bash"
        fi
    }
    __wakatime_track() {
        local _path="$PWD"
        local _project=$(__wakatime_get_project "$_path")
        local _lang=$(__wakatime_get_lang "$_path")
        (
            wakatime \
                --plugin "termux-bash/1.5" \
                --entity "$_path" \
                --entity-type file \
                --project "$_project" \
                --language "$_lang" \
                --category coding \
                --write \
                >/dev/null 2>&1
        ) </dev/null >/dev/null 2>&1 &
        disown 2>/dev/null
    }
    __wakatime_backup() {
        local _path="$1"
        local _project="$2"
        local _backup_dir="$HOME/.wakatime/backups"
        mkdir -p "$_backup_dir"
        [ "$_project" = "Home Termux" ] && return
        [[ "$_path" == "$_backup_dir"* ]] && return
        local _last_backup="$_backup_dir/.$_project.last_backup"
        local _now=$(date +%s)
        local _last=0
        [ -f "$_last_backup" ] && _last=$(cat "$_last_backup")
        if [ $((_now - _last)) -gt 86400 ]; then
            (
                tar -czf "$_backup_dir/${_project}_$(date +%Y%m%d_%H%M%S).tar.gz" -C "$(dirname "$_path")" "$(basename "$_path")" --exclude=".git" --exclude="node_modules" >/dev/null 2>&1
                echo "$_now" >"$_last_backup"
                ls -t "$_backup_dir/${_project}_"*.tar.gz 2>/dev/null | tail -n +6 | xargs rm -f 2>/dev/null
            ) &
        fi
    }
    __wakatime_timer() {
        while true; do
            local _path=$(readlink /proc/$PPID/cwd 2>/dev/null || echo "$PWD")
            local _project=$(__wakatime_get_project "$_path")
            local _lang=$(__wakatime_get_lang "$_path")
            wakatime \
                --plugin "termux-bash/1.5" \
                --entity "$_path" \
                --entity-type file \
                --project "$_project" \
                --language "$_lang" \
                --category coding \
                --write \
                >/dev/null 2>&1
            [ "$_project" != "Home Termux" ] && __wakatime_backup "$_path" "$_project"
            sleep 60
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

if [ ! -f "$WAKA_CFG" ] || ! grep -q "api_key" "$WAKA_CFG"; then
  cat >"$WAKA_CFG" <<'EOF'
[settings]
api_key = waka_api
debug = false
hidefilenames = false
ignore =
    COMMIT_EDITMSG$
    PULLREQ_EDITMSG$
    MERGE_MSG$
    TAG_EDITMSG$
EOF
else
  sed -i 's/hidefilenames = true/hidefilenames = false/g' "$WAKA_CFG"
fi

echo "----------------------------------------------------"
echo "Installation complete!"
echo "Please open a Termux editor like nano or neovim,"
echo "then edit ~/.wakatime.cfg and paste your API key."
echo "Get your API key at: https://wakatime.com/settings/account"
echo "----------------------------------------------------"
echo "USAGE GUIDE:"
echo "1. Project 'Home Termux' (Language: C) when in $HOME"
echo "2. Project 'Folder Name' (Language: Bash) when in other folders"
echo "3. Automatic backups are saved in ~/.wakatime/backups"
echo "----------------------------------------------------"
echo "Please run: source ~/.bashrc"
echo "----------------------------------------------------"
source "$BASHRC" 2>/dev/null || true
