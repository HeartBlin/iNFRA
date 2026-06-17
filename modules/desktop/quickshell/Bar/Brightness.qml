import QtQuick
import Quickshell.Io

Text {
  id: brightText

  property int brightPercent: 0

  font { pixelSize: 13; family: "monospace"; }
  color: "#FFFFFF"
  topPadding: 1
  text: "LGT: " + brightPercent + "%"

  Process {
    id: readBright
    command: ["brightnessctl", "-m"]
    Component.onCompleted: running = true
    stdout: SplitParser {
      onRead: data => {
        if (!data) return;
        var parts = data.trim().split(',');
        if (parts.length >= 5) {
          brightPercent = parseInt(parts[3].replace('%', ''));
        }
      }
    }
  }

  Process { id: setBright }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: readBright.running = true
  }

  MouseArea {
    anchors.fill: parent

    onWheel: (wheel) => {
      if (wheel.angleDelta.y > 0) {
        setBright.command = ["brightnessctl", "set", "5%+"]
      } else {
        setBright.command = ["brightnessctl", "set", "5%-"]
      }

      setBright.running = true;
      readBright.running = true;
    }
  }
}
