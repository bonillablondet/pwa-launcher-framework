# 🧠 Joel’s PWA Launcher Framework

Welcome to your **portable, profile-aware, scaling-corrected, Wayland-compatible PWA launcher system**.

This framework allows you to:
- Launch any Chrome PWA with proper scaling on multi-monitor setups
- Customize `.desktop` entries per-app with clean icons and dock pinning
- Apply special flags only when needed (e.g., for Profile 3)
- Restore your setup from version-controlled dotfiles, fully independent of any one distro

---

### 📦 Folder Structure

```bash
Dual-Forge/
├── common/
│   └── pwa-launchers/
│       ├── install.sh
│       ├── restore.sh
│       ├── gen-launchers.sh
│       ├── launch_pwa.sh
│       ├── manifest.txt
│       └── README.md
├── dotfiles/
│   └── .desktop/
│       ├── chrome-*.desktop
```

- `manifest.txt` is the declarative source of truth
- `gen-launchers.sh` builds `.desktop` files from it
- `.desktop/` is the canonical directory for all launcher entries

---

## 🗺️ Clarified Command Flow

   - Use `install.sh` for **first setup**
   - Use `restore.sh` **after wipe or corruption**
   - Use `gen-launchers.sh` only **when updating** from `manifest.txt`

---

## 🛠 Install Workflow (First Time Setup)

```bash
cd common/pwa-launchers
./install.sh
```

This will:
- Symlink `launch_pwa.sh` into `~/.bin`
- Generate `.desktop` launchers using `gen-launchers.sh`
- Symlink `.desktop` files into `~/.local/share/applications/`
- Update the system desktop database

Once complete, all your PWAs will work — with proper scaling, correct dock pinning, and full portability.

---

## 🔁 Restore Workflow (After Reset or Wipe)

To restore your PWA launcher system after reinstalling Chrome, changing distros, or resetting:

```bash
cd common/pwa-launchers
./restore.sh
```

This will:
- Symlink `launch_pwa.sh` into `~/.bin`
- Symlink `.desktop` files from `dotfiles/.desktop/` to your applications folder
- Update the desktop database

This is the fast, Git-backed restoration method.

---

## 🔧 Regenerate Launchers (Optional)

Only run this if you’ve updated `manifest.txt` and want to rebuild the `.desktop` files:

```bash
cd common/pwa-launchers
./gen-launchers.sh
```

This will:
- Read from `manifest.txt`
- Create new `.desktop` files
- Overwrite any previous versions in `.desktop/`

---

## 🛠 Launcher Naming Convention

Every `.desktop` file should:
- Start with: `chrome-<app-id>`
- End with: `-<Profile>.desktop`

> Example: `chrome-cadlkienfkclaiaibeoongdcgmdikeeg-Default.desktop`

This ensures Chrome knows how to group and pin each PWA.

---

## 💻 Porting to Another System (e.g., common, Hyprland)

1. Copy the full Dual-Forge project (especially `dotfiles/` and `common/`)
2. Run `install.sh` from inside `common/pwa-launchers/`
3. Done — all launchers will regenerate from `dotfiles/.desktop/` and pin properly

---

## 🔐 Notes

- All launchers use `--profile-directory` for precise profile targeting
- The system works on any desktop environment (GNOME, KDE, Hyprland, Sway)
- You can still install PWAs from Chrome UI, but restoring the `.desktop` entry from dotfiles is **required** to preserve pinning

---

🦥 Built with love, sweat, and so many `gtk-launch` tests.
