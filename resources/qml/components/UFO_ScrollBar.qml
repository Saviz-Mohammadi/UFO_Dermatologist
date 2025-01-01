import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0

ScrollBar {
    id: root

    // size: 0.3
    // position: 0.2
    // active: true
    // orientation: Qt.Vertical

    contentItem: Rectangle {
        implicitWidth: 6
        implicitHeight: 100

        radius: width / 2
        color: root.pressed ? Qt.color(AppTheme.colors["UFO_ScrollBar_Pressed"]) : Qt.color(AppTheme.colors["UFO_ScrollBar_Normal"])

        // NOTE (SAVIZ): Hide the ScrollBar when it's not needed.
        opacity: root.policy === ScrollBar.AlwaysOn || (root.active && root.size < 1.0) ? 0.75 : 0

        Behavior on opacity { NumberAnimation {} }
    }
}
