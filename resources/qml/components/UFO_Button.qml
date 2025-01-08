import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0

// NOTE (SAVIZ): Setting 'enabled' property to 'false' does not affect 'hovered'. Because hover events are only affected by 'hoverEnabled'.

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
        if (control.down) {
            return Qt.color(AppTheme.colors["UFO_Button_Icon_Down"]);
        }

        if (control.checked) {
            return Qt.color(AppTheme.colors["UFO_Button_Icon_Checked"]);
        }

        if (control.hovered && control.enabled) {
            return Qt.color(AppTheme.colors["UFO_Button_Icon_Hovered"]);
        }

        return Qt.color(AppTheme.colors["UFO_Button_Icon_Normal"]);
    }

    contentItem: IconLabel {
        id: iconLabel_Content

        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display

        icon: control.icon
        text: control.text
        font: control.font

        color: {
            if (control.down) {
                return Qt.color(AppTheme.colors["UFO_Button_Text_Down"]);
            }

            if (control.checked) {
                return Qt.color(AppTheme.colors["UFO_Button_Text_Checked"]);
            }

            if (control.hovered && control.enabled) {
                return Qt.color(AppTheme.colors["UFO_Button_Text_Hovered"]);
            }

            return Qt.color(AppTheme.colors["UFO_Button_Text_Normal"]);
        }
    }

    background: Rectangle {
        id: rectangle_Background

        implicitWidth: 100
        implicitHeight: 35

        radius: control.radius
        visible: !control.flat

        color: {
            if (control.down) {
                return Qt.color(AppTheme.colors["UFO_Button_Background_Down"]);
            }

            if (control.checked) {
                return Qt.color(AppTheme.colors["UFO_Button_Background_Checked"]);
            }

            if (control.hovered && control.enabled) {
                return Qt.color(AppTheme.colors["UFO_Button_Background_Hovered"]);
            }

            return Qt.color(AppTheme.colors["UFO_Button_Background_Normal"]);
        }

        border.color: Qt.color(AppTheme.colors["UFO_Button_Border"]);
        border.width: control.visualFocus ? 2 : 0
    }
}
