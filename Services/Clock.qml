pragma Singleton
import QtQuick
import Quickshell

// Servicio de reloj — expone hora y fecha actualizadas cada segundo
QtObject {
    id: root

    // Reloj del sistema con intervalo de 1 segundo
    property var clock: SystemClock {
        precision: SystemClock.Seconds
    }

    // ── Hora ────────────────────────────────────────────────────
    readonly property string timeShort: Qt.formatTime(clock.date, "hh:mm")
    readonly property string timeFull:  Qt.formatTime(clock.date, "hh:mm:ss")
    readonly property string timeAmPm:  Qt.formatTime(clock.date, "hh:mm AP")

    // ── Fecha ────────────────────────────────────────────────────
    readonly property string dateShort: Qt.formatDate(clock.date, "ddd d MMM")
    readonly property string dateFull:  Qt.formatDate(clock.date, "dddd, d 'de' MMMM 'de' yyyy")
    readonly property string dateIso:   Qt.formatDate(clock.date, "yyyy-MM-dd")

    // ── Día de la semana ─────────────────────────────────────────
    readonly property int dayOfWeek:    clock.date.getDay()   // 0=Dom … 6=Sáb
    readonly property bool isWeekend:  dayOfWeek === 0 || dayOfWeek === 6
}
