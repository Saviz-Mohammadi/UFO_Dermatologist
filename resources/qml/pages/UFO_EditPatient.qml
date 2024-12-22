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

    title: qsTr("Search Patients")
    contentSpacing: 20

    UFO_GroupBox {
        id: ufo_GroupBox

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Search Options")
        contentSpacing: 0

        RowLayout {
            Layout.fillWidth: true

            Layout.topMargin: 7
            Layout.bottomMargin: 0
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            UFO_TextField {
                id: firstName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                placeholderText: qsTr("First name")
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Clear")
                svg: "./../../icons/Google icons/cancel.svg"

                onClicked: {

                    firstName.clear()
                }
            }

            UFO_TextField {
                id: lastName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                placeholderText: qsTr("Last name")
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Clear")
                svg: "./../../icons/Google icons/cancel.svg"

                onClicked: {

                    lastName.clear()
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Layout.topMargin: 7
            Layout.bottomMargin: 0
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            UFO_TextField {
                id: age

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                placeholderText: qsTr("Age")

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^((1[0-4][0-9])|([1-9][0-9])|[0-9]|150)$/ // Ranges between (0 – 150)
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Clear")
                svg: "./../../icons/Google icons/cancel.svg"

                onClicked: {

                    age.clear()
                }
            }

            UFO_TextField {
                id: phoneNumber

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                placeholderText: qsTr("Phone Number")

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^\+\d{1,3} \(\d{3}\) \d{3}-\d{4}$/ // Format: +1 (555) 921-1222 -> [country code] [(Area code)] [Phone number]
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Clear")
                svg: "./../../icons/Google icons/cancel.svg"

                onClicked: {

                    phoneNumber.clear()
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Layout.topMargin: 7
            Layout.bottomMargin: 0
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            UFO_ComboBox {
                id: gender

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                model: ["Male", "Female"]
            }

            UFO_ComboBox {
                id: maritalStatus

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                model: ["Single", "Married", "Divorced", "Widowed"]
            }
        }

        UFO_Button {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 35
            Layout.alignment: Qt.AlignRight

            Layout.topMargin: 20
            Layout.bottomMargin: 7
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            enabled: (Database.connectionStatus === true) ? true : false

            text: qsTr("Search")
            svg: "./../../icons/Google icons/search.svg"

            onClicked: {
                var first_name = firstName.text
                var last_name = lastName.text

                var vage;

                if(age.text === "") {
                    vage = -1
                }

                else {
                   vage = parseInt(age.text)
                }

                var phone_number = phoneNumber.text
                var sex = gender.currentText
                var marital_status = maritalStatus.currentText

                var operationOutcome = Database.search(first_name, last_name, vage, phone_number, sex, marital_status)

                if(operationOutcome === false) {
                    // TODO (SAVIZ): Perform a warning message.
                }
            }
        }
    }

    ListView {
        id: listView

        Layout.fillWidth: true
        Layout.preferredHeight: (root.height - ufo_GroupBox.height)

        spacing: 15
        clip: true

        model: Database.searchModel

        delegate: UFO_ListDelegate {
            width: listView.width

            backgroundColor: index % 2 === 0 ? Qt.color(AppTheme.colors["UFO_ListDelegate_Background_1"]) : Qt.color(AppTheme.colors["UFO_ListDelegate_Background_2"])

            // modelData is the data inside of model. In other words, the 'QVariantMap' inside of 'QVariantList'.
            firstName: modelData["first_name"]
            lastName: modelData["last_name"]
            gender: modelData["gender"]
            age: modelData["age"]

            onEditClicked: {

                // We pass the index of the current delegate in the model which is the same as the index used in the 'QVariantList' to obtain the 'patient_id' from it.
                Database.removeTask(index)
            }
        }
    }
}
