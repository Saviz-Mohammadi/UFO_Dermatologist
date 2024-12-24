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

    signal patientSelectedForEdit

    title: qsTr("Search Patients")
    contentSpacing: 20

    function clearFields() {
        textField_FirstName.clear()
        textField_LastName.clear()
        textField_PhoneNumber.clear()

        comboBox_Gender.currentIndex = 0
        comboBox_MaritalStatus.currentIndex = 0
    }

    UFO_GroupBox {
        id: ufo_GroupBox_SearchOptions

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Search Options")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.topMargin: 20
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("Use the following fields to search for a patient. The more fields you use and the more information you provide, the more accurate the result list will be. Once you find a patient, click the 'Edit Patient' button to update the patient's information.")

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
            }

            UFO_TextField {
                id: textField_LastName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                placeholderText: qsTr("Last name")
            }

            UFO_ComboBox {
                id: comboBox_Gender

                Layout.preferredWidth: 150
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                model: ["Gender", "Male", "Female"]
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

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                placeholderText: qsTr("Age")

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^((1[0-4][0-9])|([1-9][0-9])|[0-9]|150)$/ // Ranges between (0 – 150)
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
            }

            UFO_ComboBox {
                id: comboBox_MaritalStatus

                Layout.preferredWidth: 150
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                model: ["Marital Status", "Single", "Married", "Divorced", "Widowed"]
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Layout.topMargin: 60
            Layout.bottomMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("First")
                svg: "./../../icons/Google icons/one.svg"

                onClicked: {
                    Database.findFirstPatient()
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Recent")
                svg: "./../../icons/Google icons/recent.svg"

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

                    root.clearFields();
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Search")
                svg: "./../../icons/Google icons/person_search.svg"

                onClicked: {
                    var first_name = textField_FirstName.text.trim()
                    var last_name = textField_LastName.text.trim()
                    var age = (textField_Age.text === "") ? -1 : parseInt(textField_Age.text.trim())
                    var phone_number = textField_PhoneNumber.text
                    var gender = comboBox_Gender.currentText
                    var marital_status = comboBox_MaritalStatus.currentText

                    var operationOutcome = Database.findPatient(first_name, last_name, age, phone_number, gender, marital_status)

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

        Text {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.topMargin: 20
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("The following list represents the results of the search operation.")

            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        RowLayout {
            id: rowLayout_TitleContainer

            Layout.fillWidth: true

            Layout.topMargin: 7
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            spacing: 1

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    text: qsTr("FIRST NAME")

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pointSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    text: qsTr("LAST NAME")

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pointSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    text: qsTr("PHONE NUMBER")

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pointSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    text: qsTr("GENDER")

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pointSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 35

                color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Background"])

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 10

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    text: qsTr("AGE")

                    color: Qt.color(AppTheme.colors["UFO_ListDelegate_Column_Text"])
                    font.pointSize: Qt.application.font.pixelSize * 1
                    elide: Text.ElideRight
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Clear")
                svg: "./../../icons/Google icons/delete.svg"

                onClicked: {
                    Database.clearSearchResults();
                }
            }
        }

        ListView {
            id: listView

            Layout.fillWidth: true
            Layout.preferredHeight: (root.height * 0.45)

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            spacing: 10
            clip: true

            model: Database.searchResultList

            delegate: UFO_ListDelegate {
                width: listView.width

                // modelData is the data inside of model. In other words, the 'QVariantMap' inside of 'QVariantList'.
                firstName: modelData["first_name"]
                lastName: modelData["last_name"]
                phoneNumber: modelData["phone_number"]
                gender: modelData["gender"]
                age: modelData["age"]

                onEditClicked: {
                    // We pass the index of the current delegate in the model which is the same as the index used in the 'QVariantList' to obtain the 'patient_id' from it.
                    var operationStatus = Database.readyPatientForEditing(index)

                    if(operationStatus !== true) {
                        ufo_StatusBar.displayMessage("Edit operation failed!");

                        return;
                    }

                    root.patientSelectedForEdit()
                }
            }
        }
    }
}
