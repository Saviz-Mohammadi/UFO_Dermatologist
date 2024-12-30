import QtQuick
import QtQuick.Controls.Basic

// Custom CPP Registered Types
import AppTheme 1.0

CheckBox {
    id: root

    property alias contentText: text_Content.text

    opacity: enabled ? 1.0 : 0.5

    indicator: Rectangle {
        anchors.fill: parent

        radius: 0
        color: Qt.color(AppTheme.colors["UFO_SideBar_CheckBox_Indicator_Main"])

        Rectangle {
            width: parent.width / 2
            height: parent.height /2

            anchors.centerIn: parent

            radius: 0
            color: root.checked ? Qt.color(AppTheme.colors["UFO_SideBar_CheckBox_Indicator_Filler_Checked"]) : Qt.color(AppTheme.colors["UFO_SideBar_CheckBox_Indicator_Filler_Normal"])
            visible: root.checked
        }
    }

    contentItem: Text {
        id: text_Content

        text: root.text
        font: root.font
        color: Qt.color(AppTheme.colors["UFO_SideBar_CheckBox_Text"])
        verticalAlignment: Text.AlignVCenter
        leftPadding: root.indicator.width + root.spacing
    }
}
