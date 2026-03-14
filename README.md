```
██████╗ ██╗███╗   ██╗██╗  ██╗██╗██╗  ██╗    ██╗  ██╗██╗   ██╗██████╗     ██╗   ██╗ ██████╗ 
██╔══██╗██║████╗  ██║╚██╗██╔╝██║╚██╗██╔╝    ██║  ██║██║   ██║██╔══██╗    ██║   ██║██╔════╝ 
██████╔╝██║██╔██╗ ██║ ╚███╔╝ ██║ ╚███╔╝     ███████║██║   ██║██████╔╝    ██║   ██║███████╗ 
██╔══██╗██║██║╚██╗██║ ██╔██╗ ██║ ██╔██╗     ██╔══██║██║   ██║██╔══██╗    ╚██╗ ██╔╝██╔═══██╗
██████╔╝██║██║ ╚████║██╔╝ ██╗██║██╔╝ ██╗    ██║  ██║╚██████╔╝██████╔╝     ╚████╔╝ ╚██████╔╝
╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝       ╚═══╝   ╚═════╝
```

<div align="center">

**Card UI Edition — Binxix Hub V7**

[![Version](https://img.shields.io/badge/version-7.000-blueviolet?style=for-the-badge)](https://github.com/binx-ux/airhub-binxix-v7)
[![Platform](https://img.shields.io/badge/platform-Roblox-00b4d8?style=for-the-badge)](https://roblox.com)
[![Language](https://img.shields.io/badge/language-Lua-purple?style=for-the-badge)](https://lua.org)
[![Status](https://img.shields.io/badge/status-active-brightgreen?style=for-the-badge)](https://github.com/binx-ux/airhub-binxix-v7)

*A universal Roblox script hub built from the ground up for V7.*

[**Discord**](https://discord.gg/S4nPV2Rx7F) · [**Report a Bug**](https://github.com/binx-ux/airhub-binxix-v7/issues) · [**guns.lol/binxix**](https://guns.lol/binxix)

</div>

---

## 📦 Loadstring

Copy and execute this in your Roblox executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/binx-ux/airhub-binxix-v7/refs/heads/main/script/aimbot"))()
```

> **Note:** The script auto-updates on every load. If a newer version is available a notification banner will appear inside the GUI.

> **Known Issue:** We are actively investigating FPS drops affecting some users. While we work on a fix, avoid using ESP, tracers, skeleton, chams, offscreen arrows, and the radar. These are the features most likely to cause drops. Thank you for your patience.

---

## 🗂️ Table of Contents

- [What's New in V7](#-whats-new-in-v7)
- [ESP](#-esp)
- [Aimbot](#-aimbot)
- [Crosshair](#-crosshair)
- [Radar](#-radar)
- [Gun Mods](#-gun-mods)
- [Movement](#-movement)
- [Misc](#-misc)
- [Game Support](#-game-support)
- [Keybinds](#-keybinds)
- [Themes](#-themes)
- [Config System](#-config-system)
- [Auto Updates](#-auto-updates)
- [Discord](#-discord)

---

## ✨ What's New in V7

### UI Overhaul
The entire interface has been rebuilt from scratch. V7 moves away from the flat horizontal tab bar and adopts a **sidebar + card layout** — a vertical tab list on the left and dense card-based sections filling the content area. Every section is a self-contained card with a colored header and a dark body.

- Animated **pill toggle switches** replace old checkboxes
- Sliding **knob sliders** with live value display
- **Multi-button enum rows** for option selection (e.g. Lock Part, Tracer Origin)
- Collapsible sidebar with logo, version, and game name
- Smooth tab switching with lazy-load — tabs only build their content when first opened
- **Animated progress bar loader** with executor detection and integrity check on startup
- Close button, drag to reposition, RightControl to toggle

### New Features
| Feature | Details |
|---|---|
| Player Radar | Live minimap circle in the bottom-left. Rotates with your camera. Enemy dots red, team dots green |
| Multi-Target Cycling | Enable in Aimbot tab, press `Tab` to cycle targets in your FOV sorted by screen distance |
| Crosshair Color Pickers | R/G/B sliders directly in the Crosshair tab for crosshair and outline color |
| Panic Key | Press `End` to instantly disable all features and hide the GUI in one press |
| Sniper Crosshair Style | Full viewport-spanning lines with a center gap |
| Integrity Check | Warns on load if a tampered version is detected |
| Executor Warning | Notifies if a weak executor is detected that may cause compatibility issues |

### Bug Fixes
| Fix | Details |
|---|---|
| LOS through walls | Aimbot was locking through walls even with Require LOS enabled. Fixed by properly excluding all character BaseParts from the raycast |
| Multi-target LOS | Target cycling now also respects the Require LOS setting |
| Crosshair not rendering | Crosshair frame was too small and off-center. Rebuilt as a fullscreen frame with correct pixel math |
| GothamItalic error | Replaced invalid `Enum.Font.GothamItalic` reference with `SourceSansItalic` |
| First tab invisible | First tab content was being built before Roblox ran a layout pass. Fixed with `task.defer` |
| Enum button width | Enum buttons were 0px wide at build time due to `AbsoluteSize` being unresolved. Fixed to use static `CARD_W` |

---

## 👁️ ESP

Visual overlays for tracking players through walls and across the map.

| Feature | Details |
|---|---|
| Box ESP | Highlight mode — draws boxes around players |
| Name Tags | Displays player display names above characters |
| Health Tags | Shows current HP |
| Distance Tags | Shows the stud distance to each player |
| Tracers | Three anchor options: Bottom / Center / Mouse |
| Skeleton ESP | Full rig support for R15 and R6 characters |
| Offscreen Arrows | Arrows pointing toward out-of-viewport players |
| Chams / Wallhack Glow | Highlights players visible through solid geometry |
| Rainbow Color Mode | Cycles ESP colors through the full spectrum |
| Filter Modes | Enemy / Team / All / All (No Team Check) |
| ESP Override | Force-enable ESP on unsupported games at your own risk |

> ⚠️ **FPS Warning:** Disable ESP-related features if you are experiencing frame drops. We are investigating.

---

## 🎯 Aimbot

Assisted targeting with precision controls.

| Feature | Details |
|---|---|
| Smooth Aim Lock | Gradually moves aim toward the target (configurable smoothness) |
| FOV Circle | Visible circle showing the active aimbot radius (configurable opacity) |
| Hold / Toggle Modes | Hold RMB or toggle aim lock on/off |
| Target Prediction | Leads aim ahead of moving targets (configurable amount) |
| Line of Sight | Only locks targets with a clear LOS — properly excludes all character parts |
| Custom Lock Part | Head / HumanoidRootPart / UpperTorso / Torso |
| Max Distance | Configurable maximum lock range in studs |
| Multi-Target Cycle | Press `Tab` to cycle through valid targets in your FOV |
| Target Highlight | Visually marks the currently locked target |

---

## ✛ Crosshair

Custom crosshair rendered over the game viewport.

| Feature | Details |
|---|---|
| Styles | Cross, Dot, Circle, X-Shape, KV, Sniper |
| Color Picker | R/G/B sliders for crosshair and outline color |
| Rainbow Color | Auto-cycles color |
| Outline | Configurable outline thickness |
| Center Dot | Optional dot at the center |
| Dynamic Spread | Gap widens based on your movement velocity |
| Opacity | Control transparency |

---

## 🗺️ Radar

Live minimap displayed in the bottom-left corner of the screen.

| Feature | Details |
|---|---|
| Player Dots | Enemy dots red, team dots green, self dot white |
| Camera-Relative | Rotates with your camera — forward is always up |
| Configurable Range | Set how many studs the radar covers |
| Configurable Size | Resize the radar circle |
| Dot Scale | Adjust how spread out dots appear within the circle |

---

## 🔫 Gun Mods

Modifies weapon behavior. May cause lag on some games — WIP.

| Feature | Details |
|---|---|
| Fast Reload | Reduces reload time to near-instant |
| Fast Fire Rate | Increases rate of fire |
| Always Auto | Forces any weapon into fully automatic mode |
| No Spread | Removes bullet spread |
| No Recoil | Eliminates recoil |

---

## 🏃 Movement

| Feature | Details |
|---|---|
| Speed Boost | WalkSpeed / CFrame / Velocity methods |
| High Jump | Configurable jump power |
| Bunny Hop | Auto-jumps at optimal timing with configurable speed |
| Fly | Toggle flight with `F` — WASD + Space/Ctrl to move |
| Custom FOV | Adjust camera field of view |
| Auto TP Loop | Teleports continuously to the nearest enemy or a named player |
| Chat Spammer | Sends a custom message on a configurable delay |
| Anti-AFK | Prevents idle kick |

---

## 🔧 Misc

| Feature | Details |
|---|---|
| Chat Spy | Logs all chat messages to the F9 console |
| Anti-AFK | Prevents the game from kicking you for inactivity |
| Server Hop | Teleports to a new server instance |
| Rejoin | Rejoins the current game |
| FPS Counter | Displays your current FPS |
| Velocity Display | Shows character ground speed in studs/second |
| Fullbright | Maxes ambient lighting for clear visibility |
| No Fog | Removes all fog and atmosphere effects |

---

## 🎮 Game Support

Binxix Hub runs universally on all Roblox games. Extended mode is available on launch for:

| Game | Supported External Script |
|---|---|
| Murder Mystery 2 | **Vertex** — choose on inject |
| The Strongest Battlegrounds | **Phantasm** — choose on inject |
| BlockSpin | Movement mods auto-disabled (game restriction) |

All other games load Binxix Hub directly with full universal support.

---

## ⌨️ Keybinds

| Keybind | Action | Rebindable |
|---|---|---|
| `RightControl` | Toggle GUI open/closed | Yes — Settings tab |
| `T` | Toggle Auto TP Loop | Yes — General tab |
| `F` | Toggle Fly mode | No |
| `Tab` | Cycle aimbot target (Multi-Target mode) | No |
| `End` | Panic key — disable all features instantly | Yes — Settings tab |

---

## 🎨 Themes

Seven built-in color themes switchable from the Settings tab:

`Purple` · `Blue` · `Red` · `Green` · `Cyan` · `Midnight` · `Rose`

Each theme fully recolors the sidebar, cards, toggles, sliders, and accents.

---

## 💾 Config System

Settings can be saved to named profiles stored in `BinxixHubV7_Configs/` on your executor's workspace.

- **Save** — writes current settings to a `.json` profile
- **Load** — restores settings from a saved profile
- **Delete** — removes a profile
- **Quick Load** — scrollable list of saved profiles for one-click loading
- **Auto-load** — if a profile named `Default` exists it loads automatically on startup

---

## 🔄 Auto Updates

On every script execution the hub fetches the latest version number from GitHub. If a newer version is available a notification banner appears inside the GUI — no manual re-injection required. The GitHub Actions workflow also posts an update embed to the Discord server on every push.

---

## 💬 Discord

Join the community for support, updates, and announcements:

**[discord.gg/S4nPV2Rx7F](https://discord.gg/S4nPV2Rx7F)**

---

## ⚠️ Disclaimer

This script is provided for **educational and in-game research purposes**. Using scripts in Roblox may violate [Roblox's Terms of Service](https://en.help.roblox.com/hc/en-us/articles/115004647846). Use at your own risk. The author is not responsible for any account actions taken by Roblox as a result of using this software.
