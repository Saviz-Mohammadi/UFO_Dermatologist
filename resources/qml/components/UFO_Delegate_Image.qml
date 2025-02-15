import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

Item {
    id: root


    property alias imageName: ufo_TextField_ImageName.text

    signal removeClicked
    signal viewClicked

    implicitWidth: 200
    implicitHeight: 35

    ColumnLayout {
        anchors.fill: parent

        spacing: 5

        RowLayout {
            Layout.fillWidth: true

            spacing: 5

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("مشاهده")
                icon.source: "./../../icons/Google icons/visibility.svg"

                onClicked: {
                    root.viewClicked();
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("حذف")
                icon.source: "./../../icons/Google icons/delete.svg"

                onClicked: {
                    root.removeClicked();
                }
            }
        }

        UFO_TextField {
            id: ufo_TextField_ImageName

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus === true) ? true : false
        }
    }
}
