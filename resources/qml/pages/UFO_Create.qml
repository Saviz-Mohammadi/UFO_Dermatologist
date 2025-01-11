import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components"

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

UFO_Page {
    id: root

    signal searchMatchedNewPatient

    title: qsTr("ایجاد")
    contentSpacing: 25

    UFO_GroupBox {
        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("اطلاعات بیمار")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 20
            Layout.bottomMargin: 0
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            text: qsTr("اطلاعات ضروری را وارد کرده و روی «ایجاد» کلیک کنید تا بیمار جدیدی را به پایگاه داده وارد کنید. فیلدهای علامت‌گذاری شده با نماد ستاره الزامی هستند.")
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.margins: 15

            Text {
                Layout.fillWidth: true

                text: qsTr("نام*")

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                verticalAlignment: Text.AlignBottom

                font.pixelSize: Qt.application.font.pixelSize * 1
                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_FirstName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^[\p{L}]+$/u
                }

                Connections {
                    target: ufo_Button_Clear

                    function onClearButtonClicked() {
                        textField_FirstName.clear();
                    }
                }
            }

            Text {
                Layout.fillWidth: true

                text: qsTr("نام خانوادگی*")

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                verticalAlignment: Text.AlignBottom

                font.pixelSize: Qt.application.font.pixelSize * 1
                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_LastName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^[\p{L}]+$/u
                }

                Connections {
                    target: ufo_Button_Clear

                    function onClearButtonClicked() {
                        textField_LastName.clear();
                    }
                }
            }

            Text {
                Layout.fillWidth: true

                text: qsTr("سال تولد*")

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                verticalAlignment: Text.AlignBottom

                font.pixelSize: Qt.application.font.pixelSize * 1
                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_BirthYear

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^[1-9]\d*$/
                }

                Connections {
                    target: ufo_Button_Clear

                    function onClearButtonClicked() {
                        textField_BirthYear.clear();
                    }
                }
            }

            Text {
                Layout.fillWidth: true

                text: qsTr("شماره تلفن*")

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                verticalAlignment: Text.AlignBottom

                font.pixelSize: Qt.application.font.pixelSize * 1
                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_PhoneNumber

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 1
                Layout.row: 1

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^\+\d{1,3} \(\d{3}\) \d{3}-\d{4}$/
                }

                Connections {
                    target: ufo_Button_Clear

                    function onClearButtonClicked() {
                        textField_PhoneNumber.clear();
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1

                Layout.topMargin: 35
                Layout.bottomMargin: 25

                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Separator"])
            }

            Text {
                Layout.fillWidth: true

                text: qsTr("جنسیت")

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                verticalAlignment: Text.AlignBottom

                font.pixelSize: Qt.application.font.pixelSize * 1
                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_ComboBox {
                id: comboBox_Gender

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false
                model: ["نامشخص", "مرد", "زن"]

                Connections {
                    target: ufo_Button_Clear

                    function onClearButtonClicked() {
                        comboBox_Gender.currentIndex = 0;
                    }
                }
            }

            Text {
                Layout.fillWidth: true

                text: qsTr("وضعیت تأهل")

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                verticalAlignment: Text.AlignBottom

                font.pixelSize: Qt.application.font.pixelSize * 1
                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_ComboBox {
                id: comboBox_MaritalStatus

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false
                model: ["نامشخص", "مجرد", "متاهل"]

                Connections {
                    target: ufo_Button_Clear

                    function onClearButtonClicked() {
                        comboBox_MaritalStatus.currentIndex = 0;
                    }
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
            id: ufo_Button_Clear

            signal clearButtonClicked

            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus === true) ? true : false

            text: qsTr("پاک کردن")
            icon.source: "./../../icons/Google icons/delete.svg"

            onClicked: {
                ufo_Button_Clear.clearButtonClicked();
            }
        }

        UFO_Button {
            id: ufo_Button_Insert

            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus === true) ? true : false

            text: qsTr("ایجاد")
            icon.source: "./../../icons/Google icons/person_add.svg"

            Connections {
                target: ufo_Dialog

                function onAccepted() {
                    if(ufo_Dialog.callbackIdentifier === "<UFO_Create>: Required fields not provided") {
                        ufo_Dialog.close();

                        return;
                    }
                }
            }

            onClicked: {
                let emptyFieldWasDetected = textField_FirstName.text.trim() === "" || textField_LastName.text.trim() === "" || textField_PhoneNumber.text.trim() === "" || textField_BirthYear.text.trim() === "";


                if(emptyFieldWasDetected) {
                    let message = "لطفاً قبل از ادامه برای اضافه کردن بیمار جدید، اطمینان حاصل کنید که فیلدهای زیر دارای ورودی معتبر هستند:<br>";

                    message += "<ul>";


                    if(textField_FirstName.text === "") {
                        message += "<li>نام</li>";
                    }

                    if(textField_LastName.text === "") {
                        message += "<li>نام خانوادگی</li>";
                    }

                    if(textField_PhoneNumber.text === "") {
                        message += "<li>شماره تلفن</li>";
                    }

                    if(textField_BirthYear.text === "") {
                        message += "<li>سال تولد</li>";
                    }

                    message += "</ul>";


                    ufo_Dialog.titleString = "<b>هشدار! فیلدهای خالی شناسایی شدند!<b>";
                    ufo_Dialog.messageString = message;
                    ufo_Dialog.callbackIdentifier = "<UFO_Create>: Required fields not provided";
                    ufo_Dialog.hasAccept = true;
                    ufo_Dialog.hasReject = false;
                    ufo_Dialog.acceptButtonText = qsTr("OK")
                    ufo_Dialog.rejectButtonText = qsTr("Cancel")
                    ufo_Dialog.open();


                    return;
                }

                let firstName = textField_FirstName.text.trim();
                let lastName = textField_LastName.text.trim();
                let birthYear = parseInt(textField_BirthYear.text.trim(), 10);
                let phoneNumber = textField_PhoneNumber.text;
                let gender = comboBox_Gender.currentText;
                let maritalStatus = comboBox_MaritalStatus.currentText;


                Database.createPatient(firstName, lastName, birthYear, phoneNumber, gender, maritalStatus);
            }
        }
    }

    UFO_OperationResult {
        id: ufo_OperationResult

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        Connections {
            target: Database

            function onQueryExecuted(type, success, message) {
                if(type !== Database.QueryType.CREATE) {
                    return;
                }

                if(success === true) {
                    ufo_OperationResult.svg = "./../../icons/Google icons/check_box.svg";
                    ufo_OperationResult.state = true;
                    ufo_OperationResult.displayMessage(message, 7000);


                    return;
                }

                if(success === false) {
                    ufo_OperationResult.svg = "./../../icons/Google icons/error.svg";
                    ufo_OperationResult.state = false;
                    ufo_OperationResult.displayMessage(message, 7000);


                    return;
                }
            }
        }
    }
}
