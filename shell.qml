import QtQuick
import Quickshell
import "./Modules/bar"

// Dopamine Shell — entrada principal
// Instancia una Bar por cada monitor conectado
ShellRoot {
    id: root

    // Variants crea una instancia de Bar por cada pantalla disponible.
    // `modelData` (la pantalla) se inyecta solo si el delegate lo declara
    // como `required property` (requisito de Variants en Quickshell 0.3.x).
    Variants {
        model: Quickshell.screens

        Bar {
            // Cada instancia recibe su pantalla correspondiente
            required property var modelData
            screen: modelData
        }
    }
}
