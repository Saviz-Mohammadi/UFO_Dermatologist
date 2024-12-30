import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0

TabButton {
    id: root

    property alias borderRadius: rectangle_Background.radius
    property alias svg: iconImage.source
    property int svgWidth: 24
    property int svgHeight: 24

    implicitWidth: 120
    implicitHeight: 35

    opacity: enabled ? 1.0 : 0.5

    contentItem: RowLayout {

        IconImage {
            id: iconImage

            Layout.preferredWidth: svgWidth
            Layout.preferredHeight: svgHeight

            Layout.leftMargin: 10
            Layout.rightMargin: 5

            source: ""

            verticalAlignment: Image.AlignVCenter

            color: {
                if (root.checked) {
                    Qt.color(AppTheme.colors["UFO_SideBar_TabButton_Icon_Checked"])
                }

                else if (root.hovered) {
                    Qt.color(AppTheme.colors["UFO_SideBar_TabButton_Icon_Hovered"])
                }

                else {
                    Qt.color(AppTheme.colors["UFO_SideBar_TabButton_Icon_Normal"])
                }
            }
        }

        Text {
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: root.text
            font: root.font
            elide: Text.ElideRight

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            color: {
                if (root.checked) {
                    Qt.color(AppTheme.colors["UFO_SideBar_TabButton_Text_Checked"])
                }

                else if (root.hovered) {
                    Qt.color(AppTheme.colors["UFO_SideBar_TabButton_Text_Hovered"])
                }

                else {
                    Qt.color(AppTheme.colors["UFO_SideBar_TabButton_Text_Normal"])
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    background: Rectangle {
        id: rectangle_Background

        radius: 0

        color: {
            if (root.checked) {
                Qt.color(AppTheme.colors["UFO_SideBar_TabButton_Background_Checked"])
            }

            else if (root.hovered) {
                Qt.color(AppTheme.colors["UFO_SideBar_TabButton_Background_Hovered"])
            }

            else {
                Qt.color(AppTheme.colors["UFO_SideBar_TabButton_Background_Normal"])
            }
        }
    }
}
