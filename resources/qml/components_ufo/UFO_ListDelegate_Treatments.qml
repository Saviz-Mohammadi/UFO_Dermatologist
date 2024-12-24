import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

Item {
    id: root

    property alias treatmentName: label.text

    signal deleteClicked

    implicitWidth: 200
    implicitHeight: 35

    RowLayout {
        anchors.fill: parent

        spacing: 1

        Label {
            id: label

            Layout.fillWidth: true
            Layout.fillHeight: true

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])

            font.pointSize: Qt.application.font.pixelSize * 1
            elide: Text.ElideRight

            background: Rectangle {
                anchors.fill: parent

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])
            }
        }

        UFO_ListDelegateButton {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

            enabled: (Database.connectionStatus === true) ? true : false

            text: qsTr("Delete")
            svg: "./../../icons/Google icons/edit.svg"

            onClicked: {
                root.deleteClicked()
            }
        }
    }
}
