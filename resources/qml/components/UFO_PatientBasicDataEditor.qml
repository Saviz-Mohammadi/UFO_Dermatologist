import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components"

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0
import Date 1.0

Item {
    id: root

    property alias patientFirstName: textField_FirstName.text
    property alias patientLastName: textField_LastName.text
    property alias patientBirthYear: textField_BirthYear.text
    property alias patientPhoneNumber: textField_PhoneNumber.text
    property alias patientEmail: textField_Email.text
    property alias patientGender: comboBox_Gender.currentText
    property alias patientMaritalStatus: comboBox_MaritalStatus.currentText
    property alias patientNumberOfPreviousVisits: textField_NumberOfPreviousVisits.text
    property alias patientFirstVisitDate: textField_FirstVisitDate.text
    property alias patientRecentVisitDate: textField_RecentVisitDate.text
    property alias patientExpectedVisitDate: textField_ExpectedVisitDate.text
    property alias patientServicePrice: textField_ServicePrice.text

    implicitWidth: 200
    implicitHeight: ufo_GroupBox.implicitHeight

    UFO_GroupBox {
        id: ufo_GroupBox

        anchors.fill: parent

        title: qsTr("اطلاعات پایه")
        contentSpacing: 2

        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: 550

            Layout.topMargin: 20
            Layout.bottomMargin: 20

            contentWidth: -1

            ColumnLayout {
                anchors.fill: parent

                anchors.leftMargin: 20
                anchors.rightMargin: 20

                Text {
                    Layout.fillWidth: true

                    text: qsTr("نام")

                    verticalAlignment: Text.AlignBottom

                    color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
                }

                UFO_TextField {
                    id: textField_FirstName

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    enabled: (Database.connectionStatus === true) ? true : false

                    validator: RegularExpressionValidator {
                        regularExpression: /^[A-Za-z]+$/
                    }

                    Connections {
                        target: Database

                        function onQueryExecuted(type, success, message) {
                            if(type !== Database.QueryType.SELECT) {
                                return;
                            }

                            if(success === false) {
                                return;
                            }

                            textField_FirstName.text = Database.getPatientDataMap()["first_name"];
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true

                    text: qsTr("نام خانوادگی")

                    verticalAlignment: Text.AlignBottom

                    color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
                }

                UFO_TextField {
                    id: textField_LastName

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    enabled: (Database.connectionStatus === true) ? true : false

                    validator: RegularExpressionValidator {
                        regularExpression: /^[A-Za-z]+$/
                    }

                    Connections {
                        target: Database

                        function onQueryExecuted(type, success, message) {
                            if(type !== Database.QueryType.SELECT) {
                                return;
                            }

                            if(success === false) {
                                return;
                            }

                            textField_LastName.text = Database.getPatientDataMap()["last_name"];
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true

                    spacing: 20

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        Layout.preferredWidth: 30

                        text: (textField_BirthYear.text.trim() === "") ? " >> سن " + "(0)" : " >> سن " + "(" + Date.calculateJalaliAge(parseInt(textField_BirthYear.text.trim(), 10)) + ")"

                        verticalAlignment: Text.AlignBottom

                        color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
                    }

                    Text {
                        Layout.preferredWidth: 30

                        text: qsTr("سال تولد")

                        verticalAlignment: Text.AlignBottom

                        color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
                    }
                }

                UFO_TextField {
                    id: textField_BirthYear

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    enabled: (Database.connectionStatus === true) ? true : false

                    horizontalAlignment: Text.AlignRight

                    validator: RegularExpressionValidator {
                        regularExpression: /^[1-9]\d*$/
                    }

                    Connections {
                        target: Database

                        function onQueryExecuted(type, success, message) {
                            if(type !== Database.QueryType.SELECT) {
                                return;
                            }

                            if(success === false) {
                                return;
                            }

                            textField_BirthYear.text = Database.getPatientDataMap()["birth_year"];
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true

                    text: qsTr("شماره تلفن")

                    verticalAlignment: Text.AlignBottom

                    color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
                }

                UFO_TextField {
                    id: textField_PhoneNumber

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    enabled: (Database.connectionStatus === true) ? true : false

                    horizontalAlignment: Text.AlignRight

                    validator: RegularExpressionValidator {
                        regularExpression: /^\+\d{1,3} \(\d{3}\) \d{3}-\d{4}$/
                    }

                    Connections {
                        target: Database

                        function onQueryExecuted(type, success, message) {
                            if(type !== Database.QueryType.SELECT) {
                                return;
                            }

                            if(success === false) {
                                return;
                            }

                            textField_PhoneNumber.text = Database.getPatientDataMap()["phone_number"];
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true

                    text: qsTr("آدرس ایمیل")

                    verticalAlignment: Text.AlignBottom

                    color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
                }

                UFO_TextField {
                    id: textField_Email

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    enabled: (Database.connectionStatus === true) ? true : false

                    horizontalAlignment: Text.AlignRight

                    validator: RegularExpressionValidator {
                        regularExpression: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
                    }

                    Connections {
                        target: Database

                        function onQueryExecuted(type, success, message) {
                            if(type !== Database.QueryType.SELECT) {
                                return;
                            }

                            if(success === false) {
                                return;
                            }

                            textField_Email.text = Database.getPatientDataMap()["email"];
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
                        target: Database

                        function onQueryExecuted(type, success, message) {
                            if(type !== Database.QueryType.SELECT) {
                                return;
                            }

                            if(success === false) {
                                return;
                            }

                            switch (Database.getPatientDataMap()["gender"]) {
                                case "نامشخص":
                                    comboBox_Gender.currentIndex = 0;
                                    break;
                                case "مرد":
                                    comboBox_Gender.currentIndex = 1;
                                    break;
                                default:
                                    comboBox_Gender.currentIndex = 2;
                            };
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true

                    Layout.topMargin: 25

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
                        target: Database

                        function onQueryExecuted(type, success, message) {
                            if(type !== Database.QueryType.SELECT) {
                                return;
                            }

                            if(success === false) {
                                return;
                            }

                            switch (Database.getPatientDataMap()["marital_status"]) {
                                case "نامشخص":
                                    comboBox_MaritalStatus.currentIndex = 0;
                                    break;
                                case "مجرد":
                                    comboBox_MaritalStatus.currentIndex = 1;
                                    break;
                                default:
                                    comboBox_MaritalStatus.currentIndex = 2;
                            };
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

                    text: qsTr("تعداد بازدیدهای قبلی")

                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap

                    verticalAlignment: Text.AlignBottom

                    font.pixelSize: Qt.application.font.pixelSize * 1
                    color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
                }

                UFO_TextField {
                    id: textField_NumberOfPreviousVisits

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    enabled: (Database.connectionStatus === true) ? true : false

                    horizontalAlignment: Text.AlignRight

                    validator: RegularExpressionValidator {
                        regularExpression: /^[0-9]\d*$/
                    }

                    Connections {
                        target: Database

                        function onQueryExecuted(type, success, message) {
                            if(type !== Database.QueryType.SELECT) {
                                return;
                            }

                            if(success === false) {
                                return;
                            }

                            textField_NumberOfPreviousVisits.text = Database.getPatientDataMap()["number_of_previous_visits"];
                        }
                    }
                }

                Text {
                    id: text_FirstVisitDate

                    Layout.fillWidth: true

                    text: qsTr("تاریخ اولین بازدید")

                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap

                    verticalAlignment: Text.AlignBottom

                    font.pixelSize: Qt.application.font.pixelSize * 1
                    color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])

                    Connections {
                        target: textField_FirstVisitDate

                        // TODO: (Saviz): Add trim() to texts:
                        function onTextChanged() {

                            if (textField_FirstVisitDate.text.match(/^[12]\d{3}-[01]\d-[0-3]\d$/)) { // Validate the format
                                const year = textField_FirstVisitDate.text.substring(0, 4);   // Extract year
                                const month = textField_FirstVisitDate.text.substring(5, 7); // Extract month
                                const day = textField_FirstVisitDate.text.substring(8, 10);  // Extract day

                                text_FirstVisitDate.text = "تاریخ اولین بازدید" + " " + Date.differenceToDateJalali(year, month, day);

                                return;
                            }

                            text_FirstVisitDate.text = "تاریخ اولین بازدید";
                        }

                        function onTextEdited() {

                            if (textField_FirstVisitDate.text.match(/^[12]\d{3}-[01]\d-[0-3]\d$/)) { // Validate the format
                                const year = textField_FirstVisitDate.text.substring(0, 4);   // Extract year
                                const month = textField_FirstVisitDate.text.substring(5, 7); // Extract month
                                const day = textField_FirstVisitDate.text.substring(8, 10);  // Extract day

                                text_FirstVisitDate.text = "تاریخ اولین بازدید" + " " + Date.differenceToDateJalali(year, month, day);

                                return;
                            }

                            text_FirstVisitDate.text = "تاریخ اولین بازدید";
                        }
                    }
                }

                UFO_TextField {
                    id: textField_FirstVisitDate

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    enabled: (Database.connectionStatus === true) ? true : false

                    horizontalAlignment: Text.AlignRight

                    validator: RegularExpressionValidator {
                        regularExpression: /^[12]\d{3}-[01]\d-[0-3]\d$/
                    }

                    Connections {
                        target: Database

                        function onQueryExecuted(type, success, message) {
                            if(type !== Database.QueryType.SELECT) {
                                return;
                            }

                            if(success === false) {
                                return;
                            }

                            textField_FirstVisitDate.text = Database.getPatientDataMap()["first_visit_date"];
                        }
                    }
                }

                Text {
                    id: text_RecentVisitDate

                    Layout.fillWidth: true

                    text: qsTr("تاریخ آخرین بازدید")

                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap

                    verticalAlignment: Text.AlignBottom

                    font.pixelSize: Qt.application.font.pixelSize * 1
                    color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])

                    Connections {
                        target: textField_RecentVisitDate

                        // TODO: (Saviz): Add trim() to texts:
                        function onTextChanged() {

                            if (textField_RecentVisitDate.text.match(/^[12]\d{3}-[01]\d-[0-3]\d$/)) { // Validate the format
                                const year = textField_RecentVisitDate.text.substring(0, 4);   // Extract year
                                const month = textField_RecentVisitDate.text.substring(5, 7); // Extract month
                                const day = textField_RecentVisitDate.text.substring(8, 10);  // Extract day

                                text_RecentVisitDate.text = "تاریخ آخرین بازدید" + " " + Date.differenceToDateJalali(year, month, day);

                                return;
                            }

                            text_RecentVisitDate.text = "تاریخ آخرین بازدید";
                        }

                        function onTextEdited() {

                            if (textField_RecentVisitDate.text.match(/^[12]\d{3}-[01]\d-[0-3]\d$/)) { // Validate the format
                                const year = textField_RecentVisitDate.text.substring(0, 4);   // Extract year
                                const month = textField_RecentVisitDate.text.substring(5, 7); // Extract month
                                const day = textField_RecentVisitDate.text.substring(8, 10);  // Extract day

                                text_RecentVisitDate.text = "تاریخ آخرین بازدید" + " " + Date.differenceToDateJalali(year, month, day);

                                return;
                            }

                            text_RecentVisitDate.text = "تاریخ آخرین بازدید";
                        }
                    }
                }

                UFO_TextField {
                    id: textField_RecentVisitDate

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    enabled: (Database.connectionStatus === true) ? true : false

                    horizontalAlignment: Text.AlignRight

                    validator: RegularExpressionValidator {
                        regularExpression: /^[12]\d{3}-[01]\d-[0-3]\d$/
                    }

                    Connections {
                        target: Database

                        function onQueryExecuted(type, success, message) {
                            if(type !== Database.QueryType.SELECT) {
                                return;
                            }

                            if(success === false) {
                                return;
                            }

                            textField_RecentVisitDate.text = Database.getPatientDataMap()["recent_visit_date"];
                        }
                    }
                }

                Text {
                    id: text_ExpectedVisitDate

                    Layout.fillWidth: true

                    text: qsTr("تاریخ مورد انتظار ویزیت")

                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap

                    verticalAlignment: Text.AlignBottom

                    font.pixelSize: Qt.application.font.pixelSize * 1
                    color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])

                    Connections {
                        target: textField_ExpectedVisitDate

                        // TODO: (Saviz): Add trim() to texts:
                        function onTextChanged() {

                            if (textField_ExpectedVisitDate.text.match(/^[12]\d{3}-[01]\d-[0-3]\d$/)) { // Validate the format
                                const year = textField_ExpectedVisitDate.text.substring(0, 4);   // Extract year
                                const month = textField_ExpectedVisitDate.text.substring(5, 7); // Extract month
                                const day = textField_ExpectedVisitDate.text.substring(8, 10);  // Extract day

                                text_ExpectedVisitDate.text = "تاریخ مورد انتظار ویزیت" + " " + Date.differenceToDateJalali(year, month, day);

                                return;
                            }

                            text_ExpectedVisitDate.text = "تاریخ مورد انتظار ویزیت";
                        }

                        function onTextEdited() {

                            if (textField_ExpectedVisitDate.text.match(/^[12]\d{3}-[01]\d-[0-3]\d$/)) { // Validate the format
                                const year = textField_ExpectedVisitDate.text.substring(0, 4);   // Extract year
                                const month = textField_ExpectedVisitDate.text.substring(5, 7); // Extract month
                                const day = textField_ExpectedVisitDate.text.substring(8, 10);  // Extract day

                                text_ExpectedVisitDate.text = "تاریخ مورد انتظار ویزیت" + " " + Date.differenceToDateJalali(year, month, day);

                                return;
                            }

                            text_ExpectedVisitDate.text = "تاریخ مورد انتظار ویزیت";
                        }
                    }
                }

                UFO_TextField {
                    id: textField_ExpectedVisitDate

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    enabled: (Database.connectionStatus === true) ? true : false

                    horizontalAlignment: Text.AlignRight

                    validator: RegularExpressionValidator {
                        regularExpression: /^[12]\d{3}-[01]\d-[0-3]\d$/
                    }

                    Connections {
                        target: Database

                        function onQueryExecuted(type, success, message) {
                            if(type !== Database.QueryType.SELECT) {
                                return;
                            }

                            if(success === false) {
                                return;
                            }

                            textField_ExpectedVisitDate.text = Database.getPatientDataMap()["expected_visit_date"];
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

                    text: qsTr("قیمت خدمات")

                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap

                    verticalAlignment: Text.AlignBottom

                    font.pixelSize: Qt.application.font.pixelSize * 1
                    color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
                }

                UFO_TextField {
                    id: textField_ServicePrice

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    enabled: (Database.connectionStatus === true) ? true : false

                    horizontalAlignment: Text.AlignRight

                    validator: RegularExpressionValidator {
                        regularExpression: /^[0-9]*\.?[0-9]+$/
                    }

                    Connections {
                        target: Database

                        function onQueryExecuted(type, success, message) {
                            if(type !== Database.QueryType.SELECT) {
                                return;
                            }

                            if(success === false) {
                                return;
                            }

                            textField_ServicePrice.text = Database.getPatientDataMap()["service_price"];
                        }
                    }
                }
            }
        }
    }
}
