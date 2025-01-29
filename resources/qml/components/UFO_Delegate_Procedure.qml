import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

Item {
    id: root

    property alias procedureName: text_ProcedureName.text

    signal removeClicked

    implicitWidth: 200
    implicitHeight: 35

    RowLayout {
        anchors.fill: parent

        spacing: 5

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            color: Qt.color(AppTheme.colors["UFO_Delegate_Background"])

            Text {
                id: text_ProcedureName

                anchors.fill: parent
                anchors.leftMargin: 10

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter

                color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                font.pointSize: Qt.application.font.pointSize * 1
                elide: Text.ElideRight
            }
        }

        UFO_Button {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

            enabled: (Database.connectionStatus === true) ? true : false

            text: qsTr("Remove")
            icon.source: "./../../icons/Google icons/delete.svg"

            onClicked: {
                root.removeClicked()
            }
        }
    }
}
