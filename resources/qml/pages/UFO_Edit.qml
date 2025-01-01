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

    title: qsTr("Edit Patient")
    contentSpacing: 25

    UFO_GroupBox {
        id: ufo_GroupBox_PersonalInformation

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Basic Data")
        contentSpacing: 3

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Background"])

            Text {
                id: text_PatinetID

                anchors.fill: parent

                text: qsTr("Patient ID ()")

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter

                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    text_PatinetID.text = qsTr("Patient ID (") + Database.getPatientDataMap()["patient_id"] + qsTr(")");
                }
            }
        }

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 20
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("First Name")

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom

            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        UFO_TextField {
            id: textField_FirstName

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            enabled: (Database.connectionStatus === true) ? true : false

            validator: RegularExpressionValidator {
                regularExpression: /^[A-Za-z]+$/
            }

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    textField_FirstName.text = Database.getPatientDataMap()["first_name"];
                }
            }
        }

        Text {
            Layout.fillWidth: true

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("Last Name")

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom

            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        UFO_TextField {
            id: textField_LastName

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            enabled: (Database.connectionStatus === true) ? true : false

            validator: RegularExpressionValidator {
                regularExpression: /^[A-Za-z]+$/
            }

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    textField_LastName.text = Database.getPatientDataMap()["last_name"];
                }
            }
        }

        Text {
            Layout.fillWidth: true

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("Birth Year")

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom

            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        UFO_TextField {
            id: textField_BirthYear

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            enabled: (Database.connectionStatus === true) ? true : false

            validator: RegularExpressionValidator {
                regularExpression: /^[1-9]\d*$/
            }

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    textField_BirthYear.text = Database.getPatientDataMap()["birth_year"];
                }
            }
        }

        Text {
            Layout.fillWidth: true

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("Phone Number")

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom

            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        UFO_TextField {
            id: textField_PhoneNumber

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            enabled: (Database.connectionStatus === true) ? true : false

            validator: RegularExpressionValidator {
                regularExpression: /^\+\d{1,3} \(\d{3}\) \d{3}-\d{4}$/
            }

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    textField_PhoneNumber.text = Database.getPatientDataMap()["phone_number"];
                }
            }
        }

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 30
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("Gender")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        UFO_ComboBox {
            id: comboBox_Gender

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            enabled: (Database.connectionStatus === true) ? true : false
            model: ["Unknown", "Male", "Female"]

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    switch (Database.getPatientDataMap()["gender"]) {
                        case "Unknown":
                            comboBox_Gender.currentIndex = 0;
                            break;
                        case "Male":
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

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("Marital status")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        UFO_ComboBox {
            id: comboBox_MaritalStatus

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            enabled: (Database.connectionStatus === true) ? true : false
            model: ["Unknown", "Single", "Married"]

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    switch (Database.getPatientDataMap()["marital_status"]) {
                        case "Unknown":
                            comboBox_Gender.currentIndex = 0;
                            break;
                        case "Single":
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

            Layout.topMargin: 30
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("Previous Visits")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        UFO_TextField {
            id: textField_NumberOfPreviousVisits

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            enabled: (Database.connectionStatus === true) ? true : false

            validator: RegularExpressionValidator {
                regularExpression: /^[0-9]\d*$/
            }

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    textField_NumberOfPreviousVisits.text = Database.getPatientDataMap()["number_of_previous_visits"];
                }
            }
        }

        Text {
            Layout.fillWidth: true

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("First Visit Date")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        UFO_TextField {
            id: textField_FirstVisitDate

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            enabled: (Database.connectionStatus === true) ? true : false

            validator: RegularExpressionValidator {
                regularExpression: /^[12]\d{3}-[01]\d-[0-3]\d$/
            }

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    textField_FirstVisitDate.text = Database.getPatientDataMap()["first_visit_date"];
                }
            }
        }

        Text {
            Layout.fillWidth: true

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("Recent Visit Date")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        UFO_TextField {
            id: textField_RecentVisitDate

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.leftMargin: 15
            Layout.rightMargin: 15

            enabled: (Database.connectionStatus === true) ? true : false

            validator: RegularExpressionValidator {
                regularExpression: /^[12]\d{3}-[01]\d-[0-3]\d$/
            }

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    textField_RecentVisitDate.text = Database.getPatientDataMap()["recent_visit_date"];
                }
            }
        }

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 30
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("Service Price")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        UFO_TextField {
            id: textField_ServicePrice

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.bottomMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            enabled: (Database.connectionStatus === true) ? true : false

            validator: RegularExpressionValidator {
                regularExpression: /^[1-9]\d*$/
            }

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    textField_ServicePrice.text = Database.getPatientDataMap()["service_price"];
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

        ScrollView {
            id: scrollView_TreatmentNote

            Layout.fillWidth: true
            Layout.preferredHeight: 200

            Layout.margins: 15

            ScrollBar.vertical: UFO_ScrollBar {
                parent: scrollView_TreatmentNote

                x: scrollView_TreatmentNote.mirrored ? 0 : scrollView_TreatmentNote.width - width
                y: scrollView_TreatmentNote.topPadding

                height: scrollView_TreatmentNote.availableHeight

                active: scrollView_TreatmentNote.ScrollBar.horizontal.active
            }

            UFO_TextArea {
                id: ufo_TextArea_TreatmentNote

                enabled: (Database.connectionStatus === true) ? true : false

                Connections {
                    target: Database

                    function onPatientDataPulled(success, message) {
                        if(success === false) {
                            return;
                        }

                        ufo_TextArea_TreatmentNote.text = Database.getPatientDataMap()["treatment_note"];
                    }
                }
            }
        }

        // Text {
        //     Layout.fillWidth: true
        //     Layout.fillHeight: true

        //     Layout.topMargin: 20
        //     Layout.leftMargin: 15
        //     Layout.rightMargin: 15

        //     text: qsTr("The following list represents the results of the search operation.")

        //     elide: Text.ElideRight
        //     horizontalAlignment: Text.AlignLeft
        //     verticalAlignment: Text.AlignVCenter
        //     wrapMode: Text.Wrap
        //     color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        // }

        // RowLayout {
        //     Layout.fillWidth: true

        //     Layout.topMargin: 7
        //     Layout.leftMargin: 15
        //     Layout.rightMargin: 15

        //     spacing: 1

        //     UFO_ComboBox {
        //         id: comboBox_Treatments

        //         Layout.fillWidth: true
        //         Layout.preferredHeight: 35

        //         enabled: (Database.connectionStatus === true) ? true : false

        //         textRole: "treatment_Name"

        //         model: ListModel { id: listModel_ComboBoxTreatments }

        //         Connections {
        //             target: Database

        //             function onTreatmentsPopulated() {
        //                 listModel_ComboBoxTreatments.clear();

        //                 Database.getTreatmentList().forEach(function (treatment) {
        //                     listModel_ComboBoxTreatments.append({"treatment_ID": treatment["treatment_id"], "treatment_Name": treatment["treatment_name"]});
        //                 });

        //                 // Set default:
        //                 comboBox_Treatments.currentIndex = 0;
        //             }
        //         }

        //         Connections {
        //             target: Database

        //             function onPatientDataChanged() {
        //                 comboBox_Treatments.currentIndex = 0;
        //             }
        //         }
        //     }

        //     UFO_Button {
        //         Layout.preferredWidth: 120
        //         Layout.preferredHeight: 35

        //         Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

        //         enabled: (Database.connectionStatus === true) ? true : false

        //         text: qsTr("Insert")
        //         svg: "./../../icons/Google icons/add_circle.svg"

        //         onClicked: {
        //             let exists = false;

        //             // Search for duplicates.
        //             for (let index = 0; index < listModel_ListViewTreatments.count; index++) {
        //                 if (listView_Treatments.model.get(index)["treatment_ID"] === comboBox_Treatments.model.get(comboBox_Treatments.currentIndex)["treatment_ID"]) {
        //                     exists = true;
        //                 }
        //             }

        //             if(exists) {
        //                 ufo_StatusBar.displayMessage("Cannot add treatment. A treatment of the same type already exists.")

        //                 return;
        //             }

        //             listModel_ListViewTreatments.append({"treatment_ID": comboBox_Treatments.model.get(comboBox_Treatments.currentIndex)["treatment_ID"], "treatment_Name": comboBox_Treatments.model.get(comboBox_Treatments.currentIndex)["treatment_Name"]});
        //         }
        //     }
        // }

        // ListView {
        //     id: listView_Treatments

        //     Connections {
        //         target: Database

        //         function onPatientDataChanged() {
        //             listModel_ListViewTreatments.clear();

        //             Database.getPatientDataMap()["treatments"].forEach(function (treatment) {
        //                 listModel_ListViewTreatments.append({"treatment_ID": treatment["treatment_id"], "treatment_Name": treatment["treatment_name"]});
        //             });
        //         }
        //     }

        //     Layout.fillWidth: true
        //     Layout.preferredHeight: (root.height * 0.45)

        //     Layout.topMargin: 15
        //     Layout.leftMargin: 15
        //     Layout.rightMargin: 15

        //     spacing: 1
        //     clip: true

        //     model: ListModel { id: listModel_ListViewTreatments }

        //     delegate: UFO_ListDelegate_Treatments {
        //         width: listView_Treatments.width

        //         treatmentName: model["treatment_Name"]

        //         onDeleteClicked: {
        //             listModel_ListViewTreatments.remove(index);
        //         }
        //     }
        // }
    }

    // // Apply and Revert
    // RowLayout {
    //     Layout.fillWidth: true

    //     Layout.topMargin: 10
    //     Layout.bottomMargin: 7

    //     UFO_Button {
    //         id: ufo_Button_DeletionStatus

    //         Layout.preferredWidth: 120
    //         Layout.preferredHeight: 35

    //         enabled: (Database.connectionStatus && root.patientSelected)

    //         checkable: true
    //         checked: false

    //         text: qsTr("Mark Deletion")
    //         svg: "./../../icons/Google icons/patient_delete.svg"

    //         onClicked: {
    //             // NOTE (SAVIZ): Before you ask... Yes! I have trust issues.
    //             (ufo_Button_DeletionStatus.checked === true) ? Database.changeDeletionStatus(true) : Database.changeDeletionStatus(false)
    //         }
    //     }

    //     Item {
    //         Layout.fillWidth: true
    //     }

    //     UFO_Button {
    //         Layout.preferredWidth: 120
    //         Layout.preferredHeight: 35

    //         enabled: (Database.connectionStatus && root.patientSelected)

    //         text: qsTr("Sync")
    //         svg: "./../../icons/Google icons/sync.svg"

    //         onClicked: {
    //             Database.readyPatientData(Database.getPatientDataMap()["patient_id"]);
    //         }
    //     }

    //UFO_Button {
        //         Layout.preferredWidth: 120
        //         Layout.preferredHeight: 35

        //         enabled: (Database.connectionStatus && root.patientSelected)

        //         text: qsTr("Close")
        //         svg: "./../../icons/Google icons/sync.svg"

        //         onClicked: {
        //             // Just set visibilyt of page to false
        //         }
        //     }

    //     UFO_Button {
    //         Layout.preferredWidth: 120
    //         Layout.preferredHeight: 35

    //         enabled: (Database.connectionStatus && root.patientSelected)

    //         text: qsTr("Apply")
    //         svg: "./../../icons/Google icons/database_apply.svg"

    //         onClicked: {
    //             // Personal Information:
    //             var first_name = textField_FirstName.text.trim();
    //             var last_name = textField_LastName.text.trim();
    //             var age = parseInt(textField_Age.text.trim());
    //             var phone_number = textField_PhoneNumber.text.trim();
    //             var gender = gender = comboBox_Gender.currentText;
    //             var marital_status = comboBox_MaritalStatus.currentText;



    //             // Treatments:
    //             let treatments = [];

    //             for (let index = 0; index < listModel_ListViewTreatments.count; index++) {
    //                 treatments.push(listView_Treatments.model.get(index)["treatment_ID"]);
    //             }



    //             // Apply changes:
    //             var operationOutcome = Database.updatePatientData(first_name, last_name, age, phone_number, gender, marital_status, treatments);

    //             if(operationOutcome === false) {
    //                 ufo_StatusBar.displayMessage("Edit operation failed!")
    //             }

    //             if(operationOutcome === true) {
    //                 ufo_StatusBar.displayMessage("Changes applied!")
    //             }
    //         }
    //     }
    // }
}


// NOTE (SAVIZ): Have the page begin with a visibly of false, so that the first time a patinet must be selected before attempting to modify it.
