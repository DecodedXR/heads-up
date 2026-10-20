# Heads-up: desktop notifications for Claude Code

Stop checking the terminal. Heads-up pops a desktop notification when Claude Code **needs your permission or input**, and when it **finishes a turn**. The notification is titled with the project name, so you know which session is waiting.

| Platform | How it notifies |
|---|---|
| **Windows 10/11** | Native toast through built-in Windows PowerShell. No BurntToast or other modules |
| **WSL** | The same Windows toast, called from inside WSL |
| **macOS** | Notification Center via `osascript`, with a sound |
| **Linux** | `notify-send`, or a terminal bell if that isn't installed |

## Install

```
/plugin marketplace add DecodedXR/heads-up
/plugin install heads-up@heads-up
```

That's it. No settings to edit.

## What triggers a notification

- Claude asks for **permission** to use a tool
- Claude asks you a **question** or a subagent needs input
- Claude **finishes** a turn ("Finished. Your turn.")

Too many "finished" pings during quick back-and-forth? Turn off **Notify when Claude finishes** in `/config` (under the heads-up plugin). You'll still get permission and question alerts.

## Requirements

- On Windows, Claude Code runs hooks with Git Bash, which comes with Git for Windows.
- If a toast doesn't appear on Windows, check **Settings → System → Notifications**: notifications must be on for **Windows PowerShell**, and Do Not Disturb must be off.
- On macOS, allow notifications for **Script Editor** the first time macOS asks.

## Privacy

Everything runs locally. No network calls, no telemetry, and nothing is logged.

## More from DecodedXR

- [Autopilot & Wargame](https://github.com/DecodedXR/claude-workflow-skills): Claude Code skills for long and unattended sessions.

## License

MIT. See `LICENSE`.
