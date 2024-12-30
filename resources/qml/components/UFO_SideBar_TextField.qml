import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0

TextField {
    id: root

    property alias borderRadius: rectangle_Background.radius

    implicitWidth: 200
    implicitHeight: 35

    opacity: enabled ? 1.0 : 0.5

    background: Rectangle {
        id: rectangle_Background

        anchors.fill: parent

        radius: 0

        color: {
            if (root.activeFocus) {
                Qt.color(AppTheme.colors["UFO_SideBar_TextField_Background_Active"])
            }

            else if (root.hovered) {
                Qt.color(AppTheme.colors["UFO_SideBar_TextField_Background_Hovered"])
            }

            else {
                Qt.color(AppTheme.colors["UFO_SideBar_TextField_Background_Normal"])
            }
        }

        border.color: root.enabled ? Qt.color(AppTheme.colors["UFO_SideBar_TextField_Border"]) : Qt.color(AppTheme.colors["UFO_SideBar_TextField_Border"])
    }

    color: {
        if (root.activeFocus) {
            Qt.color(AppTheme.colors["UFO_SideBar_TextField_Text_Active"])
        }

        else if (root.hovered) {
            Qt.color(AppTheme.colors["UFO_SideBar_TextField_Text_Hovered"])
        }

        else {
            Qt.color(AppTheme.colors["UFO_SideBar_TextField_Text_Normal"])
        }
    }

    selectedTextColor: Qt.color(AppTheme.colors["UFO_SideBar_TextField_SelectedText"])

    placeholderTextColor: {
        if (root.activeFocus) {
            Qt.color(AppTheme.colors["UFO_TextField_Placeholder_Active"])
        }

        else if (root.hovered) {
            Qt.color(AppTheme.colors["UFO_TextField_Placeholder_Hovered"])
        }

        else {
            Qt.color(AppTheme.colors["UFO_TextField_Placeholder_Normal"])
        }
    }
}
