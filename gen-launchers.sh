#!/usr/bin/env bash
set -euo pipefail

MANIFEST="./manifest.txt"
LAUNCHER_DIR="$HOME/.local/share/applications"
SCRIPT_NAME="launch_pwa.sh"
SCRIPT_PATH="$HOME/.bin/$SCRIPT_NAME"

mkdir -p "$LAUNCHER_DIR"

while IFS=',' read -r name app_id profile icon; do
  # Skip header or empty lines
  [[ "$name" == "name" || -z "$name" ]] && continue

  # Create a safe filename
  filename="chrome-${app_id}-${profile}.desktop"
  filepath="${LAUNCHER_DIR}/${filename}"

  cat > "$filepath" <<EOF
[Desktop Entry]
Name=${name}
Exec=${SCRIPT_PATH} --name "${name}" --app-id ${app_id} --profile ${profile}
Icon=${icon}
Terminal=false
Type=Application
Categories=Network;WebBrowser;
StartupWMClass=crx_${app_id}
StartupNotify=true
X-GNOME-UsesNotifications=true
EOF

  chmod +x "$filepath"
  echo "✅ Created launcher: $filepath"
done < "$MANIFEST"

update-desktop-database "$LAUNCHER_DIR"
