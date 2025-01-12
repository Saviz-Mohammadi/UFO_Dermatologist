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
    implicitHeight: 250

    Rectangle {
        anchors.fill: parent

        anchors.margins: 10

        color: Qt.color(AppTheme.colors["UFO_Delegate_Background"])
        radius: 0

        ColumnLayout {
            id: columnLayout_Content

            anchors.fill: parent

            RowLayout {
                Layout.fillWidth: true

                Layout.leftMargin: 15
                Layout.rightMargin: 15

                spacing: 15

                UFO_Button {
                    Layout.preferredHeight: 35

                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

                    enabled: (Database.connectionStatus === true) ? true : false

                    text: qsTr("ویرایش")
                    icon.source: "./../../icons/Google icons/person_edit.svg"

                    onClicked: {
                        root.editClicked()
                    }
                }

                Text {
                    id: text_Header

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap

                    verticalAlignment: Text.AlignVCenter

                    font.pixelSize: Qt.application.font.pixelSize * 1.45
                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                }

                IconLabel {
                    Layout.preferredWidth: 64
                    Layout.preferredHeight: 64

                    icon.source: "./../../icons/Google icons/person.svg"
                    icon.width: 64
                    icon.height: 64

                    icon.color: Qt.color(AppTheme.colors["UFO_Delegate_Icon"])
                }
            }

            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Layout.bottomMargin: 15
                Layout.leftMargin: 15
                Layout.rightMargin: 15

                columns: 3
                rows: 4

                Text {
                    Layout.fillWidth: true

                    Layout.column: 2
                    Layout.row: 0

                    text: qsTr("شماره پرونده")

                    verticalAlignment: Text.AlignBottom

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    Layout.column: 2
                    Layout.row: 1

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

                    Text {
                        id: text_ID

                        anchors.fill: parent
                        anchors.leftMargin: 10

                        verticalAlignment: Text.AlignVCenter

                        color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                        font.pixelSize: Qt.application.font.pixelSize * 1
                        elide: Text.ElideRight
                    }
                }

                Text {
                    Layout.fillWidth: true

                    Layout.column: 1
                    Layout.row: 0

                    text: qsTr("سال تولد")

                    verticalAlignment: Text.AlignBottom

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    Layout.column: 1
                    Layout.row: 1

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

                    Text {
                        id: text_BirthYear

                        anchors.fill: parent
                        anchors.leftMargin: 10

                        verticalAlignment: Text.AlignVCenter

                        color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                        font.pixelSize: Qt.application.font.pixelSize * 1
                        elide: Text.ElideRight
                    }
                }

                Text {
                    Layout.fillWidth: true

                    Layout.column: 0
                    Layout.row: 0

                    text: qsTr("شماره تلفن")

                    verticalAlignment: Text.AlignBottom

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    Layout.column: 0
                    Layout.row: 1

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

                    Text {
                        id: text_PhoneNumber

                        anchors.fill: parent
                        anchors.leftMargin: 10

                        verticalAlignment: Text.AlignVCenter

                        color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                        font.pixelSize: Qt.application.font.pixelSize * 1
                        elide: Text.ElideRight
                    }
                }

                Text {
                    Layout.fillWidth: true

                    Layout.column: 2
                    Layout.row: 2

                    text: qsTr("جنسیت")

                    verticalAlignment: Text.AlignBottom

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    Layout.column: 2
                    Layout.row: 3

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

                    Text {
                        id: text_Gender

                        anchors.fill: parent
                        anchors.leftMargin: 10

                        verticalAlignment: Text.AlignVCenter

                        color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                        font.pixelSize: Qt.application.font.pixelSize * 1
                        elide: Text.ElideRight
                    }
                }

                Text {
                    Layout.fillWidth: true

                    Layout.column: 1
                    Layout.row: 2

                    text: qsTr("وضعیت تأهل")

                    verticalAlignment: Text.AlignBottom

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    Layout.column: 1
                    Layout.row: 3

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

                    Text {
                        id: text_MaritalStatus

                        anchors.fill: parent
                        anchors.leftMargin: 10

                        verticalAlignment: Text.AlignVCenter

                        color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                        font.pixelSize: Qt.application.font.pixelSize * 1
                        elide: Text.ElideRight
                    }
                }

                Text {
                    Layout.fillWidth: true

                    Layout.column: 0
                    Layout.row: 2

                    text: qsTr("قیمت خدمات")

                    verticalAlignment: Text.AlignBottom

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    Layout.column: 0
                    Layout.row: 3

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

                    Text {
                        id: text_ServicePrice

                        anchors.fill: parent
                        anchors.leftMargin: 10

                        verticalAlignment: Text.AlignVCenter

                        color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                        font.pixelSize: Qt.application.font.pixelSize * 1
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
