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

    UFO_GroupBox {
        id: ufo_GroupBox_SearchOptions

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_PtextField_Age" ignores height to enable vertical scrolling.

        title: qsTr("Search Options")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.topMargin: 15
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

            Layout.topMargin: 25
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
                id: textField_Gender

                Layout.preferredWidth: 150
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                // TODO (SAVIZ): Check for 'Gender' and prevent search on it.
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
                id: textField_MaritalStatus

                Layout.preferredWidth: 150
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                // TODO (SAVIZ): Check for 'Marital Status' and prevent search on it.
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

                text: qsTr("Find First")
                svg: "./../../icons/Google icons/one.svg"

                onClicked: {
                    // TODO (SAVIZ): Enter Database command for finding first patient.
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Find Last")
                svg: "./../../icons/Google icons/infinity.svg"

                onClicked: {
                    // TODO (SAVIZ): Enter Database command for finding last patient.
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

                    // Make a function that clears everything.
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Search")
                svg: "./../../icons/Google icons/person_search.svg"

                onClicked: {
                    var first_name = textField_FirstName.text
                    var last_name = textField_LastName.text

                    var vtextField_Age;

                    if(textField_Age.text === "") {
                        vtextField_Age = -1
                    }

                    else {
                       vtextField_Age = parseInt(textField_Age.text)
                    }

                    var phone_number = textField_PhoneNumber.text
                    var sex = textField_Gender.currentText
                    var marital_status = textField_MaritalStatus.currentText

                    var operationOutcome = Database.search(first_name, last_name, vtextField_Age, phone_number, sex, marital_status)

                    if(operationOutcome === false) {
                        // TODO (SAVIZ): Perform a warning messtextField_Age.
                    }
                }
            }
        }
    }


    UFO_GroupBox {
        id: ufo_GroupBox_SearchResults

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_PtextField_Age" ignores height to enable vertical scrolling.

        title: qsTr("Search Results")
        contentSpacing: 0

        RowLayout {
            id: rowLayout_TitleContainer

            Layout.fillWidth: true

            spacing: 10

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

            Item {
                Layout.preferredWidth: 130
                Layout.preferredHeight: 35
            }
        }

        ListView {
            id: listView

            Layout.fillWidth: true
            Layout.preferredHeight: (root.height * 0.50)

            spacing: 15
            clip: true

            model: Database.searchModel

            delegate: UFO_ListDelegate {
                width: listView.width

                //backgroundColor: index % 2 === 0 ? Qt.color(AppTheme.colors["UFO_ListDelegate_Background_1"]) : Qt.color(AppTheme.colors["UFO_ListDelegate_Background_2"])

                // modelData is the data inside of model. In other words, the 'QVariantMap' inside of 'QVariantList'.
                firstName: modelData["first_name"]
                lastName: modelData["last_name"]
                gender: modelData["textField_Gender"]
                age: modelData["textField_Age"]

                onEditClicked: {
                    // We pass the index of the current delegate in the model which is the same as the index used in the 'QVariantList' to obtain the 'patient_id' from it.
                    Database.readyPatientForEditing(index)
                    root.patientSelectedForEdit()
                }
            }
        }
    }
}
