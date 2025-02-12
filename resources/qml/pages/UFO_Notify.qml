import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components"

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0
import Notifier 1.0

UFO_Page {
    id: root

    title: qsTr("ارسال پیام")
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

                Layout.topMargin: 25

                color: Qt.color(AppTheme.colors["UFO_SideBar_Text"])
                text: qsTr("نام کاربری ایمیل")

                verticalAlignment: Text.AlignBottom
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
            }

            UFO_TextField {
                id: textField_Username

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                horizontalAlignment: Text.AlignRight

                placeholderText: "address@gmail.com"
            }

            Text {
                Layout.fillWidth: true

                color: Qt.color(AppTheme.colors["UFO_SideBar_Text"])
                text: qsTr("رمز عبور")

                verticalAlignment: Text.AlignBottom
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
            }

            UFO_TextField {
                id: textField_Password

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                horizontalAlignment: Text.AlignRight

                placeholderText: "******"

                validator: RegularExpressionValidator {
                    regularExpression: /^[\p{L}]+$/u
                }
            }

            Text {
                Layout.fillWidth: true

                text: qsTr("تعداد روزهای باقی‌مانده")

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                verticalAlignment: Text.AlignBottom

                font.pixelSize: Qt.application.font.pixelSize * 1
                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_DaysLeft

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                horizontalAlignment: Text.AlignRight

                placeholderText: "1-3"

                validator: IntValidator{ bottom: 1; top: 3; }
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

            text: qsTr("ارسال")
            icon.source: "./../../icons/Google icons/send.svg"

            onClicked: {
                let username = textField_Username.text.trim();
                let password = textField_Password.text.trim();
                let daysLeft = parseInt(textField_DaysLeft.text.trim(), 10);

                // Just as a percaution:
                if(isNaN(daysLeft)) {
                    return;
                }

                onClicked: {
                    Notifier.sendEmail(daysLeft, username, password);
                }
            }
        }
    }

    UFO_OperationResult {
        id: ufo_OperationResult

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        Connections {
            target: Notifier

            function onEmailSent(success, message) {

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
