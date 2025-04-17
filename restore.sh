#!/bin/bash
# restore.sh script for the Chrome PWA launchers

echo "🚀 Restoring PWA launcher system..."

# Step 1: Copy .desktop files into the applications folder
cp ./desktop-backups/*.desktop ~/.local/share/applications/

# Step 2: Make sure they’re executable
chmod +x ~/.local/share/applications/*.desktop

# Step 3: Update the desktop database so your DE sees them
update-desktop-database ~/.local/share/applications/

# Step 4: Confirm script exists in expected place
if [[ ! -f ~/.bin/launch_pwa.sh ]]; then
  echo "⚠️  launch_pwa.sh not found in ~/.bin. Copying it now..."
  mkdir -p ~/.bin
  cp ./launch_pwa.sh ~/.bin/
  chmod +x ~/.bin/launch_pwa.sh
else
  echo "✅ launch_pwa.sh already exists in ~/.bin"
fi

echo "✅ All done! PWAs are live and launch-ready."
