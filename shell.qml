import QtQuick
import Quickshell
import "./Modules/bar"

// Dopamine Shell — entrada principal
// Instancia una Bar por cada monitor conectado
ShellRoot {
    id: root

    // Variants crea una instancia de Bar por cada pantalla disponible.
    // Quickshell inyecta `modelData` (la pantalla) automáticamente en cada instancia.
    Variants {
        model: Quickshell.screens

        Bar {
            // Cada instancia recibe su pantalla correspondiente
            screen: modelData
        }
    }
}
