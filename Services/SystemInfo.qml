pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

// Servicio de información del sistema — CPU y RAM desde /proc,
// batería desde UPower. Todos los valores son reactivos.
QtObject {
    id: root

    // ── CPU ──────────────────────────────────────────────────────
    property real cpuUsage: 0

    property real _prevIdle:  -1
    property real _prevTotal: -1

    // ── RAM ──────────────────────────────────────────────────────
    property int memTotalKb:     0
    property int memAvailableKb: 0

    readonly property int  memUsedKb: Math.max(0, memTotalKb - memAvailableKb)
    readonly property real memUsage:  memTotalKb > 0 ? (memUsedKb / memTotalKb) * 100 : 0

    // ── Batería (UPower) ─────────────────────────────────────────
    readonly property var battery: {
        if (!UPower.devices) return null
        for (const d of UPower.devices.values)
            if (d.isLaptopBattery) return d
        return null
    }

    readonly property bool hasBattery:      battery !== null
    readonly property real batteryPercent:  battery ? battery.percentage : 0
    readonly property bool batteryCharging: battery ? battery.state === UPowerDeviceState.Charging : false
    readonly property bool batteryFull:     battery ? battery.state === UPowerDeviceState.FullyCharged : false

    readonly property string batteryIcon: {
        if (batteryCharging)      return "󰂄"
        if (batteryFull)          return "󰁹"
        if (!hasBattery)          return ""
        if (batteryPercent >= 90) return "󰁹"
        if (batteryPercent >= 70) return "󰂀"
        if (batteryPercent >= 50) return "󰁾"
        if (batteryPercent >= 30) return "󰁼"
        if (batteryPercent >= 10) return "󰁺"
        return "󰂃"
    }

    // ── Procesos de lectura ──────────────────────────────────────
    property var statProcess: Process {
        id: statProc
        command: ["cat", "/proc/stat"]
        stdout: SplitParser { onRead: line => root._parseStat(line) }
    }

    property var memProcess: Process {
        id: memProc
        command: ["cat", "/proc/meminfo"]
        stdout: SplitParser { onRead: line => root._parseMem(line) }
    }

    property var pollTimer: Timer {
        interval: 2000
        running:  true
        repeat:   true
        onTriggered: root.refresh()
    }

    // ── API ──────────────────────────────────────────────────────
    function refresh() {
        statProc.running = true
        memProc.running  = true
    }

    // ── Parsers ──────────────────────────────────────────────────
    function _parseStat(line) {
        // "cpu  user nice system idle iowait irq softirq steal ..."
        if (!line.startsWith("cpu ")) return
        const parts = line.trim().split(/\s+/).slice(1).map(Number)

        const idle  = (parts[3] ?? 0) + (parts[4] ?? 0)   // idle + iowait
        let   total = 0
        for (let i = 0; i < 8 && i < parts.length; i++)
            total += parts[i]

        if (root._prevTotal >= 0) {
            const dTotal = total - root._prevTotal
            const dIdle  = idle  - root._prevIdle
            if (dTotal > 0)
                root.cpuUsage = Math.max(0, Math.min(100, (1 - dIdle / dTotal) * 100))
        }

        root._prevTotal = total
        root._prevIdle  = idle
    }

    function _parseMem(line) {
        const m = line.match(/^(\w+):\s+(\d+)\s*kB/)
        if (!m) return
        const key = m[1]
        const val = parseInt(m[2])
        if (key === "MemTotal")          root.memTotalKb     = val
        else if (key === "MemAvailable") root.memAvailableKb = val
    }

    Component.onCompleted: refresh()
}
