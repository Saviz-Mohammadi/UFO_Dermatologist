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

    title: qsTr("Edit Patient")
    contentSpacing: 20


    // TODO (SAVIZ): Write these in each connection for each element.
    function setFieldValues() {
        let patientDataMap = Database.getPatientDataMap();

        textField_FirstName.text = patientDataMap["first_name"];
        textField_LastName.text = patientDataMap["last_name"];
        textField_PhoneNumber.text = patientDataMap["phone_number"];
        textField_Age.text = patientDataMap["age"];

        switch (patientDataMap["gender"]) {
            case "Gender":
                comboBox_Gender.currentIndex = 0
                break
            case "Male":
                comboBox_Gender.currentIndex = 1
                break
            default:
                comboBox_Gender.currentIndex = 2
        };

        switch (patientDataMap["marital_status"]) {
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

        function onPatientDataChanged() {
            root.setFieldValues();
            root.resetFieldStates();
        }
    }

    Connections {
        target: Database

        // Acts as a refresh:
        function onUpdatesApplied() {
            let patientDataMap = Database.getPatientDataMap();

            Database.readyPatientDataForEditing(patientDataMap["patient_id"])
        }
    }

    UFO_GroupBox {
        id: ufo_GroupBox_GeneralInformation

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
    }

    UFO_GroupBox {
        id: ufo_GroupBox_Treatments

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Treatments")
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

            RowLayout {
                Layout.fillWidth: true

                Layout.topMargin: 7
                Layout.leftMargin: 15
                Layout.rightMargin: 15

                spacing: 10

                UFO_ComboBox {
                    id: comboBox_Treatments

                    property bool hasChanged: false

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    enabled: (Database.connectionStatus === true) ? true : false

                    textRole: "treatment_Name"

                    model: ListModel { id: listModel_ComboBoxTreatments }

                    Connections {
                        target: Database

                        function onTreatmentsPopulated() {
                            Database.getTreatmentList().forEach(function (treatment) {
                                listModel_ComboBoxTreatments.append({
                                    "treatment_ID": treatment["treatment_id"],
                                    "treatment_Name": treatment["treatment_name"]
                                });
                            })
                        }
                    }
                }

                UFO_Button {
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 35

                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                    enabled: (Database.connectionStatus === true) ? true : false

                    text: qsTr("Add")
                    svg: "./../../icons/Google icons/add_circle.svg"

                    onClicked: {
                        let exists = false;


                        // Search list and model to see if there is a duplicate entry.
                        for (let index = 0; index < listModel_ListViewTreatments.count; index++) {
                            var labelText = listView_Treatments.itemAtIndex(index).label.text;

                            if (labelText === comboBox_Treatments.currentText) {
                                exists = true;
                            }
                        }


                        if(exists) {
                            ufo_StatusBar.displayMessage("Cannot add treatment. An entry of the same type already exists.")

                            return;
                        }

                        listModel_ListViewTreatments.append(comboBox_Treatments.currentIndex);

                        listView_Treatments.hasChanged = true;
                    }
                }
            }
        }

        ListView {
            id: listView_Treatments

            property bool hasChanged: false

            Connections {
                target: Database

                function onEditPatientMapChanged() {
                    listModel_ListViewTreatments.clear();

                    Database.editPatientMap["treatment_names"].forEach(function (treatment_name) {
                        listModel_ListViewTreatments.append({"treatment_name": treatment_name});
                    })

                    listView_Treatments.hasChanged = false;
                }
            }

            Layout.fillWidth: true
            Layout.preferredHeight: (root.height * 0.45)

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            spacing: 10
            clip: true

            model: ListModel {
                id: listModel_ListViewTreatments
            }

            delegate: UFO_ListDelegate_Treatments {
                width: listView_Treatments.width


                // NOTE (SAVIZ): Here in the delegate you can store the index of the treatment from ComboxBox and use it to generate a treatment_id list using 'comboBox.model.get(comboBox.currentIndex).treatment_ID'

                treatmentName: listModel_ListViewTreatments.get(index).treatment_name

                onDeleteClicked: {
                    listModel_ListViewTreatments.remove(index);

                    listView_Treatments.hasChanged = true;
                }
            }
        }
    }

    // Apply and Revert
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
                listView_Treatments.hasChanged
            )

            text: qsTr("Revert")
            svg: "./../../icons/Google icons/undo.svg"

            onClicked: {
                listModel_ListViewTreatments.clear();

                Database.editPatient["treatment_names"].forEach(function (treatment_name) {
                    listModel_ListViewTreatments.append({"treatment_name": treatment_name});
                })
            }
        }

        UFO_Button {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            // NOTE (SAVIZ): The enabled state of this button is more complicated as we need to also take into account the state of 'hasChanged' of visual elements.
            enabled: Database.connectionStatus && (
                listView_Treatments.hasChanged
            )

            text: qsTr("Apply")
            svg: "./../../icons/Google icons/edit.svg"

            onClicked: {
                var first_name = "";
                var last_name = "";
                var age = -1;
                var phone_number = "";
                var gender = "";
                var marital_status = "";

                // Populate if viable:
                if(textField_FirstName.hasChanged) {
                    first_name = textField_FirstName.text.trim()
                }

                if(textField_LastName.hasChanged) {
                    last_name = textField_LastName.text.trim()
                }

                if(textField_Age.hasChanged) {
                    age = parseInt(textField_Age.text.trim())
                }

                if(textField_PhoneNumber.hasChanged) {
                    phone_number = textField_PhoneNumber.text.trim()
                }

                if(comboBox_Gender.hasChanged) {
                    gender = comboBox_Gender.currentText
                }

                if(comboBox_MaritalStatus.hasChanged) {
                    gender = comboBox_MaritalStatus.currentText
                }


                var operationOutcome = Database.editPatient(first_name, last_name, age, phone_number, gender, marital_status)

                if(operationOutcome === false) {

                    ufo_StatusBar.displayMessage("Edit operation failed!")
                }
            }
        }
    }
}


// NOTE (SAVIZ): You can have multiple groupboxes, but only apply changes using different functions based on what has changed. I think there is something called a transaction to submit multiple changes, look it up.
