import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Repeater {
  model: 10

  property color colBgActive: "#285577"
  property color colBorderActive: "#4c7899"
  property color colFgActive: "#FFFFFF"
  property color colBgInactive: "#222222"
  property color colBorderInactive: "#333333"
  property color colFgInactive: "#888888"

  Rectangle {
    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

    visible: ws !== undefined

    Layout.preferredWidth: panel.implicitHeight - 4
    Layout.fillHeight: true

    color: isActive ? colBgActive : colBgInactive
    border.color: isActive ? colBorderActive : colBorderInactive

    Text {
      anchors.centerIn: parent
      text: `${index + 1}`
      color: isActive ? colFgActive : colFgInactive
      font { pixelSize: 12; family: "monospace"; bold: true }
    }
  }
}
