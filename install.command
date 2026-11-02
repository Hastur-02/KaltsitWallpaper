#!/bin/zsh
set -euo pipefail

PACKAGE_DIR=${0:A:h}
APP_SOURCE="$PACKAGE_DIR/KaltsitWallpaper.app"
APP_DEST="$HOME/Applications/KaltsitWallpaper.app"
STAGING_APP="$HOME/Applications/.KaltsitWallpaper-install-$$.app"

[[ -d "$APP_SOURCE" ]] || { print -u2 '请先解压完整 ZIP，并将脚本与 KaltsitWallpaper.app 放在同一目录。'; exit 1; }
/usr/bin/codesign --verify --deep --strict "$APP_SOURCE"
mkdir -p "$HOME/Applications"
trap '[[ ! -e "$STAGING_APP" ]] || /bin/rm -rf "$STAGING_APP"' EXIT
/usr/bin/ditto "$APP_SOURCE" "$STAGING_APP"
/usr/bin/codesign --verify --deep --strict "$STAGING_APP"
/usr/bin/xattr -dr com.apple.quarantine "$STAGING_APP" 2>/dev/null || true

/bin/launchctl bootout "gui/$(id -u)/local.ark.kaltsit.wallpaper" 2>/dev/null || true
if [[ -e "$APP_DEST" ]]; then
    BACKUP_DIR="$HOME/Library/Application Support/KaltsitWallpaper/Backups"
    mkdir -p "$BACKUP_DIR"
    /bin/mv "$APP_DEST" "$BACKUP_DIR/KaltsitWallpaper-$(date +%Y%m%d-%H%M%S)-$$.app"
fi
/bin/mv "$STAGING_APP" "$APP_DEST"
/usr/bin/open "$APP_DEST"
print "已安装并启动：$APP_DEST"
