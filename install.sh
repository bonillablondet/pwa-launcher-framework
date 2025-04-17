#!/bin/bash
# install.sh – One-time setup script for Chrome PWA Launcher Framework

echo "🧠 Installing PWA Launcher system..."

# Step 1: Ensure ~/.bin exists
echo "📁 Ensuring ~/.bin exists..."
mkdir -p ~/.bin

# Step 2: Copy launch_pwa.sh into ~/.bin
echo "📦 Copying launch_pwa.sh to ~/.bin/"
cp launch_pwa.sh ~/.bin/
chmod +x ~/.bin/launch_pwa.sh

# Step 3: Ensure ~/.bin is in PATH
if [[ ":$PATH:" != *":$HOME/.bin:"* ]]; then
  echo "⚠️  ~/.bin is not in your PATH. Add this to your ~/.bashrc or ~/.zshrc:"
  echo 'export PATH="$HOME/.bin:$PATH"'
else
  echo "✅ ~/.bin is already in your PATH."
fi

# Step 4: Restore launchers
echo "🔁 Restoring .desktop files to ~/.local/share/applications/"
mkdir -p ~/.local/share/applications/
cp ./desktop-backups/*.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/*.desktop
update-desktop-database ~/.local/share/applications/

echo "🎉 Install complete! Your PWAs are ready to launch."
