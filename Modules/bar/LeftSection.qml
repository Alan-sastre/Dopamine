import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../../Config"
import "../../Services" as Svc

// Sección izquierda — botones de workspaces
Item {
    id: root

    implicitWidth:  workspacesRow.implicitWidth + Colors.spacingMd * 2
    implicitHeight: Colors.barHeight

    // Cuántos workspaces mostrar como mínimo (aunque estén vacíos)
    readonly property int minWorkspaces: 5

    // ── Workspaces ───────────────────────────────────────────────
    Row {
        id: workspacesRow
        anchors.centerIn: parent
        spacing: Colors.spacingSm

        Repeater {
            // Mostrar al menos minWorkspaces, o más si hay ventanas abiertas
            model: {
                let maxId = root.minWorkspaces
                for (const ws of Hyprland.workspaces) {
                    if (ws.id > maxId) maxId = ws.id
                }
                return maxId
            }

            delegate: WorkspaceButton {
                wsId:     modelData + 1
                isActive: Hyprland.focusedMonitor?.activeWorkspace?.id === (modelData + 1)
                hasWindows: {
                    for (const ws of Hyprland.workspaces) {
                        if (ws.id === modelData + 1) return ws.windowCount > 0
                    }
                    return false
                }
            }
        }
    }

    // ── Botón de workspace individual ───────────────────────────
    component WorkspaceButton: Rectangle {
        id: wsBtn

        property int  wsId:       1
        property bool isActive:   false
        property bool hasWindows: false

        width:  isActive ? 28 : 20
        height: 20
        radius: Colors.radiusSm

        color: isActive
            ? Colors.accent
            : hoverHandler.hovered
                ? Colors.overlay
                : "transparent"

        Behavior on color { ColorAnimation { duration: Colors.animFast } }
        Behavior on width  { NumberAnimation { duration: Colors.animFast; easing.type: Easing.OutCubic } }

        // Número o punto
        Text {
            anchors.centerIn: parent
            text:  wsBtn.isActive ? wsBtn.wsId.toString() : (wsBtn.hasWindows ? "•" : wsBtn.wsId.toString())
            font.family:    Colors.fontFamily
            font.pixelSize: Colors.fontSizeSm
            font.bold:      wsBtn.isActive
            color: wsBtn.isActive
                ? Colors.bg
                : wsBtn.hasWindows
                    ? Colors.text
                    : Colors.textMuted
        }

        // Indicador inferior para workspace con ventanas
        Rectangle {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 2
            }
            width:  wsBtn.hasWindows && !wsBtn.isActive ? 4 : 0
            height: 2
            radius: 1
            color:  Colors.accentAlt
            visible: wsBtn.hasWindows && !wsBtn.isActive

            Behavior on width { NumberAnimation { duration: Colors.animFast } }
        }

        HoverHandler { id: hoverHandler }

        TapHandler {
            onTapped: Hyprland.dispatch("workspace " + wsBtn.wsId)
        }

        // Scroll para cambiar workspace
        WheelHandler {
            onWheel: event => {
                if (event.angleDelta.y > 0)
                    Hyprland.dispatch("workspace r-1")
                else
                    Hyprland.dispatch("workspace r+1")
            }
        }
    }
}
