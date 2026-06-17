import QtQuick
import Quickshell.Io

Text {
  id: cpu

  property color high: "#FF0000"
  property color med: "#FFFF00"
  property color low: "#00FF00"

  property int cpuProcent: 0

  topPadding: 1
  text: "CPU: " + cpuProcent + "%"

  color: cpuProcent < 40 ? low : cpuProcent < 70 ? med : high
  font { pixelSize: 13; family: "monospace"; }

  Process {
    id: cpuProc
    command: ["sh", "-c", "vmstat 1 2 | tail -n 1 | awk '{print 100 - $15}'"]
    Component.onCompleted: running = true
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var val = parseInt(data.trim())
        if (!isNaN(val)) { cpuProcent = val }
      }
    }
  }

  Timer {
    interval: 3000
    running: true
    repeat: true
    onTriggered: cpuProc.running = true
  }
}
