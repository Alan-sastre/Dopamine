import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../Config"
import "../../Services" as Svc

// Sección derecha — volumen + indicadores de sistema
Item {
    id: root

    implicitWidth:  rightRow.implicitWidth + Colors.spacingMd * 2
    implicitHeight: Colors.barHeight

    property var audio: Svc.Audio
    property var clock: Svc.Clock

    // ── Contenido ────────────────────────────────────────────────
    Row {
        id: rightRow
        anchors.centerIn: parent
        spacing: Colors.spacingSm

        // ── Control de volumen ───────────────────────────────────
        Item {
            id: volumeChip
            width:  volumeRow.implicitWidth + Colors.spacingMd * 2
            height: Colors.barHeight - 8
            anchors.verticalCenter: parent.verticalCenter

            // Fondo del chip
            Rectangle {
                anchors.fill: parent
                radius: Colors.radiusSm
                color:  volumeHover.hovered ? Colors.surface : "transparent"

                Behavior on color { ColorAnimation { duration: Colors.animFast } }
            }

            Row {
                id: volumeRow
                anchors.centerIn: parent
                spacing: Colors.spacingXs

                // Icono del altavoz
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text:           audio.icon
                    font.family:    Colors.fontFamily
                    font.pixelSize: Colors.iconSize
                    color:          audio.muted ? Colors.textMuted : Colors.text
                }

                // Porcentaje
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text:           audio.muted ? "Mute" : audio.volume + "%"
                    font.family:    Colors.fontFamily
                    font.pixelSize: Colors.fontSizeSm
                    color:          audio.muted ? Colors.textMuted : Colors.text
                    opacity:        volumeHover.hovered ? 1 : 0.85

                    Behavior on opacity { NumberAnimation { duration: Colors.animFast } }
                }

                // Barra de volumen (visible al hover)
                Item {
                    width:   volumeHover.hovered ? 60 : 0
                    height:  4
                    anchors.verticalCenter: parent.verticalCenter
                    clip:    true

                    Behavior on width { NumberAnimation { duration: Colors.animNormal; easing.type: Easing.OutCubic } }

                    Rectangle {
                        width:  parent.width
                        height: parent.height
                        radius: 2
                        color:  Colors.surface
                    }

                    Rectangle {
                        width:  parent.width * (audio.volume / 100)
                        height: parent.height
                        radius: 2
                        color:  audio.muted ? Colors.textMuted : Colors.accent

                        Behavior on width { NumberAnimation { duration: Colors.animFast } }
                    }
                }
            }

            HoverHandler { id: volumeHover }

            // Click izquierdo → mute, scroll → volumen
            TapHandler {
                onTapped: audio.toggleMute()
            }

            WheelHandler {
                onWheel: event => {
                    if (event.angleDelta.y > 0)
                        audio.increaseVolume(5)
                    else
                        audio.decreaseVolume(5)
                }
            }
        }

        // ── Separador ────────────────────────────────────────────
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width:  1
            height: 14
            color:  Colors.border
            opacity: 0.5
        }

        // ── Hora compacta (lado derecho) ─────────────────────────
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text:           clock.timeShort
            font.family:    Colors.fontFamily
            font.pixelSize: Colors.fontSizeSm
            color:          Colors.textMuted
        }
    }
}
