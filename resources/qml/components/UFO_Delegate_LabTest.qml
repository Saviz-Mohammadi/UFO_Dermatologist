import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

Item {
    id: root

    property alias labName: text_LabName.text
    property alias labSpecialization: text_LabSpecialization.text
    property alias labTestDate: ufo_TextField_LabTestDate.text
    property alias labTestOutcome: ufo_TextArea_LabTestOutcome.text

    signal removeClicked
    signal dateChanged
    signal outcomeChanged

    implicitWidth: 200
    implicitHeight: ufo_Button_Expand.checked ? expandedHeight : collapsedHeight

    property int collapsedHeight: 35 // Adjust based on your collapsed layout
    property int expandedHeight: 45 + scrollView.Layout.preferredHeight + ufo_TextField_LabTestDate.height // Adjust based on expanded content

    ColumnLayout {
        anchors.fill: parent

        spacing: 5

        RowLayout {
            Layout.fillWidth: true

            spacing: 5

            UFO_Button {
                id: ufo_Button_Expand

                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                checkable: true
                checked: false

                enabled: (Database.connectionStatus === true) ? true : false

                text: checked ? qsTr("Collapse") : qsTr("Expand")
                icon.source: checked ? "./../../icons/Google icons/arrow_drop_up.svg" : "./../../icons/Google icons/arrow_drop_down.svg"
            }

            Rectangle {
                Layout.fillWidth: true
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
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

                Text {
                    id: text_LabSpecialization

                    anchors.fill: parent
                    anchors.leftMargin: 10

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
                    // Notify Model:
                    root.removeClicked()
                }
            }
        }

        UFO_TextField {
            id: ufo_TextField_LabTestDate

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus === true) ? true : false

            visible: ufo_Button_Expand.checked

            onTextChanged: {
                // Notify Model:
                root.dateChanged()
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
                id: ufo_TextArea_LabTestOutcome

                enabled: (Database.connectionStatus === true) ? true : false

                onTextChanged: {
                    // Notify Model:
                    root.outcomeChanged()
                }
            }
        }
    }
}
