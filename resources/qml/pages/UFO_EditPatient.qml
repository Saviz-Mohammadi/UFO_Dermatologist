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

    property bool patientSelected: false

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

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                placeholderText: qsTr("First name")

                Connections {
                    target: Database

                    function onPatientDataChanged() {
                        textField_FirstName.text = Database.getPatientDataMap()["first_name"]
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
                    target: Database

                    function onPatientDataChanged() {
                        textField_LastName.text = Database.getPatientDataMap()["last_name"]
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
                    target: Database

                    function onPatientDataChanged() {
                        switch (Database.getPatientDataMap()["gender"]) {
                            case "Male":
                                comboBox_Gender.currentIndex = 0
                                break
                            default:
                                comboBox_Gender.currentIndex = 1
                        };
                    }
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

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                placeholderText: qsTr("Age")

                enabled: (Database.connectionStatus === true) ? true : false

                validator: RegularExpressionValidator {
                    regularExpression: /^((1[0-4][0-9])|([1-9][0-9])|[0-9]|150)$/ // Ranges between (0 – 150)
                }

                Connections {
                    target: Database

                    function onPatientDataChanged() {
                        textField_Age.text = Database.getPatientDataMap()["age"]
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
                    target: Database

                    function onPatientDataChanged() {
                        textField_PhoneNumber.text = Database.getPatientDataMap()["phone_number"]
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
                    target: Database

                    function onPatientDataChanged() {
                        switch (Database.getPatientDataMap()["marital_status"]) {
                            case "Single":
                                comboBox_MaritalStatus.currentIndex = 0
                                break
                            case "Married":
                                comboBox_MaritalStatus.currentIndex = 1
                                break
                            case "Divorced":
                                comboBox_MaritalStatus.currentIndex = 2
                                break
                            default:
                                comboBox_MaritalStatus.currentIndex = 3
                        };
                    }
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

                    Layout.fillWidth: true
                    Layout.preferredHeight: 35

                    enabled: (Database.connectionStatus === true) ? true : false

                    textRole: "treatment_Name"

                    model: ListModel { id: listModel_ComboBoxTreatments }

                    Connections {
                        target: Database

                        function onTreatmentsPopulated() {
                            listModel_ComboBoxTreatments.clear();

                            Database.getTreatmentList().forEach(function (treatment) {
                                listModel_ComboBoxTreatments.append({"treatment_ID": treatment["treatment_id"], "treatment_Name": treatment["treatment_name"]});
                            });

                            // Set default:
                            comboBox_Treatments.currentIndex = 0;
                        }
                    }

                    Connections {
                        target: Database

                        function onPatientDataChanged() {
                            comboBox_Treatments.currentIndex = 0;
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

                        // Search for duplicates.
                        for (let index = 0; index < listModel_ListViewTreatments.count; index++) {
                            if (listView_Treatments.model.get(index)["treatment_ID"] === comboBox_Treatments.model.get(comboBox_Treatments.currentIndex)["treatment_ID"]) {
                                exists = true;
                            }
                        }

                        if(exists) {
                            ufo_StatusBar.displayMessage("Cannot add treatment. A treatment of the same type already exists.")

                            return;
                        }

                        listModel_ListViewTreatments.append({"treatment_ID": comboBox_Treatments.model.get(comboBox_Treatments.currentIndex)["treatment_ID"], "treatment_Name": comboBox_Treatments.model.get(comboBox_Treatments.currentIndex)["treatment_Name"]});
                    }
                }
            }
        }

        ListView {
            id: listView_Treatments

            Connections {
                target: Database

                function onPatientDataChanged() {
                    listModel_ListViewTreatments.clear();

                    Database.getPatientDataMap()["treatments"].forEach(function (treatment) {
                        listModel_ListViewTreatments.append({"treatment_ID": treatment["treatment_id"], "treatment_Name": treatment["treatment_name"]});
                    });
                }
            }

            Layout.fillWidth: true
            Layout.preferredHeight: (root.height * 0.45)

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            spacing: 10
            clip: true

            model: ListModel { id: listModel_ListViewTreatments }

            delegate: UFO_ListDelegate_Treatments {
                width: listView_Treatments.width

                treatmentName: model["treatment_Name"]

                onDeleteClicked: {
                    listModel_ListViewTreatments.remove(index);
                }
            }
        }
    }

    // Apply and Revert
    RowLayout {
        Layout.fillWidth: true

        Layout.topMargin: 20
        Layout.bottomMargin: 7

        UFO_Button {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            // NOTE (SAVIZ): The enabled state of this button is more complicated as we need to also take into account the state of 'hasChanged' of visual elements.
            enabled: (Database.connectionStatus && root.patientSelected)

            checkable: true
            checked: false

            text: qsTr("Mark Deletion")
            svg: "./../../icons/Google icons/patient_delete.svg"

            onClicked: {
                // Delete here.
            }
        }

        Item {
            Layout.fillWidth: true
        }

        UFO_Button {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus && root.patientSelected)

            text: qsTr("Sync")
            svg: "./../../icons/Google icons/sync.svg"

            onClicked: {
                Database.readyPatientData(Database.getPatientDataMap()["patient_id"]);
            }
        }

        UFO_Button {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus && root.patientSelected)

            text: qsTr("Apply")
            svg: "./../../icons/Google icons/database_apply.svg"

            onClicked: {
                // Personal Information:
                var first_name = textField_FirstName.text.trim();
                var last_name = textField_LastName.text.trim();
                var age = parseInt(textField_Age.text.trim());
                var phone_number = textField_PhoneNumber.text.trim();
                var gender = gender = comboBox_Gender.currentText;
                var marital_status = comboBox_MaritalStatus.currentText;



                // Treatments:
                let treatments = [];

                for (let index = 0; index < listModel_ListViewTreatments.count; index++) {
                    treatments.push(listView_Treatments.model.get(index)["treatment_ID"]);
                }



                // Apply changes:
                var operationOutcome = Database.updatePatientData(first_name, last_name, age, phone_number, gender, marital_status, treatments);

                if(operationOutcome === false) {
                    ufo_StatusBar.displayMessage("Edit operation failed!")
                }

                if(operationOutcome === true) {
                    ufo_StatusBar.displayMessage("Changes applied!")
                }
            }
        }
    }
}


// NOTE (SAVIZ): When a patient is deleted, you can emit a signal that disables the visibily of the entire page and optionally enables the visibly of something that says patien was deleted. Also, have the patientdata map be cleared in the background at the end of the deelte method call in database. this way everything is clean. Of course all of this should only happen if the deleet operation is succesufl.Maybe have a delete signal be emitted from the database instead.
// NOTE (SAVIZ): Have the page begin with a visibly of false, so that the first time a patinet must be selected before attempting to modify it.
// NOTE (SAVIZ): I think the best way to deal with deletions is to add a field to patients, which says 'mark_for_deletion', and then have a button that changes to mark and unmark in the edit patient tab. You can then also add a field in search for all people that have been marked for deletion peopel. and then in settings add a button that says deleet all marked patients.
