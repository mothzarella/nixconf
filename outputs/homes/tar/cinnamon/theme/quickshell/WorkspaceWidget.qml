import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root

    implicitWidth: workspaceRow.implicitWidth + 16
    implicitHeight: 28

    property ListModel workspaces: ListModel {}
    property real masterProgress: 0.
    property bool effectsActive: false

    Component.onCompleted: {
        niriCommandSocket.connected = true;
        niriEventStream.connected = true;

        startEventStream();
        updateWorkspaces();
    }

    function sendSocketCommand(sock, command) {
        sock.write(JSON.stringify(command) + "\n");
        sock.flush();
    }

    function startEventStream() {
        sendSocketCommand(niriEventStream, "EventStream");
    }

    function updateWorkspaces() {
        sendSocketCommand(niriCommandSocket, "Workspaces");
    }

    function switchToWorkspace(workspaceIdx) {
        try {
            Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", workspaceIdx.toString()]);
        } catch (e) {
            console.error("Failed to switch workspace:", e);
        }
    }

    function processWorkspaces(workspacesData) {
        workspaces.clear();

        const workspacesList = [];
        for (const ws of workspacesData) {
            workspacesList.push({
                "id": ws.id,
                "idx": ws.idx,
                "name": ws.name || "",
                "output": ws.output || "",
                "isFocused": ws.is_focused === true,
                "isActive": ws.is_active === true,
                "isOccupied": ws.active_window_id ? true : false
            });
        }

        workspacesList.sort((a, b) => {
            if (a.output !== b.output) {
                return a.output.localeCompare(b.output);
            }
            return a.idx - b.idx;
        });

        for (var i = 0; i < workspacesList.length; i++) {
            workspaces.append(workspacesList[i]);
        }

        for (var j = 0; j < workspaces.count; j++) {
            if (workspaces.get(j).isFocused) {
                triggerAnimation();
                break;
            }
        }
    }

    function triggerAnimation() {
        masterAnimation.restart();
    }

    Socket {
        id: niriCommandSocket
        path: Quickshell.env("NIRI_SOCKET")
        connected: false

        parser: SplitParser {
            onRead: function (line) {
                try {
                    const data = JSON.parse(line);

                    if (data && data.Ok) {
                        const res = data.Ok;
                        if (res.Workspaces) {
                            root.processWorkspaces(res.Workspaces);
                        }
                    } else {
                        console.error("Niri returned an error:", data.Err);
                    }
                } catch (e) {
                    console.error("Failed to parse data from socket:", e);
                }
            }
        }
    }

    Socket {
        id: niriEventStream
        path: Quickshell.env("NIRI_SOCKET")
        connected: false

        parser: SplitParser {
            onRead: function (data) {
                try {
                    const event = JSON.parse(data.trim());

                    // Aggiorna workspace quando c'è un cambiamento
                    if (event.WorkspacesChanged) {
                        root.processWorkspaces(event.WorkspacesChanged.workspaces);
                    } else if (event.WorkspaceActivated) {
                        root.updateWorkspaces();
                    }
                } catch (e) {
                    console.error("Error parsing event stream:", e);
                }
            }
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "transparent"

        Row {
            id: workspaceRow
            anchors.centerIn: parent
            spacing: 6

            Repeater {
                model: root.workspaces

                Rectangle {
                    id: pill
                    width: model.isFocused ? 48 : (model.isOccupied ? 32 : 24)
                    height: 24
                    radius: 12

                    color: {
                        if (model.isFocused)
                            return "#89b4fa";
                        if (model.isOccupied)
                            return "#585b70";
                        return "#45475a";
                    }

                    // Animazione cambio dimensione
                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: model.name || model.idx.toString()
                        color: "#cdd6f4"  // Testo chiaro
                        font.pixelSize: 12
                        font.bold: model.isFocused
                    }

                    // hover
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: {
                            pill.scale = 1.05;
                        }

                        onExited: {
                            pill.scale = 1.0;
                        }

                        onClicked: {
                            root.switchToWorkspace(model.idx);
                        }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: pill.width + 12 * root.masterProgress
                        height: pill.height + 12 * root.masterProgress
                        radius: width / 2
                        color: "transparent"
                        border.color: "#89b4fa"
                        border.width: Math.max(1, Math.round(2 + 4 * (1.0 - root.masterProgress)))
                        opacity: root.effectsActive && model.isFocused ? (1.0 - root.masterProgress) * 0.7 : 0
                        visible: root.effectsActive && model.isFocused
                    }
                }
            }
        }
    }

    SequentialAnimation {
        id: masterAnimation

        PropertyAction {
            target: root
            property: "effectsActive"
            value: true
        }

        NumberAnimation {
            target: root
            property: "masterProgress"
            from: 0.0
            to: 1.0
            duration: 400
            easing.type: Easing.OutQuint
        }

        PropertyAction {
            target: root
            property: "effectsActive"
            value: false
        }
    }
}
