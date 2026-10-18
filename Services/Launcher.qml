pragma Singleton
import QtQuick
import Quickshell.Io

// Estado global del launcher de aplicaciones.
// Se abre desde la barra o por IPC:
//   qs -c dopamine ipc call launcher toggle
QtObject {
    id: root

    property bool open: false

    function toggle(): void { root.open = !root.open }
    function show():   void { root.open = true }
    function close():  void { root.open = false }

    property var ipc: IpcHandler {
        target: "launcher"

        function toggle(): void { root.toggle() }
        function open():   void { root.show() }
        function close():  void { root.close() }
    }
}
