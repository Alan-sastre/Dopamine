import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../Config"

// Barra principal — anclada en la parte superior de cada monitor
PanelWindow {
    id: bar

    // Tamaño y anclaje
    height: Colors.barHeight
    anchors {
        top:   true
        left:  true
        right: true
    }

    // Excluir el área de la barra de las ventanas de Wayland
    exclusiveZone: Colors.barHeight

    // Fondo de la barra
    color: "transparent"

    Rectangle {
        id: background
        anchors.fill: parent
        color: Colors.bgTransparent

        // Borde inferior sutil
        Rectangle {
            anchors {
                left:   parent.left
                right:  parent.right
                bottom: parent.bottom
            }
            height: 1
            color:  Colors.border
            opacity: 0.4
        }
    }

    // ── Layout principal ─────────────────────────────────────────
    RowLayout {
        anchors {
            fill:        parent
            leftMargin:  Colors.spacingMd
            rightMargin: Colors.spacingMd
        }
        spacing: 0

        // Izquierda — workspaces
        LeftSection {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.fillWidth: false
        }

        // Centro — reloj (se estira para ocupar el espacio libre)
        Item {
            Layout.fillWidth: true
            height: Colors.barHeight

            CenterSection {
                anchors.centerIn: parent
            }
        }

        // Derecha — volumen, hora
        RightSection {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.fillWidth: false
        }
    }
}
