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
    property alias patientGender: comboBox_Gender.currentText
    property alias patientMaritalStatus: comboBox_MaritalStatus.currentText
    property alias patientNumberOfPreviousVisits: textField_NumberOfPreviousVisits.text
    property alias patientFirstVisitDate: textField_FirstVisitDate.text
    property alias patientRecentVisitDate: textField_RecentVisitDate.text
    property alias patientServicePrice: textField_ServicePrice.text

    implicitWidth: 200
    implicitHeight: ufo_GroupBox.implicitHeight

    UFO_GroupBox {
        id: ufo_GroupBox

        anchors.fill: parent

        title: qsTr("اطلاعات پایه")
        contentSpacing: 2

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.margins: 15

            columns: 2
            rows: 20

            columnSpacing: 5
            rowSpacing: 7

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 0
                Layout.columnSpan: 2
                Layout.row: 0

                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Background"])

                Text {
                    id: text_PatientID

                    anchors.fill: parent

                    text: qsTr("شماره پرونده ()")

                    verticalAlignment: Text.AlignVCenter

                    color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
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

                        text_PatientID.text = qsTr("شماره پرونده (") + Database.getPatientDataMap()["patient_id"] + qsTr(")");
                    }
                }
            }

            Text {
                Layout.fillWidth: true

                Layout.column: 1
                Layout.row: 1

                Layout.topMargin: 7

                text: qsTr("نام")

                verticalAlignment: Text.AlignBottom

                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_FirstName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 1
                Layout.row: 2

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

                Layout.column: 0
                Layout.row: 1

                Layout.topMargin: 7

                text: qsTr("نام خانوادگی")

                verticalAlignment: Text.AlignBottom

                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_LastName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 0
                Layout.row: 2

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

            Text {
                Layout.fillWidth: true

                Layout.column: 1
                Layout.row: 3

                text: qsTr("سال تولد")

                verticalAlignment: Text.AlignBottom

                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_BirthYear

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 1
                Layout.row: 4

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

                Layout.column: 0
                Layout.row: 3

                text: qsTr("سن")

                verticalAlignment: Text.AlignBottom

                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 0
                Layout.row: 4

                enabled: (Database.connectionStatus === true) ? true : false

                readOnly: true
                horizontalAlignment: Text.AlignRight
                text: (textField_BirthYear.text.trim() === "") ? "0" : Date.calculateJalaliAge(parseInt(textField_BirthYear.text.trim(), 10))
            }

            Text {
                Layout.fillWidth: true

                Layout.column: 0
                Layout.columnSpan: 2
                Layout.row: 5

                text: qsTr("شماره تلفن")

                verticalAlignment: Text.AlignBottom

                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_PhoneNumber

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 0
                Layout.columnSpan: 2
                Layout.row: 6

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

                Layout.column: 1
                Layout.row: 7

                Layout.topMargin: 25

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

                Layout.column: 1
                Layout.row: 8

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

                Layout.column: 0
                Layout.row: 7

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

                Layout.column: 0
                Layout.row: 8

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
                                comboBox_Gender.currentIndex = 0;
                                break;
                            case "مجرد":
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

                Layout.column: 0
                Layout.columnSpan: 2
                Layout.row: 9

                Layout.topMargin: 25

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

                Layout.column: 0
                Layout.columnSpan: 2
                Layout.row: 10

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
                Layout.fillWidth: true

                Layout.column: 1
                Layout.row: 11

                text: qsTr("تاریخ اولین بازدید")

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                verticalAlignment: Text.AlignBottom

                font.pixelSize: Qt.application.font.pixelSize * 1
                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_FirstVisitDate

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 1
                Layout.row: 12

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
                Layout.fillWidth: true

                Layout.column: 0
                Layout.row: 11

                text: qsTr("زمان گذشته از اولین بازدید")

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                verticalAlignment: Text.AlignBottom

                font.pixelSize: Qt.application.font.pixelSize * 1
                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_DifferenceFirstDate

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 0
                Layout.row: 12

                enabled: (Database.connectionStatus === true) ? true : false

                horizontalAlignment: Text.AlignRight

                readOnly: true

                Connections {
                    target: textField_FirstVisitDate

                    // TODO: (Saviz): Add trim() to texts:
                    function onTextChanged() {

                        if (textField_FirstVisitDate.text.match(/^[12]\d{3}-[01]\d-[0-3]\d$/)) { // Validate the format
                            const year = textField_FirstVisitDate.text.substring(0, 4);   // Extract year
                            const month = textField_FirstVisitDate.text.substring(5, 7); // Extract month
                            const day = textField_FirstVisitDate.text.substring(8, 10);  // Extract day

                            textField_DifferenceFirstDate.text = Date.differenceToDateJalali(year, month, day);

                            return;
                        }

                        textField_DifferenceFirstDate.clear();
                    }

                    function onTextEdited() {

                        if (textField_FirstVisitDate.text.match(/^[12]\d{3}-[01]\d-[0-3]\d$/)) { // Validate the format
                            const year = textField_FirstVisitDate.text.substring(0, 4);   // Extract year
                            const month = textField_FirstVisitDate.text.substring(5, 7); // Extract month
                            const day = textField_FirstVisitDate.text.substring(8, 10);  // Extract day

                            textField_DifferenceFirstDate.text = Date.differenceToDateJalali(year, month, day);

                            return;
                        }

                        textField_DifferenceFirstDate.clear();
                    }
                }
            }

            Text {
                Layout.fillWidth: true

                Layout.column: 1
                Layout.row: 13

                text: qsTr("تاریخ آخرین بازدید")

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                verticalAlignment: Text.AlignBottom

                font.pixelSize: Qt.application.font.pixelSize * 1
                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_RecentVisitDate

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 1
                Layout.row: 14

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
                Layout.fillWidth: true

                Layout.column: 0
                Layout.row: 13

                text: qsTr("زمان گذشته از آخرین بازدید")

                elide: Text.ElideRight
                wrapMode: Text.NoWrap

                verticalAlignment: Text.AlignBottom

                font.pixelSize: Qt.application.font.pixelSize * 1
                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            UFO_TextField {
                id: textField_DifferenceRecentDate

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                Layout.column: 0
                Layout.row: 14

                enabled: (Database.connectionStatus === true) ? true : false

                horizontalAlignment: Text.AlignRight

                readOnly: true

                Connections {
                    target: textField_RecentVisitDate

                    // TODO: (Saviz): Add trim() to texts:
                    function onTextChanged() {

                        if (textField_RecentVisitDate.text.match(/^[12]\d{3}-[01]\d-[0-3]\d$/)) { // Validate the format
                            const year = textField_RecentVisitDate.text.substring(0, 4);   // Extract year
                            const month = textField_RecentVisitDate.text.substring(5, 7); // Extract month
                            const day = textField_RecentVisitDate.text.substring(8, 10);  // Extract day

                            textField_DifferenceRecentDate.text = Date.differenceToDateJalali(year, month, day);

                            return;
                        }

                        textField_RecentVisitDate.clear();
                    }

                    function onTextEdited() {

                        if (textField_RecentVisitDate.text.match(/^[12]\d{3}-[01]\d-[0-3]\d$/)) { // Validate the format
                            const year = textField_RecentVisitDate.text.substring(0, 4);   // Extract year
                            const month = textField_RecentVisitDate.text.substring(5, 7); // Extract month
                            const day = textField_RecentVisitDate.text.substring(8, 10);  // Extract day

                            textField_DifferenceRecentDate.text = Date.differenceToDateJalali(year, month, day);

                            return;
                        }

                        textField_RecentVisitDate.clear();
                    }
                }
            }

            Text {
                Layout.fillWidth: true

                Layout.topMargin: 25

                Layout.column: 0
                Layout.columnSpan: 2
                Layout.row: 15

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

                Layout.column: 0
                Layout.columnSpan: 2
                Layout.row: 16

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
