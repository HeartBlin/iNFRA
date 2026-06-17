import QtQuick
import Quickshell.Services.Pipewire

Text {
  property var source: Pipewire.defaultAudioSource
  PwObjectTracker { objects: [source] }

  property color colNormal: "#FF0000"
  property color colActive: "#FFFFFF"

  property bool isMuted: source && source.audio ? source.audio.muted : false
  property int volPercent: source && source.audio ? Math.round(source.audio.volume * 100) : 0

  color: isMuted ? colNormal : colActive
  font { pixelSize: 13; family: "monospace"; }
  topPadding: 1

  text: {
    if (!source || !source.audio) return "MIC: NaN%"
    if (isMuted) return "MIC: MUTE"
    return "MIC: " + volPercent + "%"
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      if (source && source.audio) {
        source.audio.muted = !source.audio.muted
      }
    }

    onWheel: (wheel) => {
      if (!source || !source.audio) return;
      var step = 0.05;
      var newVol = source.audio.volume;

      if (wheel.angleDelta.y > 0) {
        newVol = Math.min(1.0, newVol + step);
      } else {
        newVol = Math.max(0.0, newVol - step);
      }

      source.audio.volume = newVol;
    }
  }
}
