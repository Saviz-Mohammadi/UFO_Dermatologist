import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components"

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0
import Printer 1.0

UFO_Page {
    id: root

    title: qsTr("چاپ")
    contentSpacing: 25

    UFO_GroupBox {
        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("تنظیمات")
        contentSpacing: 0

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.margins: 15

            Text {
                Layout.fillWidth: true

                text: qsTr("شماره پرونده")

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                verticalAlignment: Text.AlignBottom

                font.pixelSize: Qt.application.font.pixelSize * 1
                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_PatientID

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                horizontalAlignment: Text.AlignRight

                validator: RegularExpressionValidator {
                    regularExpression: /^\p{Nd}+$/
                }
            }

            // UFO_ComboBox {
            //     id: comboBox_Gender

            //     Layout.fillWidth: true
            //     Layout.preferredHeight: 35

            //     enabled: (Database.connectionStatus === true) ? true : false
            //     model: ["نامشخص", "مرد", "زن"]

            //     Connections {
            //         target: ufo_Button_Clear

            //         function onClearButtonClicked() {
            //             comboBox_Gender.currentIndex = 0;
            //         }
            //     }
            // }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: 15

        Item {
            Layout.fillWidth: true
        }

        UFO_Button {
            id: ufo_Button_Insert

            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus === true) ? true : false

            text: qsTr("چاپ")
            icon.source: "./../../icons/Google icons/print.svg"

            Connections {
                target: ufo_Dialog

                function onAccepted() {
                    if(ufo_Dialog.callbackIdentifier === "<UFO_Print>: Print PDF") {
                        ufo_Dialog.close();

                        Printer.printPatientData();

                        return;
                    }
                }

                function onRejected() {
                    if(ufo_Dialog.callbackIdentifier === "<UFO_Print>: Print PDF") {
                        ufo_Dialog.close();

                        return;
                    }
                }
            }

            onClicked: {
                let id = parseInt(textField_PatientID.text.trim(), 10);

                if(isNaN(id)) {
                    return;
                }

                Printer.setPatientID(id);

                ufo_Dialog.titleString = "<b>هشدار!<b>";
                ufo_Dialog.messageString = "هرگونه تغییر ذخیره‌نشده حذف خواهد شد. آیا می‌خواهید ادامه دهید؟";
                ufo_Dialog.callbackIdentifier = "<UFO_Print>: Print PDF";
                ufo_Dialog.hasAccept = true;
                ufo_Dialog.hasReject = true;
                ufo_Dialog.acceptButtonText = qsTr("Print PDF")
                ufo_Dialog.rejectButtonText = qsTr("Cancel")
                ufo_Dialog.open();
            }
        }
    }

    UFO_OperationResult {
        id: ufo_OperationResult

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        Connections {
            target: Printer

            function onPrintStateChanged(success, message) {

                if(success === true) {
                    ufo_OperationResult.svg = "./../../icons/Google icons/check_box.svg";
                    ufo_OperationResult.state = true;
                    ufo_OperationResult.displayMessage(message, 8000);


                    return;
                }

                if(success === false) {
                    ufo_OperationResult.svg = "./../../icons/Google icons/error.svg";
                    ufo_OperationResult.state = false;
                    ufo_OperationResult.displayMessage(message, 8000);


                    return;
                }
            }
        }
    }
}
