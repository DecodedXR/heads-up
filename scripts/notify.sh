#!/usr/bin/env bash
# Desktop notification for a Claude Code hook. Reads the hook's JSON on stdin.
# Windows (Git Bash) and WSL: native toast via PowerShell. macOS: osascript. Linux: notify-send.

input=$(cat)
field() { printf '%s' "$input" | sed -n "s/.*\"$1\" *: *\"\(\([^\"\\\\]\|\\\\.\)*\)\".*/\1/p" | head -1 | sed 's/\\"/"/g; s/\\\\/\\/g'; }

event=$(field hook_event_name)
cwd=$(field cwd)
project=${cwd//\\//}
project=${project%/}
project=${project##*/}
title="Claude Code${project:+ · $project}"

if [ "$event" = "Stop" ]; then
  [ "${CLAUDE_PLUGIN_OPTION_NOTIFY_ON_FINISH:-true}" = "false" ] && exit 0
  message="Finished. Your turn."
else
  message=$(field message)
  message=${message:-Needs your attention}
fi

dir=$(cd "$(dirname "$0")" && pwd)
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w "$dir/toast.ps1")" "$title" "$message" ;;
  Darwin)
    osascript - "$title" "$message" <<'EOF'
on run argv
  display notification (item 2 of argv) with title (item 1 of argv) sound name "Glass"
end run
EOF
    ;;
  *)
    if grep -qi microsoft /proc/version 2>/dev/null; then
      powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(wslpath -w "$dir/toast.ps1")" "$title" "$message"
    elif command -v notify-send >/dev/null; then
      notify-send -a "Claude Code" "$title" "$message"
    else
      printf '\a' > /dev/tty 2>/dev/null
    fi ;;
esac
exit 0
