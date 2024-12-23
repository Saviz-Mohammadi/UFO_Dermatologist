import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

Item {
    id: root

    property alias firstName: text_FirstName.text
    property alias lastName: text_LastName.text
    property alias gender: text_Gender.text
    property alias age: text_Age.text

    signal editClicked

    implicitWidth: 200
    implicitHeight: 60

    Rectangle {
        width: parent.width
        height: parent.height

        radius: 0

        color: Qt.color(AppTheme.colors["UFO_ListDelegate_Background"])

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    id: text_FirstName

                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pointSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    id: text_LastName

                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pointSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    id: text_Gender

                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pointSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    id: text_Age

                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pointSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            UFO_ListDelegateButton {
                Layout.preferredWidth: 130
                Layout.preferredHeight: 35

                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Edit Patient")
                svg: "./../../icons/Google icons/edit.svg"

                onClicked: {
                    root.editClicked()
                }
            }
        }
    }
}
