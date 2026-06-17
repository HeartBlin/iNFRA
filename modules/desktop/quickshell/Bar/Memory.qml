import Quickshell.Io
import QtQuick

Text {
  property color low: "#FF0000"
  property color med: "#FFFF00"
  property color high: "#00FF00"

  property bool showSwap: false

  property real memTotal: 0
  property real memUsed: 0
  property int memProcent: 0

  property real swapTotal: 0
  property real swapUsed: 0
  property int swapProcent: 0

  topPadding: 1
  text: showSwap ?
    "SWAP: " + swapUsed.toFixed(1) + "/" + swapTotal.toFixed(1) + " [GiB]"
    : "MEM: "  + memUsed.toFixed(1)  + "/" + memTotal.toFixed(1)  + " [GiB]"

  color: {
    var procent = showSwap ? swapProcent : memProcent
    return procent < 40 ? high : procent < 70 ? med : low
  }

  font { pixelSize: 13; family: "monospace"; }

  MouseArea {
    anchors.fill: parent
    onClicked: showSwap = !showSwap
  }

  Process {
    id: memProc
    command: [ "sh", "-c", "free | grep Mem"]
    Component.onCompleted: running = true
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var parts = data.trim().split(/\s+/)
        var total = parseInt(parts[1]) || 1
        var used = parseInt(parts[2]) || 0

        memUsed = used / 1024 / 1024
        memTotal = total / 1024 / 1024
        memProcent = Math.round(100 * used / total)
      }
    }
  }

  Process {
    id: swapProc
    command: ["sh", "-c", "free | grep Swap"]
    Component.onCompleted: running = true
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var parts = data.trim().split(/\s+/)
        var total = parseInt(parts[1]) || 1
        var used  = parseInt(parts[2]) || 0
        swapUsed    = used / 1024 / 1024
        swapTotal   = total / 1024 / 1024
        swapProcent = Math.round(100 * used / total)
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      memProc.running  = true
      swapProc.running = true
    }
  }
}
