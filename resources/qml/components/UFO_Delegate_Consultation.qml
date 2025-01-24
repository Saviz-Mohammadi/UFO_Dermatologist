import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

// TODO: I think maybe a better way to do this, is to have a dialog or something popup and enable editing the information, and then have a edit button and have
// the date and text field be part of the expandable. this way not only is it better to look and interact with, but we can also guarante that the action of editing is complete.

Item {
    id: root

    property alias consultantName: text_ConsultantName.text
    property alias consultationConductedDate: ufo_TextField_ConsultationConductDate.text
    property alias consultationOutcome: ufo_TextArea_Outcome.text

    signal removeClicked
    signal dateChanged
    signal outcomeChanged

    implicitWidth: 200
    implicitHeight: ufo_Button_Expand.checked ? expandedHeight : collapsedHeight

    property int collapsedHeight: 35 // Adjust based on your collapsed layout
    property int expandedHeight: 40 + scrollView.Layout.preferredHeight // Adjust based on expanded content

    ColumnLayout {
        anchors.fill: parent

        spacing: 5

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

                text: checked ? qsTr("Collapse") : qsTr("Expand")
                icon.source: checked ? "./../../icons/Google icons/arrow_drop_up.svg" : "./../../icons/Google icons/arrow_drop_down.svg"
            }

            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

                Text {
                    id: text_ConsultantName

                    anchors.fill: parent
                    anchors.leftMargin: 10

                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
                    font.pointSize: Qt.application.font.pointSize * 1
                    elide: Text.ElideRight
                }
            }

            UFO_TextField {
                id: ufo_TextField_ConsultationConductDate

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
