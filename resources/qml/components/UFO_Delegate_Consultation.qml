import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

Item {
    id: root

    property alias consultantName: text_ConsultantName.text
    property alias consultationConductedDate: ufo_TextField_ConsultationConductDate.text
    property alias consultationOutcome: ufo_TextArea_Outcome.text

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

            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

                Text {
                    id: text_ConsultantName

                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
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
                svg: "./../../icons/Google icons/delete.svg"

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
