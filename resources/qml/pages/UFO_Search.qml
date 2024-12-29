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

    signal patientSelectedForEdit

    title: qsTr("Search Patients")
    contentSpacing: 20

    UFO_GroupBox {
        id: ufo_GroupBox_SearchOptions

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Search Options")
        contentSpacing: 0

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.margins: 20

            columns: 2
            rows: 5

            columnSpacing: 2
            rowSpacing: 2

            // Patient ID field, spanning all columns
            UFO_TextField {
                id: textField_PatientID

                Layout.column: 0
                Layout.row: 0
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                placeholderText: qsTr("[patient id]")
            }

            UFO_TextField {
                id: textField_PhoneNumber

                Layout.column: 1
                Layout.row: 0
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                placeholderText: qsTr("Enter phone number...")

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^\+\d{1,3} \(\d{3}\) \d{3}-\d{4}$/ // Format: +1 (555) 921-1222 -> [country code] [(Area code)] [Phone number]
                }
            }

            // First Name field, spanning the first two columns
            UFO_TextField {
                id: textField_FirstName

                Layout.column: 0
                Layout.row: 1
                Layout.fillWidth: true
                Layout.preferredHeight: 35
                Layout.topMargin: 20

                enabled: (Database.connectionStatus === true) ? true : false

                placeholderText: qsTr("[first name]")
            }

            // Last Name field, spanning the last two columns
            UFO_TextField {
                id: textField_LastName

                Layout.column: 1
                Layout.row: 1
                Layout.fillWidth: true
                Layout.preferredHeight: 35
                Layout.topMargin: 20

                enabled: (Database.connectionStatus === true) ? true : false

                placeholderText: qsTr("[last name]")
            }

            // Birth Year Start field, spanning the first two columns
            UFO_TextField {
                id: textField_BirthYearStart

                Layout.column: 0
                Layout.row: 2
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                placeholderText: qsTr("Enter birth year start...")

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^[0-9]*$/
                }

                onTextChanged: {
                    if (textField_BirthYearStart.text === "") {
                        textField_BirthYearStart.text = "0";
                    }
                }
            }

            // Birth Year End field, spanning the last two columns
            UFO_TextField {
                id: textField_BirthYearEnd

                Layout.column: 1
                Layout.row: 2
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                placeholderText: qsTr("Enter birth year end...")

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^[0-9]*$/
                }

                onTextChanged: {
                    if (textField_BirthYearStart.text === "") {
                        textField_BirthYearStart.text = "0";
                    }
                }
            }

            // Gender ComboBox
            UFO_ComboBox {
                id: comboBox_Gender

                Layout.column: 0
                Layout.row: 4
                Layout.fillWidth: true
                Layout.preferredHeight: 35
                Layout.topMargin: 20

                enabled: (Database.connectionStatus === true) ? true : false

                model: ["Unknown", "Male", "Female"]
            }

            // Gender Checkbox
            UFO_CheckBox {
                Layout.column: 1
                Layout.row: 4
                Layout.preferredWidth: 35
                Layout.preferredHeight: 35
                Layout.topMargin: 20

                text: qsTr("Check to enable field")
            }

            // Marital Status ComboBox
            UFO_ComboBox {
                id: comboBox_MaritalStatus

                Layout.column: 0
                Layout.row: 5
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                model: ["Unknown", "Single", "Married"]
            }

            // Marital Status Checkbox
            UFO_CheckBox {
                Layout.column: 1
                Layout.row: 5
                Layout.preferredWidth: 35
                Layout.preferredHeight: 35

                text: qsTr("Check to enable field")
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 20

            UFO_TextField {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("First X count")
                svg: "./../../icons/Google icons/one.svg"

                onClicked: {
                    Database.findFirstPatient()
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Last X count")
                svg: "./../../icons/Google icons/infinity.svg"

                onClicked: {
                    Database.findLastPatient()
                }
            }

            Item {
                Layout.fillWidth: true
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Clear")
                svg: "./../../icons/Google icons/delete.svg"

                onClicked: {
                    textField_FirstName.clear()
                    textField_LastName.clear()
                    textField_PhoneNumber.clear()

                    comboBox_Gender.currentIndex = 0
                    comboBox_MaritalStatus.currentIndex = 0
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Search")
                svg: "./../../icons/Google icons/person_search.svg"

                onClicked: {
                    var firstName = textField_FirstName.text.trim()
                    var lastName = textField_LastName.text.trim()
                    var birthYearStart = parseInt(textField_BirthYearStart.text.trim());
                    var birthYearEnd = parseInt(textField_BirthYearEnd.text.trim());
                    var phoneNumber = textField_PhoneNumber.text
                    var gender = comboBox_Gender.currentText
                    var maritalStatus = comboBox_MaritalStatus.currentText

                    var operationOutcome = Database.findPatient(firstName, lastName, birthYearStart, birthYearEnd, phoneNumber, "", "");

                    if(operationOutcome === false) {
                        ufo_StatusBar.displayMessage("Search operation failed!")
                    }
                }
            }
        }
    }


    UFO_GroupBox {
        id: ufo_GroupBox_SearchResults

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Search Results")
        contentSpacing: 0

        ListView {
            id: listView_SearchResults

            Layout.fillWidth: true
            Layout.preferredHeight: 450

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            spacing: 2
            clip: true

            model: ListModel { id: listModel_SearchResults }

            delegate: UFO_SearchDelegate {
                width: listView_SearchResults.width

                patientId: model.patient_id
                header: model.first_name + model.last_name
                birthYear: model.birth_year
                phoneNumber: model.phone_number
                gender: model.gender
                maritalStatus: model.marital_status
                servicePrice: model.service_price


                onEditClicked: {
                    // var operationStatus = Database.readyPatientData(model.patient_ID)


                    // if(operationStatus !== true) {
                    //     ufo_StatusBar.displayMessage("Could not make patient ready for editting!");

                    //     return;
                    // }

                    // root.patientSelectedForEdit()
                }
            }

            Connections {
                target: Database

                function onQueryExecuted(type, success, message) {
                    if(type !== Database.QueryType.SEARCH) {
                        return;
                    }

                    if(success === false) {
                        return;
                    }

                    listModel_SearchResults.clear();

                    Database.getSearchResultList().forEach(function (searchResult) {
                        listModel_SearchResults.append({
                            "patient_id": searchResult["patient_id"],
                            "first_name": searchResult["first_name"],
                            "last_name": searchResult["last_name"],
                            "birth_year": searchResult["birth_year"],
                            "phone_number": searchResult["phone_number"],
                            "gender": searchResult["gender"],
                            "marital_status": searchResult["marital_status"],
                            "service_price": searchResult["service_price"]
                        });
                    })
                }
            }
        }
    }

    UFO_OperationResult {
        id: ufo_OperationResult

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        Connections {
            target: Database

            function onQueryExecuted(type, success, message)  {
                if(type !== Database.QueryType.SEARCH) {
                    return;
                }

                if(success === true) {
                    ufo_OperationResult.svg = "./../../icons/Google icons/check_box.svg";
                    ufo_OperationResult.state = true;
                    ufo_OperationResult.displayMessage(message, 5000);

                    return;
                }

                if(success === false) {
                    ufo_OperationResult.svg = "./../../icons/Google icons/error.svg";
                    ufo_OperationResult.state = false;
                    ufo_OperationResult.displayMessage(message, 5000);

                    return;
                }
            }
        }
    }
}
