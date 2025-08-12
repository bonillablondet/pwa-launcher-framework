#!/bin/bash
# ========================================================
# PWA Launcher Framework – Install Script
# --------------------------------------------------------
# Installs PWA launcher .desktop files into the correct
# XDG directories so they appear in the application menu.
#
# Licensed under the MIT License – see LICENSE file.
# ========================================================

set -euo pipefail

echo "🧠 Installing PWA Launcher system..."

# --- PATHS ---
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.bin"
LAUNCHER_SCRIPT="$REPO_DIR/launch_pwa.sh"
DESKTOP_SOURCE="$REPO_DIR/../../dotfiles/.desktop"
DESKTOP_TARGET="$HOME/.local/share/applications"

# --- PRE-CHECKS ---
echo "🔍 Performing safety checks..."
# Warn if Chrome/Chromium not present
if ! command -v google-chrome-stable >/dev/null \
   && ! command -v google-chrome >/dev/null \
   && ! command -v chromium >/dev/null \
   && ! (command -v flatpak >/dev/null && flatpak info com.google.Chrome >/dev/null 2>&1); then
    echo "⚠️  Chrome/Chromium not found. Launchers may not work until installed."
fi

# Ensure desktop source exists
[ -d "$DESKTOP_SOURCE" ] || {
    echo "❌ Missing .desktop source directory: $DESKTOP_SOURCE"
    exit 1
}

# Confirm install
echo
echo "📂 This will install launchers from:"
echo "    $DESKTOP_SOURCE"
echo "➡️  To:"
echo "    $DESKTOP_TARGET"
read -rp "Proceed with installation? (y/N): " CONFIRM
[[ "$CONFIRM" =~ ^[Yy]$ ]] || { echo "⏭️  Installation cancelled."; exit 0; }

# --- STEP 1: Ensure ~/.bin exists ---
echo "📁 Ensuring $BIN_DIR exists..."
mkdir -p "$BIN_DIR"

# --- STEP 2: Symlink launch_pwa.sh ---
echo "🔗 Linking launch_pwa.sh to $BIN_DIR..."
if [[ -L "$BIN_DIR/launch_pwa.sh" || -f "$BIN_DIR/launch_pwa.sh" ]]; then
  read -p "⚠️  launch_pwa.sh already exists in $BIN_DIR. Overwrite? [y/N]: " choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    ln -sf "$LAUNCHER_SCRIPT" "$BIN_DIR/launch_pwa.sh"
    echo "✅ launch_pwa.sh symlinked."
  else
    echo "⏭️  Skipped symlink."
  fi
else
  ln -s "$LAUNCHER_SCRIPT" "$BIN_DIR/launch_pwa.sh"
  echo "✅ launch_pwa.sh symlinked."
fi

# --- STEP 3: Ensure ~/.bin is in PATH ---
if [[ ":$PATH:" != *":$HOME/.bin:"* ]]; then
  echo "⚠️  ~/.bin is not in your PATH. Add this to your shell config:"
  echo 'export PATH="$HOME/.bin:$PATH"'
else
  echo "✅ ~/.bin is already in your PATH."
fi

# --- STEP 4: Generate launchers ---
if [[ -x "$REPO_DIR/gen-launchers.sh" ]]; then
  echo "🚀 Generating launchers from manifest.txt..."
  bash "$REPO_DIR/gen-launchers.sh"
else
  echo "⚠️  gen-launchers.sh not found or not executable; skipping."
fi

# --- STEP 5: Symlink .desktop files ---
echo "🔗 Linking .desktop files to $DESKTOP_TARGET..."
mkdir -p "$DESKTOP_TARGET"
for file in "$DESKTOP_SOURCE"/*.desktop; do
  target="$DESKTOP_TARGET/$(basename "$file")"
  if [[ -e "$target" ]]; then
    read -p "⚠️  $(basename "$file") already exists. Overwrite? [y/N]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      ln -sf "$file" "$target"
      echo "✅ Overwritten: $(basename "$file")"
    else
      echo "⏭️  Skipped: $(basename "$file")"
    fi
  else
    ln -s "$file" "$target"
    echo "✅ Linked: $(basename "$file")"
  fi
done

# --- STEP 6: Exec line safety check ---
echo "🔍 Checking .desktop Exec lines for unexpanded \$HOME or tilde..."
for file in "$DESKTOP_TARGET"/chrome-*.desktop; do
  if grep -q '\$HOME' "$file"; then
    echo "⚠️  $file contains unexpanded \$HOME in Exec= line."
  fi
  if grep -q '~/' "$file"; then
    echo "⚠️  $file contains tilde (~) in Exec= line."
  fi
done

# --- STEP 7: Update desktop database ---
if command -v update-desktop-database >/dev/null; then
  echo "📦 Updating desktop database..."
  update-desktop-database "$DESKTOP_TARGET"
else
  echo "⚠️  update-desktop-database not found; skipping cache refresh."
fi

echo "🎉 Installation complete. All launchers are live."
