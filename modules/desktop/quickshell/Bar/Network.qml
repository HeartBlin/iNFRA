import QtQuick
import Quickshell.Io

Text {
  id: network

  property color netColor: "#FFFFFF"

  property bool showIp: false
  property string ssid: "..."
  property string ipAddr: "..."

  topPadding: 1
  color: netColor
  font { pixelSize: 13; family: "monospace"; }
  text: showIp ? "IP: " + ipAddr : "NET: " + ssid

  MouseArea {
    anchors.fill: parent
    onClicked: showIp = !showIp
  }

  Process {
    id: ssidProc
    command: ["sh", "-c", "nmcli -t -f NAME connection show --active | head -n 1"]
    Component.onCompleted: running = true
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        ssid = data.trim() || "Disconnected"
      }
    }
  }

  Process {
    id: ipProc
    command: ["sh", "-c", "ip -4 -br addr show | awk '$1 != \"lo\" {print $3}' | cut -d/ -f1 | head -n 1"]
    Component.onCompleted: running = true
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        ipAddr = data.trim() || "No IP"
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: {
      ssidProc.running = true
      ipProc.running = true
    }
  }
}
