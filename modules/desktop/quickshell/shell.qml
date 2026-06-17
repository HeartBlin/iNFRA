//@ pragma UseQApplication

import Quickshell
import QtQuick

import "./Bar"
import "./Wallpaper"

ShellRoot {
  WallpaperManager { id: wallpaperManager }
  Bar { id: bar }

  Variants {
    model: Quickshell.screens
    Wallpaper { manager: wallpaperManager }
  }
}
