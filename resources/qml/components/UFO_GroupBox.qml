import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0

Item {
    id: root

    default property alias content: columnLayout.data
    property int contentSpacing: 7
    property alias title: text.text
    property real titleFontSize: 1.3
    property real titleSeparatorHeight: 2
    property alias titleSeparatorColor: rectangle_2.color
    property real titleTopMargin: 0
    property real titleBottomMarign: 0
    property real titleLeftMargin: 10
    property real titleRightMargin: 10

    implicitWidth: 300
    implicitHeight: (rectangle_1.implicitHeight + rectangle_2.implicitHeight + rectangle_3.implicitHeight)

    Rectangle {
        id: rectangle_1

        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right

        implicitWidth: root.implicitWidth
        implicitHeight: 35

        color: Qt.color(AppTheme.colors["UFO_GroupBox_Title_Background"])

        Text {
            id: text

            anchors.fill: parent

            anchors.topMargin: root.titleTopMargin
            anchors.bottomMargin: root.titleBottomMargin
            anchors.leftMargin: root.titleLeftMargin
            anchors.rightMargin: root.titleRightMargin

            text: qsTr("")
            verticalAlignment: Text.AlignVCenter
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Title_Text"])
            font.pixelSize: Qt.application.font.pixelSize * titleFontSize // Read-only property. Holds the default application font returned by QGuiApplication::font()
            elide: Text.ElideRight
        }
    }

    Rectangle {
        id: rectangle_2

        anchors.top: rectangle_1.bottom
        anchors.left: root.left
        anchors.right: root.right

        implicitWidth: root.implicitWidth
        implicitHeight: root.titleSeparatorHeight

        color: Qt.color(AppTheme.colors["UFO_GroupBox_Separator"])
    }

    Rectangle {
        id: rectangle_3

        anchors.top: rectangle_2.bottom
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom

        implicitWidth: root.implicitWidth
        implicitHeight: columnLayout.implicitHeight

        radius: 0
        color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Background"])

        ColumnLayout {
            id: columnLayout

            width: rectangle_3.width

            clip: true
            spacing: contentSpacing
        }
    }
}
