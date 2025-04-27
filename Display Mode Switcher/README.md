# Steam Display Switcher 

## Why I Made This

Switching my display resolution and power plan every time I wanted to play _Hogwarts Legacy_ was starting to get annoying. My Dell XPS runs the game way smoother at 1440p than the full 5K resolution of my Studio Display, but manually tweaking settings every session felt like unnecessary friction. So I created a small system to automate the whole thing.
## What It Does

This setup toggles my display mode and power profile when Steam launches and reverts them when it closes with a tray icon to visually confirm the mode I'm in. It started as two PowerShell scripts, evolved into batch files for convenience, and now lives inside a watcher script that tracks the Steam process in real time.

## Scripts Overview

### `Set-GamingMode.ps1` / `Set-GamingMode.bat`

- Changes the display resolution to 2560x1440.
- Switches to the "High performance" power plan.
- Intended for gaming sessions.
- The `.bat` file is just a wrapper so I can double-click it or call it from other scripts without needing to invoke PowerShell directly.

### `Set-StudioDisplayMode.ps1` / `Set-StudioDisplayMode.bat`

- Reverts the display resolution to 5120x2880 (Studio Display native).
- Switches back to "Balanced" or a custom power plan suited for day-to-day use.
- Again, The `.bat` file is just a wrapper so I can double-click it or call it from other scripts without needing to invoke PowerShell directly.

### `SteamTrayWatcher.ps1`

This ties both `.bat` scripts together and adds a system tray icon in the taskbar to show which display resolution and power plan mode is currently active:
- Runs in the background and checks every 5 seconds whether Steam is running.
- When Steam opens, it runs `Set-GamingMode.bat` and updates the system tray icon to a game controller.
- When Steam closes, it waits a few seconds (to ensure Steam really shut down) and then runs `Set-StudioDisplayMode.bat`, changing the icon back to a monitor.

The tray icon gives me visual feedback about the current mode without needing to open Task Manager or guess if the scripts actually ran.