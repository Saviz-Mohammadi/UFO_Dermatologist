import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0

Item {
    id: root

    default property alias content: columnLayout.data
    property int contentSpacing: 7
    property int contentTopMargin: 20
    property int contentBottomMargin: 35
    property int contentLeftMargin: 20
    property int contentRightMargin: 20
    property alias pageRadius: rectangle_Background.radius
    property alias title: text_PageTitle.text
    property alias contentVisible: scrollView.visible
    property real titleFontSize: 1.8

    implicitWidth: 300
    implicitHeight: 300

    Rectangle {
        id: rectangle_Background

        anchors.fill: parent

        radius: 0
        color: Qt.color(AppTheme.colors["UFO_Page_Background"])

        ScrollView {
            id: scrollView

            anchors.fill: parent

            contentWidth: -1
            contentHeight: columnLayout.height + text_PageTitle.height + contentBottomMargin

            Text {
                id: text_PageTitle

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                anchors.topMargin: root.contentTopMargin
                anchors.leftMargin: root.contentLeftMargin
                anchors.rightMargin: root.contentRightMargin

                color: Qt.color(AppTheme.colors["UFO_Page_Title"])
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Qt.application.font.pixelSize * titleFontSize
                elide: Text.ElideRight
            }

            // NOTE (SAVIZ): There is a small overhead due to things such as margins, font sizes, and other things. This is why we add "contentBottomMargin".
            // NOTE (SAVIZ): If you want to enable horizontal scrolling, then it is best to place the target element inside of another "ScrollView".
            ColumnLayout {
                id: columnLayout

                anchors.top: text_PageTitle.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                anchors.topMargin: root.contentTopMargin
                anchors.leftMargin: root.contentLeftMargin
                anchors.rightMargin: root.contentRightMargin

                clip: true
                spacing: contentSpacing
            }
        }
    }
}
