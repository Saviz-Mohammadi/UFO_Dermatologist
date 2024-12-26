import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components_ufo"

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

UFO_Page {
    id: root

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

                property bool isEmpty: false

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                placeholderText: qsTr("First name")

                onEditingFinished: {
                    if(textField_FirstName.text === "") {
                        textField_FirstName.isEmpty = true;

                        return;
                    }

                    textField_FirstName.isEmpty = false;
                }

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

        CheckBox {
            // Switch to edit mode after creation.

            text: qsTr("Edit patient after creation.")
        }

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
            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus === true) ? true : false

            text: qsTr("Create")
            svg: "./../../icons/Google icons/person_add.svg"

            onClicked: {


                // Personal Information:
                // var first_name = textField_FirstName.text.trim();
                // var last_name = textField_LastName.text.trim();
                // var age = parseInt(textField_Age.text.trim());
                // var phone_number = textField_PhoneNumber.text.trim();
                // var gender = gender = comboBox_Gender.currentText;
                // var marital_status = comboBox_MaritalStatus.currentText;

                // Display message box, if a field is missing data.

                // Clear fields once creation is done.
                // Switch to edit if need be.

                // Create patient:
                // var operationOutcome = Database.updatePatientData(first_name, last_name, age, phone_number, gender, marital_status, treatments);

                // if(operationOutcome === false) {
                //     ufo_StatusBar.displayMessage("Edit operation failed!")
                // }

                // if(operationOutcome === true) {
                //     ufo_StatusBar.displayMessage("Changes applied!")
                // }
            }
        }
    }
}
