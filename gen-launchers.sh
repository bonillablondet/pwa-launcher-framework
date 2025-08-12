#!/usr/bin/env bash
# ========================================================
# PWA Launcher Framework – Generate Launchers
# --------------------------------------------------------
# Reads manifest.txt and generates .desktop launcher files
# into the user's XDG applications directory.
#
# Licensed under the MIT License – see LICENSE file.
# ========================================================

set -euo pipefail

# --- CONFIG ---
MANIFEST="./manifest.txt"
LAUNCHER_DIR="$HOME/.local/share/applications"
SCRIPT_NAME="launch_pwa.sh"
SCRIPT_PATH="$HOME/.bin/$SCRIPT_NAME"

echo "🚀 Generating PWA launchers from manifest: $MANIFEST"

# --- PRE-CHECKS ---
if [[ ! -f "$MANIFEST" ]]; then
  echo "❌ No manifest.txt found."
  echo "Please create one based on manifest.template.txt."
  exit 1
fi


if [[ ! -x "$SCRIPT_PATH" ]]; then
  echo "⚠️  Warning: $SCRIPT_PATH not found or not executable."
  echo "    Launchers will be created but may not work until this script is installed."
fi

mkdir -p "$LAUNCHER_DIR"

# --- PROCESS MANIFEST ---
while IFS=',' read -r name app_id profile icon; do
  # Skip header or empty lines
  [[ "$name" == "name" || -z "$name" ]] && continue

  # Sanity check required fields
  if [[ -z "$app_id" || -z "$profile" ]]; then
    echo "⚠️  Skipping invalid line (missing app_id or profile): $name"
    continue
  fi

  # Create a safe filename
  safe_profile="${profile// /_}" # replace spaces with underscores
  filename="chrome-${app_id}-${safe_profile}.desktop"
  filepath="${LAUNCHER_DIR}/${filename}"

  # Write desktop entry
  cat > "$filepath" <<EOF
[Desktop Entry]
Name=${name}
Exec=${SCRIPT_PATH} --name "${name}" --app-id ${app_id} --profile "${profile}"
Icon=${icon:-web-browser}
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

# --- REFRESH DESKTOP DATABASE ---
if command -v update-desktop-database >/dev/null; then
  echo "📦 Updating desktop database..."
  update-desktop-database "$LAUNCHER_DIR"
else
  echo "⚠️  update-desktop-database not found; skipping cache refresh."
fi

echo "🎉 All launchers generated successfully."
