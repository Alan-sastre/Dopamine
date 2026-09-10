pragma Singleton
import QtQuick

// Dopamine — paleta de colores, fuentes y tamaños
// Edita este archivo para personalizar toda la shell
QtObject {

    // ── Colores base ────────────────────────────────────────────
    readonly property color bg:          "#1a1b26"   // fondo de la barra
    readonly property color bgAlt:       "#16161e"   // fondo alternativo (popups)
    readonly property color bgFloat:     "#1f2335"   // fondo de elementos flotantes
    readonly property color surface:     "#24283b"   // superficie de tarjetas/botones
    readonly property color overlay:     "#292e42"   // overlay hover

    readonly property color border:      "#3b4261"   // bordes sutiles
    readonly property color borderFocus: "#7aa2f7"   // borde al hacer foco

    // ── Texto ────────────────────────────────────────────────────
    readonly property color text:        "#c0caf5"   // texto principal
    readonly property color textMuted:   "#565f89"   // texto secundario/apagado
    readonly property color textSubtle:  "#414868"   // texto muy apagado

    // ── Accentos ─────────────────────────────────────────────────
    readonly property color accent:      "#7aa2f7"   // azul — color principal
    readonly property color accentAlt:   "#bb9af7"   // violeta — secundario
    readonly property color green:       "#9ece6a"
    readonly property color yellow:      "#e0af68"
    readonly property color orange:      "#ff9e64"
    readonly property color red:         "#f7768e"
    readonly property color cyan:        "#7dcfff"
    readonly property color teal:        "#73daca"

    // ── Transparencias ───────────────────────────────────────────
    readonly property color bgTransparent:    Qt.rgba(0.1, 0.11, 0.15)
    readonly property color overlayDim:       Qt.rgba(0, 0, 0, 0.4)

    // ── Fuentes ──────────────────────────────────────────────────
    readonly property string fontFamily:  "JetBrainsMono Nerd Font"
    readonly property string fontUi:      "Inter"

    readonly property int fontSizeXs:     10
    readonly property int fontSizeSm:     11
    readonly property int fontSizeMd:     12
    readonly property int fontSizeLg:     13
    readonly property int fontSizeXl:     15
    readonly property int fontSizeXxl:    20

    // ── Geometría ────────────────────────────────────────────────
    readonly property int barHeight:      36
    readonly property int radius:         8
    readonly property int radiusSm:       4
    readonly property int radiusLg:       12

    readonly property int spacingXs:      4
    readonly property int spacingSm:      8
    readonly property int spacingMd:      12
    readonly property int spacingLg:      16
    readonly property int spacingXl:      24

    readonly property int iconSize:       16

    // ── Animaciones ──────────────────────────────────────────────
    readonly property int animFast:       100
    readonly property int animNormal:     200
    readonly property int animSlow:       350
}
