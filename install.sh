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
    # Uses "C" only for $HOME (generic terminal activity).
    # For project folders, detects language from file extensions found inside.
    __wakatime_get_lang() {
        local _dir="${1:-$PWD}"
        if [ "$_dir" = "$HOME" ]; then
            echo "C"
        else
            echo "Bash"
        fi
    }

    # Detects language based on file extension.
    # Returns a WakaTime-compatible language name.
    __wakatime_detect_lang() {
        local _file="$1"
        case "${_file##*.}" in
            py)         echo "Python" ;;
            js)         echo "JavaScript" ;;
            ts)         echo "TypeScript" ;;
            jsx)        echo "JSX" ;;
            tsx)        echo "TSX" ;;
            sh|bash)    echo "Bash" ;;
            c)          echo "C" ;;
            cpp|cc|cxx) echo "C++" ;;
            h|hpp)      echo "C" ;;
            java)       echo "Java" ;;
            kt)         echo "Kotlin" ;;
            go)         echo "Go" ;;
            rs)         echo "Rust" ;;
            rb)         echo "Ruby" ;;
            php)        echo "PHP" ;;
            html|htm)   echo "HTML" ;;
            css)        echo "CSS" ;;
            json)       echo "JSON" ;;
            xml)        echo "XML" ;;
            yml|yaml)   echo "YAML" ;;
            md)         echo "Markdown" ;;
            sql)        echo "SQL" ;;
            dart)       echo "Dart" ;;
            swift)      echo "Swift" ;;
            lua)        echo "Lua" ;;
            r|R)        echo "R" ;;
            toml)       echo "TOML" ;;
            ini|cfg)    echo "INI" ;;
            txt)        echo "Text" ;;
            *)          echo "Unknown" ;;
        esac
    }

    # Scans files in a directory and sends individual heartbeats
    # for each file to WakaTime. Uses shell globs (no external commands).
    # Files appear in WakaTime's heard/Status under the project.
    # Skips hidden files/dirs, node_modules, .git, and binary files.
    __wakatime_scan_files() {
        local _dir="$1"
        local _project="$2"
        local _count=0
        local _scan_file="$HOME/.wakatime/.scan_${_project}"

        # Skip if scanned recently (within 120 seconds)
        if [ -f "$_scan_file" ]; then
            local _last_scan
            _last_scan=$(cat "$_scan_file" 2>/dev/null)
            local _now
            _now=$(date +%s)
            [ $((_now - _last_scan)) -lt 120 ] && return
        fi

        # Scan files using shell globs — no external bash commands
        for _entry in "$_dir"/*; do
            [ -f "$_entry" ] || continue

            local _basename="${_entry##*/}"
            # Skip hidden files
            case "$_basename" in .*) continue ;; esac
            # Skip common non-code files
            case "$_basename" in *.tar.gz|*.zip|*.7z|*.rar) continue ;; esac

            local _lang
            _lang=$(__wakatime_detect_lang "$_basename")

            wakatime \
                --plugin "termux-bash/1.5" \
                --entity "$_entry" \
                --entity-type file \
                --project "$_project" \
                --language "$_lang" \
                --category coding \
                --write \
                >/dev/null 2>&1

            _count=$((_count + 1))
        done

        # Record scan timestamp
        date +%s >"$_scan_file" 2>/dev/null
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
    # Uses find + shell builtins instead of ls|tail|xargs pipeline.
    __wakatime_backup() {
        local _path="$1"
        local _project="$2"
        local _backup_dir="$HOME/.wakatime/backups"
        mkdir -p "$_backup_dir"
        [ "$_project" = "Home Termux" ] && return
        [[ "$_path" == "$_backup_dir"* ]] && return
        local _last_backup="$_backup_dir/.$_project.last_backup"
        local _now
        _now=$(date +%s)
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
                # Cleanup old backups: keep only 5 newest, remove rest
                # Uses find + sort instead of ls|tail|xargs
                local _i=0
                for _bf in $(find "$_backup_dir" -maxdepth 1 \
                    -name "${_project}_*.tar.gz" -type f \
                    -printf '%T@ %p\n' 2>/dev/null \
                    | sort -rn | cut -d' ' -f2-); do
                    _i=$((_i + 1))
                    [ "$_i" -gt 5 ] && rm -f "$_bf"
                done
            ) &
            disown 2>/dev/null
        fi
    }

    # Background timer that sends a WakaTime heartbeat every 60 seconds.
    # Reads the current directory from the temp file written by __wakatime_track,
    # since the timer runs in a subshell and cannot see the parent's $PWD directly.
    # Also scans files in the directory and sends per-file heartbeats.
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
            # Scan files in project directories (not $HOME)
            [ "$_project" != "Home Termux" ] && __wakatime_scan_files "$_path" "$_project"
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