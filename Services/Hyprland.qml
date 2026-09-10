pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

// Servicio Hyprland — expone workspaces y ventana activa via IPC nativo
QtObject {
    id: root

    // IPC de Hyprland provisto por Quickshell
    property var hyprland: Hyprland

    // ── Workspaces ───────────────────────────────────────────────
    // Lista de workspaces activos (tienen al menos una ventana abierta)
    readonly property var workspaces: Hyprland.workspaces

    // Workspace activo actual
    readonly property var activeWorkspace: Hyprland.activeWorkspace

    readonly property int activeWorkspaceId: activeWorkspace?.id ?? 1

    // ── Ventana activa ───────────────────────────────────────────
    readonly property var activeWindow: Hyprland.activeWindow

    readonly property string activeWindowTitle: activeWindow?.title ?? ""
    readonly property string activeWindowClass: activeWindow?.class ?? ""

    // ── Acciones ─────────────────────────────────────────────────

    // Ir a un workspace por ID
    function goToWorkspace(id) {
        Hyprland.dispatch("workspace " + id)
    }

    // Mover ventana activa a workspace
    function moveToWorkspace(id) {
        Hyprland.dispatch("movetoworkspace " + id)
    }
}
