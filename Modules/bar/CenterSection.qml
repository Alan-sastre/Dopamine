import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../Config"
import "../../Services" as Svc

// Sección central — reloj + fecha con tooltip al hacer hover
Item {
    id: root

    implicitWidth:  clockRow.implicitWidth + Colors.spacingLg * 2
    implicitHeight: Colors.barHeight

    property var clock: Svc.Clock

    // ── Contenido ────────────────────────────────────────────────
    Row {
        id: clockRow
        anchors.centerIn: parent
        spacing: Colors.spacingSm

        // Hora principal
        Text {
            id: timeText
            anchors.verticalCenter: parent.verticalCenter
            text:           clock.timeShort
            font.family:    Colors.fontFamily
            font.pixelSize: Colors.fontSizeLg
            font.bold:      true
            color:          hoverHandler.hovered ? Colors.accent : Colors.text

            Behavior on color { ColorAnimation { duration: Colors.animFast } }
        }

        // Separador
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width:   1
            height:  14
            color:   Colors.border
            opacity: hoverHandler.hovered ? 0 : 0.6

            Behavior on opacity { NumberAnimation { duration: Colors.animFast } }
        }

        // Fecha corta (se oculta al hacer hover para mostrar fecha larga)
        Text {
            id: dateText
            anchors.verticalCenter: parent.verticalCenter
            text:           hoverHandler.hovered ? clock.dateFull : clock.dateShort
            font.family:    Colors.fontUi
            font.pixelSize: Colors.fontSizeSm
            color:          hoverHandler.hovered ? Colors.accentAlt : Colors.textMuted

            Behavior on color { ColorAnimation { duration: Colors.animFast } }
        }
    }

    // Fondo sutil al hacer hover
    Rectangle {
        anchors.centerIn: parent
        width:   clockRow.implicitWidth + Colors.spacingMd * 2
        height:  Colors.barHeight - 8
        radius:  Colors.radiusSm
        color:   Colors.surface
        opacity: hoverHandler.hovered ? 1 : 0
        z:       -1

        Behavior on opacity { NumberAnimation { duration: Colors.animFast } }
    }

    HoverHandler { id: hoverHandler }
}
