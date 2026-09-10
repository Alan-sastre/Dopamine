pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Servicio de audio — lee y controla volumen/mute via pactl (PipeWire compatible)
QtObject {
    id: root

    // ── Estado ───────────────────────────────────────────────────
    property int  volume:  50      // 0-100
    property bool muted:   false

    // Icono según volumen y estado mute
    readonly property string icon: {
        if (muted || volume === 0) return "󰝟"
        if (volume < 34)           return "󰕿"
        if (volume < 67)           return "󰖀"
        return "󰕾"
    }

    // ── Leer volumen al iniciar y periódicamente ─────────────────
    property var pollTimer: Timer {
        interval: 2000
        running:  true
        repeat:   true
        onTriggered: root.refresh()
    }

    // Proceso para leer el volumen del sink por defecto
    property var readerProcess: Process {
        id: volumeReader
        command: ["pactl", "get-sink-volume", "@DEFAULT_SINK@"]
        running: false
        stdout: SplitParser {
            onRead: data => root._parseVolume(data)
        }
    }

    property var muteReaderProcess: Process {
        id: muteReader
        command: ["pactl", "get-sink-mute", "@DEFAULT_SINK@"]
        running: false
        stdout: SplitParser {
            onRead: data => root._parseMute(data)
        }
    }

    // ── Proceso para modificar volumen/mute ──────────────────────
    property var writerProcess: Process {
        id: volumeWriter
        running: false
        onExited: root.refresh()
    }

    // ── API pública ──────────────────────────────────────────────

    function refresh() {
        volumeReader.running = true
        muteReader.running   = true
    }

    function setVolume(val) {
        val = Math.max(0, Math.min(100, val))
        volumeWriter.command = ["pactl", "set-sink-volume", "@DEFAULT_SINK@", val + "%"]
        volumeWriter.running = true
    }

    function increaseVolume(step) {
        setVolume(volume + (step ?? 5))
    }

    function decreaseVolume(step) {
        setVolume(volume - (step ?? 5))
    }

    function toggleMute() {
        volumeWriter.command = ["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"]
        volumeWriter.running = true
    }

    // ── Parsers internos ─────────────────────────────────────────

    function _parseVolume(line) {
        // Salida típica: "Volume: front-left: 65536 / 100% / 0.00 dB, ..."
        const match = line.match(/(\d+)%/)
        if (match) root.volume = parseInt(match[1])
    }

    function _parseMute(line) {
        // Salida típica: "Mute: yes" o "Mute: no"
        root.muted = line.includes("yes")
    }

    // Leer al arrancar
    Component.onCompleted: refresh()
}
