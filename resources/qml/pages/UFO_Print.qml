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

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("توجه داشته باشید که جدیدترین داده‌ها مستقیماً از پایگاه داده بازیابی می‌شوند. بنابراین، هر تغییری باید قبل از چاپ به پایگاه داده ارسال شود.")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            verticalAlignment: Text.AlignVCenter

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

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

            onClicked: {
                let id = parseInt(textField_PatientID.text.trim(), 10);

                if(isNaN(id)) {
                    return;
                }

                Printer.setPatientID(id);
                Printer.printPatientData();
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
