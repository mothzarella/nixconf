import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 36
    color: "transparent"

    WlrLayershell.namespace: "niri-workspace-bar"
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: height

    RowLayout {
        anchors. fill: parent
        anchors.margins: 6
        spacing: 8

        WorkspaceWidget {
            id: workspaceWidget
            Layout.alignment: Qt.AlignLeft
        }

        Item { Layout.fillWidth: true }
    }
}
