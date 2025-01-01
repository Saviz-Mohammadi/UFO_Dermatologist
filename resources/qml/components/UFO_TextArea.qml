import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0

TextArea {
    id: root

    opacity: enabled ? 1.0 : 0.5

    color: {
        if (root.activeFocus) {
            Qt.color(AppTheme.colors["UFO_TextArea_Text_Active"])
        }

        else if (root.hovered) {
            Qt.color(AppTheme.colors["UFO_TextArea_Text_Hovered"])
        }

        else {
            Qt.color(AppTheme.colors["UFO_TextArea_Text_Normal"])
        }
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40

        color: {
            if (root.activeFocus) {
                Qt.color(AppTheme.colors["UFO_TextArea_Background_Active"])
            }

            else if (root.hovered) {
                Qt.color(AppTheme.colors["UFO_TextArea_Background_Hovered"])
            }

            else {
                Qt.color(AppTheme.colors["UFO_TextArea_Background_Normal"])
            }
        }

        border.color: Qt.color(AppTheme.colors["UFO_TextArea_Border"])
    }

    placeholderTextColor: {
        if (root.activeFocus) {
            Qt.color(AppTheme.colors["UFO_TextArea_Placeholder_Active"])
        }

        else if (root.hovered) {
            Qt.color(AppTheme.colors["UFO_TextArea_Placeholder_Hovered"])
        }

        else {
            Qt.color(AppTheme.colors["UFO_TextArea_Placeholder_Normal"])
        }
    }
}
