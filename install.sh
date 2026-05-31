pkg install python
pip install --user wakatime
echo 'export PATH="$HOME/.local/bin:$PATH"

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
fi
' >>~/.bashrc

echo '[settings]
api_key = waka_api
debug = false
hidefilenames = true
ignore =
    COMMIT_EDITMSG$
    PULLREQ_EDITMSG$
    MERGE_MSG$
    TAG_EDITMSG$' >>~/.wakatime.cfg
am start -a android.intent.action.VIEW -d "https://wakatime.com/settings/account"
sleep 2
nano ~/.wakatime.cfg
