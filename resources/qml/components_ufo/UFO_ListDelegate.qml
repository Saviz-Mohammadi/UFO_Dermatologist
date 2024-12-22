import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

Item {
    id: root

    property alias firstName: firstName.text
    property alias lastName: lastName.text
    property alias gender: gender.text
    property alias age: age.text
    property alias backgroundColor: rectangle_Task.color

    signal editClicked

    implicitWidth: 200
    implicitHeight: content.implicitHeight

    Rectangle {
        id: rectangle_Task

        width: parent.width
        height: content.implicitHeight

        radius: 0

        RowLayout {
            id: content

            anchors.fill: parent

            Label {
                id: firstName

                Layout.fillWidth: true
                Layout.fillHeight: true

                Layout.topMargin: 15
                Layout.bottomMargin: 15
                Layout.leftMargin: 15

                text: qsTr("")
                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Text"])
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: lastName

                Layout.fillWidth: true
                Layout.fillHeight: true

                Layout.topMargin: 15
                Layout.bottomMargin: 15
                Layout.leftMargin: 15

                text: qsTr("")
                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Text"])
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: gender

                Layout.fillWidth: true
                Layout.fillHeight: true

                Layout.topMargin: 15
                Layout.bottomMargin: 15
                Layout.leftMargin: 15

                text: qsTr("")
                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Text"])
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: age

                Layout.fillWidth: true
                Layout.fillHeight: true

                Layout.topMargin: 15
                Layout.bottomMargin: 15
                Layout.leftMargin: 15

                text: qsTr("")
                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Text"])
                verticalAlignment: Text.AlignVCenter
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Edit")
                svg: "./../../icons/Google icons/edit.svg"

                onClicked: {

                    root.editClicked()
                }
            }
        }
    }
}
