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

    title: qsTr("Create Patient")
    contentSpacing: 20

    // Personal Information
    UFO_GroupBox {
        id: ufo_GroupBox_PersonalInformation

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Personal Information")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.topMargin: 20
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("To create a new patient record, ensure all input fields are filled with the required data. Once all information has been verified, click the 'Create' button to proceed. Missing data in any field will trigger a warning message. You can clear the information fields at any time by pressing the 'Clear' button.")

            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        RowLayout {
            Layout.fillWidth: true

            Layout.topMargin: 7
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            spacing: 10

            UFO_TextField {
                id: textField_FirstName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                placeholderText: qsTr("First name")

                Connections {
                    target: ufo_Button_Clear

                    function onClearButtonClicked() {
                        textField_FirstName.clear();
                    }
                }
            }

            UFO_TextField {
                id: textField_LastName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                placeholderText: qsTr("Last name")

                Connections {
                    target: ufo_Button_Clear

                    function onClearButtonClicked() {
                        textField_LastName.clear();
                    }
                }
            }

            UFO_ComboBox {
                id: comboBox_Gender

                Layout.preferredWidth: 150
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                model: ["Male", "Female"]

                Connections {
                    target: ufo_Button_Clear

                    function onClearButtonClicked() {
                        comboBox_Gender.currentIndex = 0;
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Layout.topMargin: 7
            Layout.bottomMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            spacing: 10

            UFO_TextField {
                id: textField_Age

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                placeholderText: qsTr("Age")

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^((1[0-4][0-9])|([1-9][0-9])|[0-9]|150)$/ // Ranges between (0 – 150)
                }

                Connections {
                    target: ufo_Button_Clear

                    function onClearButtonClicked() {
                        textField_Age.clear();
                    }
                }
            }

            UFO_TextField {
                id: textField_PhoneNumber

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                placeholderText: qsTr("Phone Number")

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^\+\d{1,3} \(\d{3}\) \d{3}-\d{4}$/ // Format: +1 (555) 921-1222 -> [country code] [(Area code)] [Phone number]
                }

                Connections {
                    target: ufo_Button_Clear

                    function onClearButtonClicked() {
                        textField_PhoneNumber.clear();
                    }
                }
            }

            UFO_ComboBox {
                id: comboBox_MaritalStatus

                Layout.preferredWidth: 150
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                model: ["Single", "Married", "Divorced", "Widowed"]

                Connections {
                    target: ufo_Button_Clear

                    function onClearButtonClicked() {
                        comboBox_MaritalStatus.currentIndex = 0;
                    }
                }
            }
        }
    }

    // Create | Clear
    RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: 10

        Item {
            Layout.fillWidth: true
        }

        UFO_Button {
            id: ufo_Button_Clear

            signal clearButtonClicked

            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus === true) ? true : false

            text: qsTr("Clear")
            svg: "./../../icons/Google icons/delete.svg"

            onClicked: {
                ufo_Button_Clear.clearButtonClicked();
            }
        }

        UFO_Button {
            id: ufo_Button_Insert

            property var context: ({})

            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus === true) ? true : false

            text: qsTr("Create")
            svg: "./../../icons/Google icons/person_add.svg"

            function setContextElement(key, value) {
                ufo_Button_Insert.context[key] = value;
            }

            Connections {
                target: ufo_Dialog

                function onAccepted() {
                    if(ufo_Dialog.callbackIdentifier === "<UFO_Create>: Input not provided") {
                        ufo_Dialog.close();

                        return;
                    }

                    if(ufo_Dialog.callbackIdentifier === "<UFO_Create>: Potential search matches found") {
                        ufo_Dialog.close();
                        Database.createPatient(ufo_Button_Insert.context["first_name"], ufo_Button_Insert.context["last_name"], ufo_Button_Insert.context["age"], ufo_Button_Insert.context["phone_number"], ufo_Button_Insert.context["gender"], ufo_Button_Insert.context["marital_status"]);

                        return;
                    }
                }
            }

            Connections {
                target: ufo_Dialog

                function onRejected() {
                    if(ufo_Dialog.callbackIdentifier === "<UFO_Create>: Potential search matches found") {
                        ufo_Dialog.close();
                        root.searchMatchedNewPatient();

                        return;
                    }
                }
            }

            onClicked: {
                let emptyFieldWasDetected = textField_FirstName.text === "" || textField_LastName.text === "" || textField_PhoneNumber.text === "" || textField_Age.text === "";


                if(emptyFieldWasDetected) {
                    let message = "Please ensure the following fields have valid inputs before prcoceeding to add a new patient:<br>";

                    message += "<ul>";


                    if(textField_FirstName.text === "") {
                        message += "<li>First Name</li>";
                    }

                    if(textField_LastName.text === "") {
                        message += "<li>Last Name</li>";
                    }

                    if(textField_PhoneNumber.text === "") {
                        message += "<li>Phone Number</li>";
                    }

                    if(textField_Age.text === "") {
                        message += "<li>Age</li>";
                    }

                    message += "</ul>";


                    ufo_Dialog.titleString = "<b>WARNING! Empty fields detected!<b>";
                    ufo_Dialog.messageString = message;
                    ufo_Dialog.callbackIdentifier = "<UFO_Create>: Input not provided";
                    ufo_Dialog.hasAccept = true;
                    ufo_Dialog.hasReject = false;
                    ufo_Dialog.acceptButtonText = qsTr("OK")
                    ufo_Dialog.rejectButtonText = qsTr("Cancel")
                    ufo_Dialog.open();


                    return;
                }


                // Personal Information:
                ufo_Button_Insert.setContextElement("first_name", textField_FirstName.text.trim());
                ufo_Button_Insert.setContextElement("last_name", textField_LastName.text.trim());
                ufo_Button_Insert.setContextElement("age", parseInt(textField_Age.text.trim()));
                ufo_Button_Insert.setContextElement("phone_number", textField_PhoneNumber.text.trim());
                ufo_Button_Insert.setContextElement("gender", comboBox_Gender.currentText.trim());
                ufo_Button_Insert.setContextElement("marital_status", comboBox_MaritalStatus.currentText.trim());


                // Perform Search:
                Database.findPatient(ufo_Button_Insert.context["first_name"], ufo_Button_Insert.context["last_name"], ufo_Button_Insert.context["age"], ufo_Button_Insert.context["phone_number"], ufo_Button_Insert.context["gender"], ufo_Button_Insert.context["marital_status"]);

                if(Database.getSearchResultList().length === 0) {
                    Database.createPatient(ufo_Button_Insert.context["first_name"], ufo_Button_Insert.context["last_name"], ufo_Button_Insert.context["age"], ufo_Button_Insert.context["phone_number"], ufo_Button_Insert.context["gender"], ufo_Button_Insert.context["marital_status"]);

                    return;
                }


                ufo_Dialog.titleString = "<b>WARNING! Potential matches found!<b>";
                ufo_Dialog.messageString = "The application found potential already existing matches of patients. Please switch to the ";
                ufo_Dialog.callbackIdentifier = "<UFO_Create>: Potential search matches found";
                ufo_Dialog.hasAccept = true;
                ufo_Dialog.hasReject = true;
                ufo_Dialog.acceptButtonText = qsTr("Create Anyway")
                ufo_Dialog.rejectButtonText = qsTr("View Search")
                ufo_Dialog.open();
            }
        }
    }

    UFO_OperationResult {
        id: ufo_OperationResult

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        Connections {
            target: Database

            function onPatientInsertionSuccessful() {
                ufo_OperationResult.svg = "./../../icons/Google icons/check_circle.svg";
                ufo_OperationResult.displayMessage("Patient created successfully. You may now proceed to editing the patient.", 3000);
            }
        }

        Connections {
            target: Database

            function onPatientInsertionFailed() {
                ufo_OperationResult.svg = "./../../icons/Google icons/error.svg";
                ufo_OperationResult.displayMessage("Patient creation failed. You may try agian or return at another time.", 3000);
            }
        }
    }
}
