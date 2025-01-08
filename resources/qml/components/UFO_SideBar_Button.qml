import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0

Button {
    id: control

    property real radius: 0

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding)

    opacity: control.enabled ? 1 : 0.5

    padding: 6
    spacing: 6

    icon.width: 24
    icon.height: 24

    icon.color: {
        if (control.checked) {
            return Qt.color(AppTheme.colors["UFO_SideBar_Button_Icon_Checked"]);
        }

        if (control.hovered && control.enabled) {
            return Qt.color(AppTheme.colors["UFO_SideBar_Button_Icon_Hovered"]);
        }

        return Qt.color(AppTheme.colors["UFO_SideBar_Button_Icon_Normal"]);
    }

    contentItem: RowLayout {

        IconLabel {
            id: iconLabel_Content

            spacing: control.spacing
            mirrored: control.mirrored
            display: control.display

            icon: control.icon
            text: control.text
            font: control.font

            color: {
                if (control.checked) {
                    return Qt.color(AppTheme.colors["UFO_SideBar_Button_Text_Checked"]);
                }

                if (control.hovered && control.enabled) {
                    return Qt.color(AppTheme.colors["UFO_SideBar_Button_Text_Hovered"]);
                }

                return Qt.color(AppTheme.colors["UFO_SideBar_Button_Text_Normal"]);
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    background: Rectangle {
        id: rectangle_Background

        implicitWidth: 100
        implicitHeight: 35

        radius: control.radius

        color: {
            if (control.checked) {
                return Qt.color(AppTheme.colors["UFO_SideBar_Button_Background_Checked"]);
            }

            if (control.hovered && control.enabled) {
                return Qt.color(AppTheme.colors["UFO_SideBar_Button_Background_Hovered"]);
            }

            return Qt.color(AppTheme.colors["UFO_SideBar_Button_Background_Normal"]);
        }
    }
}
