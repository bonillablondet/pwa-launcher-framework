# 🧼 Polishing the PWA Launcher System – Dual-Forge Phase II

This document outlines two refinement tasks for the PWA launcher module in the Dual-Forge system. These are *not required for baseline functionality*, but serve to make the system more robust, minimalist, and distro-agnostic across non-GNOME environments.

---

## ✅ Purpose

- Remove GNOME-specific launcher fields when not needed
- Validate launcher behavior across other desktop environments (DEs), especially tiling WMs

These changes are intended as post-install refinements, to be applied *after confirming the current setup works on fresh Kubuntu installs*.

---

## 🧩 Step 1: Dynamically Strip GNOME-Specific Fields

### 🎯 Target Fields
```ini
X-GNOME-UsesNotifications=true
StartupNotify=true
```

Only include these if the user is running GNOME. Otherwise, exclude them from the generated `.desktop` entries.

### 🧠 Shell Logic for `gen-launchers.sh`
Add at the top:
```bash
DE=$(echo "${XDG_CURRENT_DESKTOP:-Unknown}" | tr '[:upper:]' '[:lower:]')
```

Wrap GNOME-only lines in conditionals:
```bash
[[ "$DE" == *gnome* ]] && echo "X-GNOME-UsesNotifications=true" >> "$filepath"
```

Or inline inside `cat` blocks with a conditional block:
```bash
{
  echo "[Desktop Entry]"
  echo "Name=$name"
  ...
  echo "StartupWMClass=crx_$app_id"
  [[ "$DE" == *gnome* ]] && echo "X-GNOME-UsesNotifications=true"
} > "$filepath"
```

---

## 🧪 Step 2: Cross-DE & WM Testing Plan

### 📋 KDE Plasma
- Launcher appears in Kickoff menu
- Pins correctly to taskbar
- Window grouping works via `.desktop` filename

### 📋 Hyprland / Tiling WMs
- App spawns without ghost icons or window separation
- Respects `StartupWMClass` for float rules (if any defined)
- Wayland scaling still applied via `launch_pwa.sh`

### 🔧 Generic Tests
```bash
echo $XDG_CURRENT_DESKTOP
gtk-launch chrome-<app-id>-Default
```
Test from terminal to verify desktop entry triggers correctly.

---

## 🏁 Implementation Timing
- These steps are **optional**, not part of baseline setup
- You should apply them only **after a successful clean test install on Kubuntu**
- Can be integrated into future versions of `gen-launchers.sh` or handled via environment-based config branching

---

## 📦 Optional Future Enhancements
- Per-DE profile or behavior layering (e.g., Wayland float rules per WM)
- Tiling WM–specific spacing fixes
- Dynamic fallback if `$XDG_CURRENT_DESKTOP` is missing

---
