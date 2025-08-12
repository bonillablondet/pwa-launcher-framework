#!/usr/bin/env bash
# ========================================================
# PWA Launcher Framework – Launch Script
# --------------------------------------------------------
# Launches a Chrome/Chromium PWA with proper scaling.
# Licensed under the MIT License – see LICENSE file.
# ========================================================

set -euo pipefail

# --- Defaults ---
SCALE=""
PROFILE="Default"
APP_ID=""
NAME="PWA"

# --- Detect Chrome/Chromium binary ---
find_chrome() {
  for bin in google-chrome-stable google-chrome chromium flatpak; do
    if command -v "$bin" >/dev/null 2>&1; then
      if [[ "$bin" == "flatpak" ]] && flatpak info com.google.Chrome >/dev/null 2>&1; then
        echo "flatpak run com.google.Chrome"; return
      elif [[ "$bin" == "flatpak" ]] && flatpak info org.chromium.Chromium >/dev/null 2>&1; then
        echo "flatpak run org.chromium.Chromium"; return
      else
        echo "$bin"; return
      fi
    fi
  done
  echo ""; return
}

CHROME_BIN="$(find_chrome)"
if [[ -z "$CHROME_BIN" ]]; then
  echo "❌ Error: Chrome/Chromium not found." >&2
  exit 1
fi

# --- Parse arguments ---
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --scale) SCALE="$2"; shift ;;
    --profile) PROFILE="$2"; shift ;;
    --app-id) APP_ID="$2"; shift ;;
    --name) NAME="$2"; shift ;;
    *) echo "⚠️ Unknown parameter passed: $1" >&2; exit 1 ;;
  esac
  shift
done

# --- Apply default scale if not set ---
if [[ -z "$SCALE" ]]; then
  if [[ "$PROFILE" == "Profile 3" ]]; then
    SCALE="1.25"
  else
    SCALE="1.00"
  fi
fi

# --- Validate required parameters ---
if [[ -z "$APP_ID" ]]; then
  echo "❌ Error: --app-id is required" >&2
  exit 1
fi

# --- Launch hidden dummy window to lock DPI context ---
"$CHROME_BIN" \
  --enable-features=UseOzonePlatform \
  --ozone-platform=wayland \
  --force-device-scale-factor="$SCALE" \
  --profile-directory="$PROFILE" \
  --no-startup-window &

# --- Wait for Chrome to commit Wayland surface ---
sleep 1

# --- Launch the actual PWA ---
"$CHROME_BIN" \
  --enable-features=UseOzonePlatform \
  --ozone-platform=wayland \
  --force-device-scale-factor="$SCALE" \
  --profile-directory="$PROFILE" \
  --app-id="$APP_ID"
