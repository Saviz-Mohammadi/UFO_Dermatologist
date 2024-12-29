import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components"

// Custom CPP Registered Types
import AppTheme 1.0

Dialog {
    id: root

    property bool hasAccept: true
    property bool hasReject: true
    property alias acceptButtonText: ufo_Button_Accept.text
    property alias rejectButtonText: ufo_Button_Reject.text
    property alias titleString: text_Title.text
    property alias messageString: text_Message.text
    property string callbackIdentifier: ""

    implicitWidth: columnLayout_Content.implicitWidth
    implicitHeight: columnLayout_Content.implicitHeight

    modal: true
    focus: true

    background: Rectangle {
        radius: 0
        color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        border.color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        border.width: 1
    }

    ColumnLayout {
        id: columnLayout_Content

        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        Text {
            id: text_Title

            Layout.fillWidth: true
            Layout.fillHeight: true

            horizontalAlignment: Text.AlignLeft
            font.pointSize: Qt.application.font.pointSize * 1.15
            wrapMode: Text.WordWrap
        }

        Text {
            id: text_Message

            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.topMargin: 15

            horizontalAlignment: Text.AlignLeft
            font.pointSize: Qt.application.font.pointSize * 1
            wrapMode: Text.WordWrap
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                Layout.fillWidth: true
            }

            UFO_Button {
                id: ufo_Button_Reject

                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                text: qsTr("Cancel")
                visible: root.hasReject

                onClicked: {
                    root.rejected()
                }
            }

            UFO_Button {
                id: ufo_Button_Accept

                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                text: qsTr("OK")
                visible: root.hasAccept

                onClicked: {
                    root.accepted()
                }
            }
        }
    }
}
