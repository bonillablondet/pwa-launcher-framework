#!/usr/bin/env bash
set -euo pipefail

echo "🔄 Restoring PWA launcher system from dotfiles..."

# Define paths
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.bin"
DESKTOP_SOURCE="$REPO_DIR/../../dotfiles/.desktop"
DESKTOP_TARGET="$HOME/.local/share/applications"
LAUNCHER_SCRIPT="$REPO_DIR/launch_pwa.sh"
LAUNCHER_LINK="$BIN_DIR/launch_pwa.sh"

# Step 1: Ensure ~/.bin exists
echo "📁 Ensuring $BIN_DIR exists..."
mkdir -p "$BIN_DIR"

# Step 2: Symlink launch_pwa.sh
echo "🔗 Linking launch_pwa.sh to $BIN_DIR..."
if [[ -L "$LAUNCHER_LINK" || -f "$LAUNCHER_LINK" ]]; then
  read -p "⚠️  launch_pwa.sh already exists in $BIN_DIR. Overwrite? [y/N]: " choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    ln -sf "$LAUNCHER_SCRIPT" "$LAUNCHER_LINK"
    echo "✅ launch_pwa.sh symlinked."
  else
    echo "⏭️  Skipped symlink."
  fi
else
  ln -s "$LAUNCHER_SCRIPT" "$LAUNCHER_LINK"
  echo "✅ launch_pwa.sh symlinked."
fi

# Step 3: Ensure launcher directory exists
echo "📁 Ensuring $DESKTOP_TARGET exists..."
mkdir -p "$DESKTOP_TARGET"

# Step 4: Symlink .desktop files from dotfiles
echo "🔗 Linking .desktop launchers from dotfiles..."
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

# Step 5: Checking Exec lines
echo "🔍 Checking .desktop Exec lines for unexpanded \$HOME or ~..."
for file in "$DESKTOP_TARGET"/chrome-*.desktop; do
  if grep -q '\$HOME' "$file"; then
    echo "⚠️  ERROR: $file contains unexpanded \$HOME in Exec= line."
  fi
  if grep -q '~/' "$file"; then
    echo "⚠️  ERROR: $file contains tilde expansion in Exec= line."
  fi
done

# Step 6: Update desktop database
echo "📦 Updating desktop database..."
update-desktop-database "$DESKTOP_TARGET"

echo "🎉 Restore complete. Launchers are now linked and ready."
