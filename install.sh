#!/usr/bin/env bash
set -euo pipefail

echo "🧠 Installing PWA Launcher system..."

# Define paths
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.bin"
LAUNCHER_SCRIPT="$REPO_DIR/launch_pwa.sh"
DESKTOP_SOURCE="$REPO_DIR/../../dotfiles/.desktop"
DESKTOP_TARGET="$HOME/.local/share/applications"

# Step 1: Ensure ~/.bin exists
echo "📁 Ensuring $BIN_DIR exists..."
mkdir -p "$BIN_DIR"

# Step 2: Symlink launch_pwa.sh
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

# Step 3: Ensure ~/.bin is in PATH
if [[ ":$PATH:" != *":$HOME/.bin:"* ]]; then
  echo "⚠️  ~/.bin is not in your PATH. Add this to your shell config:"
  echo 'export PATH="$HOME/.bin:$PATH"'
else
  echo "✅ ~/.bin is already in your PATH."
fi

# Step 4: Run gen-launchers.sh
echo "🚀 Generating launchers from manifest.txt..."
bash "$REPO_DIR/gen-launchers.sh"

# Step 5: Symlink .desktop files
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

# Step 6: Checking Exec lines
echo "🔍 Checking .desktop Exec lines for unexpanded \$HOME..."
for file in "$DESKTOP_TARGET"/chrome-*.desktop; do
  if grep -q '\$HOME' "$file"; then
    echo "⚠️  ERROR: $file contains unexpanded \$HOME in Exec= line."
  fi
  if grep -q '~/' "$file"; then
    echo "⚠️  ERROR: $file contains tilde expansion in Exec= line."
  fi
done

# Step 7: Update desktop database
echo "📦 Updating desktop database..."
update-desktop-database "$DESKTOP_TARGET"

echo "🎉 Installation complete. All launchers are live."
