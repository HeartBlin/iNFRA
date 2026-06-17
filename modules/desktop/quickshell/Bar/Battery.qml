import QtQuick
import Quickshell.Services.UPower

Text {
  id: battery

  property color colHigh: "#FFFFFF"
  property color colLow: "#FF0000"

  property var batDevice: UPower.displayDevice
  property bool isCharging: !UPower.onBattery
  property int batPercent: batDevice ? Math.round(batDevice.percentage * 100) : 0

  visible: batDevice !== null && batDevice.ready

  topPadding: 1
  font { pixelSize: 13; family: "monospace"; }
  color: {
    if (isCharging) return colHigh
    return batPercent < 20 ? colLow : colHigh
  }

  function formatTime(seconds) {
    if (seconds === 0) return "Calc..."
    var h = Math.floor(seconds / 3600)
    var m = Math.floor((seconds % 3600) / 60)
    return h + "h " + m + "m"
  }

  text: {
    if (!batDevice) return ""
    var tell = (isCharging ? "CRG" : "DIS")
      return "BAT: " + batPercent + "% " + tell
  }
}
