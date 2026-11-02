#!/bin/zsh
set -euo pipefail

APP_DEST="$HOME/Applications/KaltsitWallpaper.app"
if [[ -e "$APP_DEST" ]]; then
    APP_ID=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$APP_DEST/Contents/Info.plist")
    [[ "$APP_ID" == local.ark.kaltsit.wallpaper ]] || { print -u2 '安装位置不是凯尔希壁纸，已停止卸载。'; exit 1; }
fi
/bin/launchctl bootout "gui/$(id -u)/local.ark.kaltsit.wallpaper" 2>/dev/null || true
if [[ -x "$APP_DEST/Contents/MacOS/KaltsitWallpaper" ]]; then
    "$APP_DEST/Contents/MacOS/KaltsitWallpaper" --uninstall
fi
/bin/rm -f "$HOME/Library/LaunchAgents/local.ark.kaltsit.wallpaper.plist"
/bin/rm -rf "$APP_DEST" "$HOME/Library/Screen Savers/Kaltsit.saver"
print '已卸载凯尔希壁纸、屏保与登录项。已有 App 备份保留在应用支持目录。'
