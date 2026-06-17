import Quickshell
import QtQuick
import QtQuick.Layouts

import "./Audio.qml"
import "./Battery.qml"
import "./Brightness.qml"
import "./Cpu.qml"
import "./Memory.qml"
import "./Mic.qml"
import "./Network.qml"
import "./Separator.qml"
import "./Time.qml"
import "./Tray.qml"
import "./Workspaces.qml"

PanelWindow {
  id: panel

  property color bg: "#000000"

  anchors {
    top: false
    right: true
    bottom: true
    left: true
  }

  implicitHeight: 24
  color: bg;

  RowLayout {
    anchors.fill: parent
    anchors.margins: 2
    spacing: 2

    Workspaces { }
    Item { Layout.fillWidth: true }
    Cpu { }
    Separator { }
    Memory { }
    Separator { }
    Network { }
    Separator { }
    Brightness { }
    Separator { }
    Audio { }
    Separator { }
    Mic { }
    Separator { visible: battery.visible }
    Battery { id: battery }
    Separator { }
    Time { }
    Separator { visible: tray.itemCount > 0 }
    Tray { id: tray }
  }
}
