import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io

Item {
  id: root
  property int currentIndex: 0

  readonly property int debugCount: folderModel.count
  readonly property int debugStatus: folderModel.status

  readonly property string currentImage: {
    if (folderModel.count === 0) return "";
    let url = folderModel.get(root.currentIndex, "fileUrl");
    return url ? url.toString() : "";
  }

  FolderListModel {
    id: folderModel
    folder: "file:///etc/wallpapers"
    nameFilters: ["*.png"]
    sortField: FolderListModel.Name
  }

  IpcHandler {
    target: "wp"

    function walk(dir: int): void {
      if (folderModel.count === 0) return;
      let nextIdx = (root.currentIndex + dir) % folderModel.count;
      if (nextIdx < 0) nextIdx += folderModel.count;
      root.currentIndex = nextIdx;
    }
  }
}
