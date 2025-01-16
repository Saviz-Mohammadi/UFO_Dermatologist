import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

Item {
    id: root

    property alias labName: text_LabName.text
    property alias labType: text_LabType.text
    property alias labTestConductedDate: ufo_TextField_LabTestConductDate.text
    property alias labTestOutcome: ufo_TextArea_Outcome.text

    signal removeClicked
    signal dateChanged
    signal outcomeChanged

    implicitWidth: 200
    implicitHeight: 200

    ColumnLayout {
        anchors.fill: parent

        spacing: 10

        RowLayout {
            Layout.fillWidth: true

            spacing: 1

            UFO_Button {
                id: ufo_Button_Expand

                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                checkable: true
                checked: false

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Remove")
                icon.source: "./../../icons/Google icons/delete.svg"
            }

            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

                Text {
                    id: text_LabName

                    anchors.fill: parent
                    anchors.leftMargin: 10

                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                    font.pointSize: Qt.application.font.pointSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

                Text {
                    id: text_LabType

                    anchors.fill: parent
                    anchors.leftMargin: 10

                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                    font.pointSize: Qt.application.font.pointSize * 1
                    elide: Text.ElideRight
                }
            }

            UFO_TextField {
                id: ufo_TextField_LabTestConductDate

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                onTextEdited: {
                    // Notify Model:
                    root.dateChanged()
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
                    // Notify Model:
                    root.removeClicked()
                }
            }
        }

        ScrollView {
            id: scrollView

            Layout.fillWidth: true
            Layout.preferredHeight: 150

            visible: ufo_Button_Expand.checked

            ScrollBar.vertical: UFO_ScrollBar {
                parent: scrollView

                x: scrollView.mirrored ? 0 : scrollView.width - width
                y: scrollView.topPadding

                height: scrollView.availableHeight

                active: scrollView.ScrollBar.horizontal.active
            }

            UFO_TextArea {
                id: ufo_TextArea_Outcome

                enabled: (Database.connectionStatus === true) ? true : false

                onEditingFinished: {
                    // Notify Model:
                    root.outcomeChanged()
                }
            }
        }
    }
}
