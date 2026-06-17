import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

RowLayout {
  readonly property int itemCount: trayRepeater.count

  Layout.fillHeight: true
  implicitWidth: 0
  spacing: 4

  visible: itemCount > 0

  Repeater {
    id: trayRepeater

    model: SystemTray.items

    Image {
      id: trayIcon
      source: modelData.icon

      Layout.alignment: Qt.AlignVCenter
      Layout.preferredWidth: 16
      Layout.preferredHeight: 16
      Layout.topMargin: 1
      fillMode: Image.PreserveAspectFit

      QsMenuAnchor {
        id: menuAnchor
        menu: modelData.menu
        anchor.item: trayIcon
        anchor.edges: Edges.Top | Edges.Left
      }

      MouseArea {
        id: trayMouse
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onClicked: (mouse) => {
          if (mouse.button === Qt.LeftButton) {
            modelData.activate()
          } else if (mouse.button === Qt.MiddleButton) {
            modelData.secondaryActivate()
          } else if (mouse.button === Qt.RightButton) {
            menuAnchor.open()
          }
        }
      }
    }
  }
}
