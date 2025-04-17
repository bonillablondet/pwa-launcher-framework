# 🧠 Joel’s PWA Launcher Framework

Welcome to your **portable, profile-aware, scaling-corrected, Wayland-compatible PWA launcher system**.

This framework allows you to:
- Launch any Chrome PWA with proper scaling on multi-monitor setups
- Customize `.desktop` entries per-app with clean icons and dock pinning
- Apply special flags only when needed (e.g., for Profile 3)
- Backup and restore your setup *independently of Ubuntu or Chrome*

---


### 📦 Folder Structure

```bash
~/.config/pwa-launchers/
├── desktop-backups/        # Clean copies of all .desktop launcher files
├── launch_pwa.sh           # Core script to launch PWAs with scaling support
├── install.sh              # Fresh install script (sets up ~/.bin and launchers)
├── restore.sh              # Restores overwritten launcher files
└── README.md               # This file
```

Other folders involved (but not part of this repo):
- `~/.bin/launch_pwa.sh` – The script that safely launches each PWA
- `~/.local/share/applications/` – Where launchers must live to show up in docks/menus

---

## 🔁 Restore Workflow

If Chrome overwrites your launchers, restore them like this:

```bash
cp ~/.config/pwa-launchers/desktop-backups/*.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/*.desktop
update-desktop-database ~/.local/share/applications/
```

---

## 🛠 Launcher Naming Convention

Every `.desktop` file should:
- Start with: `chrome-<app-id>`
- End with: `-<Profile>.desktop`  
> Example: `chrome-cadlkienfkclaiaibeoongdcgmdikeeg-Default.desktop`

This ensures the dock matches the icon correctly.

---

## 🔧 Install on a New System

To set up this launcher system from scratch on any Linux distro:

```bash
git clone https://github.com/bonillablondet/pwa-launcher-framework ~/.config/pwa-launchers
cd ~/.config/pwa-launchers
./install.sh
```

> This will:
> - Copy your `launch_pwa.sh` into `~/.bin`
> - Make sure it’s executable
> - Restore all `.desktop` files to your system launcher directory
> - Prompt you if your PATH needs updating
> - Update your desktop environment so everything is recognized

Once complete, **all your PWAs will work** — with scaling, proper profiles, and dock integration intact.

---

## 🛠️ Restore Your Launcher System

To restore your PWA system (e.g., after reinstalling Chrome, switching distros, or setting up a new machine):

```bash
cd ~/.config/pwa-launchers/
./restore.sh
```

This script:
- Reinstalls your `.desktop` launchers
- Restores the core launcher script
- Updates the desktop database

That’s it. Everything just works. 💫

---

## 💻 Porting to Another System (e.g., Arch + Hyprland)

1. Copy this folder to the new system:
   ```bash
   rsync -av ~/.config/pwa-launchers/ <new-system>:~/.config/pwa-launchers/
   ```

2. Copy or recreate `launch_pwa.sh` and make it executable:
   ```bash
   mkdir -p ~/.bin
   cp launch_pwa.sh ~/.bin/
   chmod +x ~/.bin/launch_pwa.sh
   ```

3. Ensure `~/.bin` is in your PATH (usually in `.bashrc` or `.zshrc`):
   ```bash
   export PATH="$HOME/.bin:$PATH"
   ```

4. Restore your `.desktop` files:
   ```bash
   cp ~/.config/pwa-launchers/desktop-backups/*.desktop ~/.local/share/applications/
   chmod +x ~/.local/share/applications/*.desktop
   update-desktop-database ~/.local/share/applications/
   ```

5. Done! Your PWAs should now:
   - Respect scaling
   - Launch in the right profile
   - Group in the dock properly

---

## 🔐 Notes

- All launchers are profile-aware via `--profile-directory`
- Profile 3 auto-applies Wayland scaling fix via the launcher script
- You can still use the Chrome UI to install/uninstall PWAs, just make sure to **restore your backup launcher** if it gets replaced

---

🦥 Built with love, sweat, and so many `gtk-launch` tests.

