#!/bin/bash

set -e

BASHRC="$HOME/.bashrc"
WAKA_CFG="$HOME/.wakatime.cfg"

# ─── Install dependencies ────────────────────────────────────
pkg update -y
pkg install python -y
pip install wakatime --break-system-packages --quiet

touch "$BASHRC"
mkdir -p "$HOME/.wakatime"

# ─── Ensure PATH includes local bin ─────────────────────────
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$BASHRC"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$BASHRC"
fi

# ─── Inject WakaTime shell integration into .bashrc ─────────
# Guard against duplicate entries on re-run
if ! grep -q '__wakatime_track' "$BASHRC"; then
cat >>"$BASHRC" <<'EOF'

# ── WakaTime shell integration ────────────────────────────
if command -v wakatime >/dev/null 2>&1; then
    # Disable job control notifications in the background
    set +m

    # Returns the WakaTime project name based on current directory.
    # Uses "Home Termux" when in $HOME, otherwise uses the folder name.
    __wakatime_get_project() {
        local _dir="${1:-$PWD}"
        if [ "$_dir" = "$HOME" ]; then
            echo "Home Termux"
        else
            basename "$_dir"
        fi
    }

    # Returns the language label for WakaTime.
    # Uses "C" for $HOME (generic terminal), "Bash" for project folders.
    __wakatime_get_lang() {
        local _dir="${1:-$PWD}"
        if [ "$_dir" = "$HOME" ]; then
            echo "C"
        else
            echo "Bash"
        fi
    }

    # Sends a heartbeat to WakaTime on every prompt.
    # Also writes the current directory to a temp file so the
    # background timer can track directory changes between prompts.
    __wakatime_track() {
        local _path="$PWD"
        local _project=$(__wakatime_get_project "$_path")
        local _lang=$(__wakatime_get_lang "$_path")
        echo "$_path" >"$HOME/.wakatime/.current_dir" 2>/dev/null
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

    # Creates a compressed backup of the current project once per day.
    # Keeps only the 5 most recent backups per project.
    # Skips if: in Home Termux, inside the backup directory itself.
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
                tar -czf "$_backup_dir/${_project}_$(date +%Y%m%d_%H%M%S).tar.gz" \
                    -C "$(dirname "$_path")" \
                    "$(basename "$_path")" \
                    --exclude=".git" \
                    --exclude="node_modules" \
                    --exclude="*.tar.gz" \
                    >/dev/null 2>&1
                echo "$_now" >"$_last_backup"
                ls -t "$_backup_dir/${_project}_"*.tar.gz 2>/dev/null \
                    | tail -n +6 | xargs rm -f 2>/dev/null
            ) &
            disown 2>/dev/null
        fi
    }

    # Background timer that sends a WakaTime heartbeat every 60 seconds.
    # Reads the current directory from the temp file written by __wakatime_track,
    # since the timer runs in a subshell and cannot see the parent's $PWD directly.
    __wakatime_timer() {
        local _tmpfile="$HOME/.wakatime/.current_dir"
        echo "$PWD" >"$_tmpfile"
        while true; do
            local _path
            _path=$(cat "$_tmpfile" 2>/dev/null || echo "$HOME")
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

    # Hook __wakatime_track into every prompt
    PROMPT_COMMAND="__wakatime_track${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

    # Start the background timer once per session
    if [ -z "$WAKATIME_TIMER_STARTED" ]; then
        export WAKATIME_TIMER_STARTED=1
        __wakatime_timer </dev/null >/dev/null 2>&1 &
        disown 2>/dev/null
    fi
fi
# ── /WakaTime ─────────────────────────────────────────────
EOF
else
  echo "WakaTime integration already present in ~/.bashrc, skipping."
fi

# ─── Create WakaTime config if missing or incomplete ────────
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
  # Ensure filenames are not hidden if config already exists
  sed -i 's/hidefilenames = true/hidefilenames = false/g' "$WAKA_CFG"
fi

# ─── Done ───────────────────────────────────────────────────
echo "----------------------------------------------------"
echo "Installation complete!"
echo "Edit ~/.wakatime.cfg and replace 'waka_api' with your API key."
echo "Get your API key at: https://wakatime.com/settings/account"
echo "----------------------------------------------------"
echo "USAGE GUIDE:"
echo "1. Project 'Home Termux' (Language: C) when in \$HOME"
echo "2. Project 'Folder Name' (Language: Bash) when in other folders"
echo "3. Auto backups are saved to ~/.wakatime/backups"
echo "----------------------------------------------------"
echo "Run: source ~/.bashrc"
echo "----------------------------------------------------"