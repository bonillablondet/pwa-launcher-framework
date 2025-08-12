# 🧠 Chrome PWA Launcher Framework

Welcome to a **portable, profile-aware, scaling-corrected, Wayland-compatible PWA launcher system**.

PWA Launcher Framework is a lightweight, cross-platform toolkit for creating, managing, and restoring Progressive Web App (PWA) launchers with native desktop integration. It generates .desktop entries and icons for PWAs installed through Chromium-based browsers, with profile-aware configuration, multi-monitor scaling fixes, and Wayland/X11 compatibility. Designed for speed and portability, it can be deployed in seconds and easily adapted to personal or enterprise workflows.

This framework allows you to:
- Launch any Chrome PWA with proper scaling on multi-monitor setups
- Customize `.desktop` entries per-app with clean icons and dock pinning
- Apply special flags only when needed (e.g., for Profile 3)
- Restore your setup from version-controlled dotfiles, fully independent of any one distro

---

## 📄 Manifest System

PWA Launcher Framework uses a **manifest file** to define your PWAs.
For privacy and portability, the actual `manifest.txt` file is **ignored** in `.gitignore` — it contains your personal app list.

Instead, we provide a **`manifest.template.txt`** that you can copy and edit:

```bash
cp manifest.template.txt manifest.txt
```

Each row in the manifest represents one PWA, with the format:

```
name,app_id,profile,icon
```

Example:

```
name,app_id,profile,icon
Google Chat,aeblfdkhhhdcdjpifhhbdiojplfjncoa,Default,google-chat
Notion,efaidnbmnnnibpcajpcglclefindmkaj,Profile 2,~/.local/share/icons/notion.png
```

* **name** → Display name in your app menu
* **app\_id** → Chrome’s application ID for the PWA
* **profile** → Chrome profile name (e.g., `Default`, `Profile 2`)
* **icon** → Either an icon name in your system theme or an absolute/relative path

The manifest is your **source of truth**.
When you run `gen-launchers.sh`, launchers are generated from it.

---

## 📦 Folder Structure

```bash
pwa-launchers-framework/
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

## Quickstart
```bash
# 1) put repo anywhere (e.g., ~/Projects/pwa-launchers)
# 2) generate + link launchers
cd common/pwa-launchers
./install.sh            # first-time setup
````
> ⚠️ `manifest.txt` must exist before running `install.sh` — copy and edit `manifest.template.txt` first.

---

## 🗺️ Clarified Command Flow

   - Use `install.sh` for **first setup**
   - Use `restore.sh` **after wipe or corruption**
   - Use `gen-launchers.sh` only **when updating** from `manifest.txt`

---

## 🛠 Install Workflow (First Time Setup)

```bash
cd /pwa-launchers
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
cd /pwa-launchers
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
cd /pwa-launchers
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

1. Copy the full pwa-launchers project (especially `dotfiles/` and `common/`)
2. Run `install.sh` from inside `/pwa-launchers/`
3. Done — all launchers will regenerate from `dotfiles/.desktop/` and pin properly

---

## 🔐 Notes


- `launch_pwa.sh` auto-detects Chrome/Chromium (deb/rpm/Arch/Flatpak).
- All launchers use `--profile-directory` for precise profile targeting
- The system works on any desktop environment (GNOME, KDE, Hyprland, Sway)
- A default scale of **1.25** is applied for **Profile 3**, otherwise **1.00**. Override with `--scale`.
- You can still install PWAs from Chrome UI, but restoring the `.desktop` entry from dotfiles is **required** to preserve pinning
- `.desktop` files live in `~/.local/share/applications` and can be pinned to your dock/panel.

---

## 📜 License

This project is licensed under the **MIT License** — see [LICENSE](LICENSE) for details.

---

🦥 Built with love, sweat, and so many `gtk-launch` tests.
