import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

Item {
    id: root

    property alias header: text_Header.text
    property alias patientId: text_ID.text
    property alias birthYear: text_BirthYear.text
    property alias phoneNumber: text_PhoneNumber.text
    property alias gender: text_Gender.text
    property alias maritalStatus: text_MaritalStatus.text
    property alias servicePrice: text_ServicePrice.text

    signal editClicked

    implicitWidth: 200
    implicitHeight: 150

    Rectangle {
        anchors.fill: parent

        color: 'white'
        radius: 0

        GridLayout {
            id: gridLayout_Content

            anchors.fill: parent

            columns: 4
            rows: 3

            columnSpacing: 7
            rowSpacing: 7

            IconImage {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32

                Layout.column: 0
                Layout.row: 0
                Layout.rowSpan: 2

                sourceSize.width: 32
                sourceSize.height: 32

                source: "./../../icons/Google icons/person.svg"
                verticalAlignment: Image.AlignVCenter

                color: Qt.rgba(0, 0, 0, 0.85)
            }

            Text {
                id: text_Header

                Layout.fillWidth: true
                Layout.fillHeight: true

                Layout.column: 1
                Layout.row: 0
                Layout.columnSpan: 2

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter

                font.pixelSize: Qt.application.font.pixelSize * 1.10
                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
            }

            UFO_ListDelegateButton {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                Layout.column: 3
                Layout.row: 0

                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Edit")
                svg: "./../../icons/Google icons/person_edit.svg"

                onClicked: {
                    root.editClicked()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 1
                Layout.row: 1

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    id: text_ID

                    anchors.fill: parent

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pixelSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 2
                Layout.row: 1

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    id: text_BirthYear

                    anchors.fill: parent

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pixelSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 3
                Layout.row: 1

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    id: text_PhoneNumber

                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pixelSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 1
                Layout.row: 2

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    id: text_Gender

                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pixelSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 2
                Layout.row: 2

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    id: text_MaritalStatus

                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pixelSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 3
                Layout.row: 2

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    id: text_ServicePrice

                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pixelSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }
        }
    }
}
