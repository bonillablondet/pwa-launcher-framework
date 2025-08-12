# 🧾 CHANGELOG

All notable changes to this project will be documented here.  
This project follows **semantic versioning**: `v<MAJOR>.<MINOR>.<PATCH>`

---

## [v1.1.0] – 2025-08-12
### Added
- 🌍 **First public release** of PWA Launcher Framework
- 📄 Introduced `manifest.template.txt` for safe public sharing
- 📘 Major `README.md` overhaul with:
  - Detailed manifest system documentation
  - Privacy safeguards and `.gitignore` for `manifest.txt`
  - Expanded Quickstart and command flow sections
- 🛠 Hardened all scripts (`install.sh`, `restore.sh`, `gen-launchers.sh`, `launch_pwa.sh`):
  - Added input validation, safer path handling, and clearer user prompts
  - Improved cross-platform Chrome/Chromium detection
  - Added checks for unexpanded `$HOME` or `~` in `.desktop` Exec lines
- 🧹 Removed all private app data from repository

### Changed
- 📦 Folder structure clarified in `README.md` for public users
- 🔄 Refined `gen-launchers.sh` to warn if `manifest.txt` is missing and point users to template

### Security
- 🔒 Verified that no credentials, tokens, or private app IDs are included in the public repo

---

## [v1.0.2] – 2025-04-17
### Added
- 🧠 **GitHub.com PWA**: Full launcher integration, scaling-aware, dock-matching
- 🔧 Launcher `.desktop` entry backed up and versioned

### Fixed
- 🚀 Scaling issues resolved for the GitHub PWA via launcher script
- 🖼️ Dock icon duplication handled with correct `StartupWMClass` format

---

## [v1.0.1] – 2025-04-17
### Added
- 🛠 **`install.sh`** script for clean installation on new systems
- 📘 Updated `README.md` with step-by-step installation instructions
- 🧠 Guidance for PATH setup and portability

---

## [v1.0.0] – 2025-04-17
### Added
- 🎉 Initial version of the PWA launcher framework
- ✅ `launch_pwa.sh`: Profile-aware, scaling-corrected launcher script
- 🔁 `restore.sh`: Auto-restores launcher icons and script if overwritten
- 🗂️ `.desktop` backups for all installed PWAs

---

