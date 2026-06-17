import QtQuick

Text {
  id: clock

  property color clockColor: "#FFFFFF"
  property string formatTime: "HH:mm:ss"
  property string formatDate: "yyyy-MM-dd"
  property date currentTime: new Date()

  topPadding: 1

  text: Qt.formatDateTime(currentTime, formatDate + " " + formatTime)
  color: clockColor
  font { pixelSize: 13; family: "monospace" }
  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: clock.currentTime = new Date()
  }
}
