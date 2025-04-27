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
- Switches back to "Balanced".
- Again, The `.bat` file is just a wrapper so I can double-click it or call it from other scripts without needing to invoke PowerShell directly.

### `SteamTrayWatcher.ps1`

This ties both `.bat` scripts together and adds a system tray icon in the taskbar to show which display resolution and power plan mode is currently active:
- Runs in the background and checks every 5 seconds whether Steam is running.
- When Steam opens, it runs `Set-GamingMode.bat` and updates the system tray icon to a game controller.
- When Steam closes, it waits a few seconds (to ensure Steam really shut down) and then runs `Set-StudioDisplayMode.bat`, changing the icon back to a monitor.

The tray icon gives me visual feedback about the current mode without needing to open Task Manager or guess if the scripts actually ran.

## Next Steps

Getting all of that working has been pretty great, but it also got me thinking, since I have a Raspberry Pi, LEDs, buttons, resistors, a breadboard — basically a bunch of hardware from previous classes that's just been sitting around collecting dust, why not actually use it?

The idea I landed on is to essentially build my own version of a Stream Deck — a little hardware device where you can map physical buttons to shortcuts. Instead of buying one, I figured I’d try making my own since I already have the parts.

Here’s what I’m imagining:

- I sit down at my computer and press a button wired to the Raspberry Pi.
- The Pi sends a signal over to the XPS.
- The watcher script — which is already running in the background — picks up the signal.
- Once it detects the button press, it launches Steam and automatically switches the resolution and power plan, just like it does now.
- The computer then sends a signal back to the Pi to light up an LED as a visual indicator that Steam is running.
- When I'm done playing, I press the button again.
- The Pi sends another signal to the XPS.
- Steam closes, the script runs to revert everything back to Studio Display Mode, and the LED switches to a different color.

It’s basically the same setup I already have, just expanded into something physical.