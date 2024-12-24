import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components_ufo"

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0


// Here is the idea: Whene ever the patienteditchanged() signal is emitted, it means that we have a new patient to edit. We reset everything, the hasChangde() bools, the text will be set to the new m_patientEdit.
// We will only visually figure out if there are any changes by nidividually checking the state of haschanged() with || (or) operators. when the changes are ready to be applied they will be applied to the m_patientedit by grabing its id which is already availbale ni the back-end due to the existance of M-patienedit itself.
// and then emitting the signal again to state that it has changed and reset everything. We will also have a reset button that enbales resetting the not already applied changes of everything by emitting the signal again and having every visual go back ot info in m_editPatient.

// I think a good way of guessing if haschanged should be true is not to just change it in onChaned events, but to actually check agains original m_patientEdit info to check if it really has changed. For example if we have a string, then check it on changed of vinsual element and check it against m_PatientEdit.
// Of coures the tricky part, well... not really tricky, just tidious! is to create a function in Database to alter every aspect of the data and every filed that we are cheanging seperately.s


UFO_Page {
    id: root

    title: qsTr("Edit Patient")
    contentSpacing: 20

    function setFieldValues() {
        textField_FirstName.text = Database.editPatientMap["first_name"];
        textField_LastName.text = Database.editPatientMap["last_name"];
        textField_PhoneNumber.text = Database.editPatientMap["phone_number"];
        textField_Age.text = Database.editPatientMap["age"];

        switch (Database.editPatientMap["gender"]) {
            case "Gender":
                comboBox_Gender.currentIndex = 0
                break
            case "Male":
                comboBox_Gender.currentIndex = 1
                break
            default:
                comboBox_Gender.currentIndex = 2
        };

        switch (Database.editPatientMap["marital_status"]) {
            case "Marital Status":
                comboBox_MaritalStatus.currentIndex = 0
                break
            case "Single":
                comboBox_MaritalStatus.currentIndex = 1
                break
            case "Married":
                comboBox_MaritalStatus.currentIndex = 2
                break
            case "Divorced":
                comboBox_MaritalStatus.currentIndex = 3
                break
            default:
                comboBox_MaritalStatus.currentIndex = 4
        };
    }

    function resetFieldStates() {
        textField_FirstName.hasChanged = false;
        textField_LastName.hasChanged = false;
        textField_PhoneNumber.hasChanged = false;
        textField_Age.hasChanged = false;

        comboBox_Gender.hasChanged = false;
        comboBox_MaritalStatus.hasChanged = false;
    }

    Connections {
        target: Database

        function onEditPatientMapChanged() {
            root.setFieldValues();
            root.resetFieldStates();
        }
    }

    UFO_GroupBox {
        id: ufo_GroupBox

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("General Information")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.topMargin: 20
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("You can revert the information at any time by pressing the 'Revert' button, provided the changes have not already been applied.")

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

                property bool hasChanged: false

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                placeholderText: qsTr("First name")

                onTextEdited: {
                    hasChanged = true
                }
            }

            UFO_TextField {
                id: textField_LastName

                property bool hasChanged: false

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                placeholderText: qsTr("Last name")

                onTextEdited: {
                    hasChanged = true
                }
            }

            UFO_ComboBox {
                id: comboBox_Gender

                property bool hasChanged: false

                Layout.preferredWidth: 150
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                model: ["Gender", "Male", "Female"]

                onActivated: {
                    hasChanged = true
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Layout.topMargin: 7
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            spacing: 10

            UFO_TextField {
                id: textField_Age

                property bool hasChanged: false

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                placeholderText: qsTr("Age")

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^((1[0-4][0-9])|([1-9][0-9])|[0-9]|150)$/ // Ranges between (0 – 150)
                }

                onTextEdited: {
                    hasChanged = true
                }
            }

            UFO_TextField {
                id: textField_PhoneNumber

                property bool hasChanged: false

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                placeholderText: qsTr("Phone Number")

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^\+\d{1,3} \(\d{3}\) \d{3}-\d{4}$/ // Format: +1 (555) 921-1222 -> [country code] [(Area code)] [Phone number]
                }

                onTextEdited: {
                    hasChanged = true
                }
            }

            UFO_ComboBox {
                id: comboBox_MaritalStatus

                property bool hasChanged: false

                Layout.preferredWidth: 150
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                model: ["Marital Status", "Single", "Married", "Divorced", "Widowed"]

                onActivated: {
                    hasChanged = true
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Layout.topMargin: 20
            Layout.bottomMargin: 7
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                // NOTE (SAVIZ): The enabled state of this button is more complicated as we need to also take into account the state of 'hasChanged' of visual elements.
                enabled: Database.connectionStatus && (
                    textField_FirstName.hasChanged || textField_LastName.hasChanged || textField_PhoneNumber.hasChanged || textField_Age.hasChanged || comboBox_Gender.hasChanged || comboBox_MaritalStatus.hasChanged
                )

                text: qsTr("Revert")
                svg: "./../../icons/Google icons/undo.svg"

                onClicked: {
                    root.setFieldValues();
                    root.resetFieldStates();
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                // NOTE (SAVIZ): The enabled state of this button is more complicated as we need to also take into account the state of 'hasChanged' of visual elements.
                enabled: Database.connectionStatus && (
                    textField_FirstName.hasChanged || textField_LastName.hasChanged || textField_PhoneNumber.hasChanged || textField_Age.hasChanged || comboBox_Gender.hasChanged || comboBox_MaritalStatus.hasChanged
                )

                text: qsTr("Apply")
                svg: "./../../icons/Google icons/edit.svg"

                onClicked: {

                    // Here make sure to call the apply changes.
                }
            }
        }
    }
}


// NOTE (SAVIZ): You can have multiple groupboxes, but only apply changes using different functions based on what has changed. I think there is something called a transaction to submit multiple changes, look it up.
