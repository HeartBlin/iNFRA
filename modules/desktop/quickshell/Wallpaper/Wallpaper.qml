import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
  id: wallpaperWindow

  required property var modelData
  required property var manager
  screen: modelData

  color: "transparent"

  WlrLayershell.namespace: "wallpaper"
  WlrLayershell.layer: WlrLayer.Background

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  Image {
    anchors.fill: parent
    source: manager.currentImage
    fillMode: Image.PreserveAspectCrop
    mipmap: true
  }
}
