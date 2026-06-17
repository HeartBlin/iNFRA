import QtQuick
import Quickshell.Services.Pipewire

Text {
  property var sink: Pipewire.defaultAudioSink
  PwObjectTracker { objects: [sink] }

  property color colActive: "#FFFFFF"
  property color colMuted: "#FF0000"

  property bool isMuted: sink && sink.audio ? sink.audio.muted : false
  property int volPercent: sink && sink.audio ? Math.round(sink.audio.volume * 100) : 0

  color: isMuted ? colMuted : colActive
  font { pixelSize: 13; family: "monospace"; }
  topPadding: 1

  text: {
    if (!sink || !sink.audio) return "VOL: NaN%"
    if (isMuted) return "VOL: MUTE"
    return "VOL: " + volPercent + "%"
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      if (sink && sink.audio) {
        sink.audio.muted = !sink.audio.muted
      }
    }

    onWheel: (wheel) => {
      if (!sink || !sink.audio) return;

      var step = 0.05;
      var newVol = sink.audio.volume;

      if (wheel.angleDelta.y > 0) {
        newVol = Math.min(1.0, newVol + step);
      } else {
        newVol = Math.max(0.0, newVol - step);
      }

      sink.audio.volume = newVol;
    }
  }
}
