import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import "../Config"
import "../Services" as Svc

// Launcher de aplicaciones — overlay a pantalla completa sobre el monitor
// enfocado. Se controla desde Svc.Launcher (barra o IPC).
PanelWindow {
    id: root

    // ── Pantalla: seguir al monitor enfocado ─────────────────────
    readonly property var focusedScreen: {
        const fm = Hyprland.focusedMonitor
        if (fm)
            for (const s of Quickshell.screens)
                if (Hyprland.monitorFor(s) === fm) return s
        return Quickshell.screens.length > 0 ? Quickshell.screens[0] : null
    }

    screen: root.focusedScreen

    anchors {
        top:    true
        bottom: true
        left:   true
        right:  true
    }

    color:           "transparent"
    visible:         Svc.Launcher.open
    exclusionMode:   ExclusionMode.Ignore
    WlrLayershell.layer:          WlrLayer.Overlay
    WlrLayershell.keyboardFocus:  WlrKeyboardFocus.Exclusive

    // ── Resultados filtrados ─────────────────────────────────────
    readonly property var filteredApps: {
        const q = search.text.trim().toLowerCase()
        let apps = DesktopEntries.applications.values.filter(a => !a.noDisplay)
        if (q !== "") {
            apps = apps.filter(a =>
                a.name.toLowerCase().includes(q) ||
                (a.genericName ?? "").toLowerCase().includes(q) ||
                (a.comment ?? "").toLowerCase().includes(q) ||
                (a.keywords ?? []).some(k => k.toLowerCase().includes(q)))
        }
        return apps.slice().sort((a, b) => a.name.localeCompare(b.name))
    }

    function launch(app) {
        if (!app) return
        app.execute()
        Svc.Launcher.close()
    }

    function launchCurrent() {
        if (results.currentItem)
            root.launch(results.currentItem.modelData)
    }

    // Resetear al abrir
    onVisibleChanged: {
        if (root.visible) {
            search.text = ""
            search.forceActiveFocus()
            results.currentIndex = 0
        }
    }

    // ── Fondo y cierre al hacer click fuera ──────────────────────
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.35)

        MouseArea {
            anchors.fill: parent
            onClicked: Svc.Launcher.close()
        }
    }

    // ── Caja del launcher ────────────────────────────────────────
    Rectangle {
        id: box

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:              parent.top
        anchors.topMargin:        120

        width:  Math.min(640, parent.width  - 80)
        height: Math.min(460, parent.height - 200)

        radius:       Colors.radiusLg
        color:        Colors.bgFloat
        border.color: Colors.borderFocus
        border.width: 1

        // Absorber clicks dentro de la caja
        MouseArea { anchors.fill: parent }

        Column {
            anchors.fill:    parent
            anchors.margins: Colors.spacingLg
            spacing:         Colors.spacingSm

            // Campo de búsqueda
            Rectangle {
                width:  parent.width
                height: 44
                radius: Colors.radius
                color:  Colors.surface

                TextInput {
                    id: search
                    anchors.fill:        parent
                    anchors.leftMargin:  Colors.spacingMd
                    anchors.rightMargin: Colors.spacingMd

                    verticalAlignment: TextInput.AlignVCenter
                    color:             Colors.text
                    font.family:       Colors.fontUi
                    font.pixelSize:    Colors.fontSizeXl
                    selectByMouse:     true
                    selectionColor:    Colors.accent
                    selectedTextColor: Colors.bg

                    onTextChanged: results.currentIndex = 0

                    Keys.onEscapePressed: Svc.Launcher.close()
                    Keys.onDownPressed:   results.incrementCurrentIndex()
                    Keys.onUpPressed:     results.decrementCurrentIndex()
                    Keys.onReturnPressed: root.launchCurrent()
                    Keys.onEnterPressed:  root.launchCurrent()

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text:    "Buscar aplicaciones…"
                        visible: search.text === ""
                        color:   Colors.textMuted
                        font:    search.font
                    }
                }
            }

            // Lista de resultados
            ListView {
                id: results
                width:  parent.width
                height: parent.height - 44 - Colors.spacingSm
                clip:   true
                spacing: 2
                model:  root.filteredApps

                delegate: Rectangle {
                    required property var modelData
                    required property int index

                    width:  results.width
                    height: 44
                    radius: Colors.radiusSm
                    color:  index === results.currentIndex ? Colors.overlay : "transparent"

                    Row {
                        anchors.fill:        parent
                        anchors.leftMargin:  Colors.spacingSm
                        anchors.rightMargin: Colors.spacingSm
                        spacing:             Colors.spacingMd

                        IconImage {
                            width:  24
                            height: 24
                            anchors.verticalCenter: parent.verticalCenter
                            source: Quickshell.iconPath(modelData.icon, "application-x-executable")
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text:           modelData.name
                                color:          Colors.text
                                font.family:    Colors.fontUi
                                font.pixelSize: Colors.fontSizeMd
                            }

                            Text {
                                text:           modelData.genericName
                                visible:        text !== ""
                                color:          Colors.textMuted
                                font.family:    Colors.fontUi
                                font.pixelSize: Colors.fontSizeXs
                            }
                        }
                    }

                    HoverHandler { onHoveredChanged: if (hovered) results.currentIndex = index }
                    TapHandler { onTapped: root.launch(modelData) }
                }
            }
        }
    }
}
