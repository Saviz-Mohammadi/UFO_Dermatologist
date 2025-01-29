import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components"

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0
import Date 1.0

UFO_Page {
    id: root

    title: qsTr("ویرایش")
    contentSpacing: 25

    contentVisible: false

    UFO_Button {
        id: ufo_Button_MarkedForDeletion

        Layout.preferredHeight: 40

        enabled: (Database.connectionStatus === true) ? true : false

        text: qsTr("علامت‌گذاری برای حذف")
        icon.source: "./../../icons/Google icons/flag.svg"
        checkable: true

        Connections {
            target: Database

            function onQueryExecuted(type, success, message) {
                if(type !== Database.QueryType.SELECT) {
                    return;
                }

                if(success === false) {
                    return;
                }

                ufo_Button_MarkedForDeletion.checked = Database.getPatientDataMap()["marked_for_deletion"];
            }
        }

        onToggled: {
            Database.changeDeletionStatus(ufo_Button_MarkedForDeletion.checked);
        }
    }

    UFO_PatientBasicDataEditor {
        id: ufo_BasicData

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.
    }

    UFO_PatientDiagnosesEditor {
        id: ufo_Diagnoses

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.
    }

    UFO_PatientTreatmentsEditor {
        id: ufo_Treatments

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.
    }

    UFO_PatientMedicalDrugsEditor {
        id: ufo_MedicalDrugs

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.
    }

    UFO_PatientProceduresEditor {
        id: ufo_Procedures

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.
    }

    UFO_PatientConsultationsEditor {
        id: ufo_Consultations

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.
    }

    UFO_GroupBox {
        id: ufo_GroupBox_LabTests

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Lab Tests")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("The following represents the list of lab tests assigned to the patient")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        RowLayout {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            spacing: 2

            UFO_ComboBox {
                id: ufo_ComboBox_LabName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "lab_name"

                model: ListModel { id: listModel_UFO_ComboBox_LabName }

                Connections {
                    target: Database

                    function onLabListPopulated() {
                        listModel_UFO_ComboBox_LabName.clear();

                        Database.getLabList().forEach(function (lab) {
                            listModel_UFO_ComboBox_LabName.append({"lab_id": lab["lab_id"], "lab_name": lab["name"]});
                        });

                        // Set default:
                        ufo_ComboBox_LabName.currentIndex = 0;
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        ufo_ComboBox_LabName.currentIndex = 0;
                    }
                }
            }

            UFO_ComboBox {
                id: ufo_ComboBox_LabSpeciality

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "specialization"

                model: ListModel {
                    id: listModel_UFO_ComboBox_LabSpeciality

                    ListElement { specialization: "All" }
                    ListElement { specialization: "Optometrist" }
                    ListElement { specialization: "Dentist" }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        ufo_ComboBox_LabSpeciality.currentIndex = 0;
                    }
                }

                onActivated:  {
                    listModel_UFO_ComboBox_LabName.clear();

                    if(ufo_ComboBox_LabSpeciality.currentText === "All") {
                        Database.getLabList().forEach(function (lab) {
                            listModel_UFO_ComboBox_LabName.append({"lab_id": lab["lab_id"], "lab_name": lab["name"]});
                        });
                    }

                    else {
                        Database.getLabList().forEach(function (lab) {
                            if(lab["lab_specialization"] === ufo_ComboBox_LabSpeciality.currentText) {
                                listModel_UFO_ComboBox_LabName.append({"lab_id": lab["lab_id"], "lab_name": lab["name"]});
                            }
                        });
                    }

                    ufo_ComboBox_LabName.currentIndex = 0
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("اضافه کردن")
                icon.source: "./../../icons/Google icons/add_box.svg"

                onClicked: {
                    listModel_ListView_LabTests.append({"lab_id": ufo_ComboBox_LabName.model.get(ufo_ComboBox_LabName.currentIndex)["lab_id"], "lab_name": ufo_ComboBox_LabName.model.get(ufo_ComboBox_LabName.currentIndex)["lab_name"], "lab_test_date": "", "lab_test_outcome": ""});
                }
            }

            // TODO (SAVIZ): The combobox is only in charge of adding a new consultant id and name. the actual data like outcome text and date are the responsibilyt of eth patient pull and push to sync with teh delegate.
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 300

            Layout.topMargin: 2
            Layout.bottomMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            radius: 0

            color: Qt.color(AppTheme.colors["UFO_GroupBox_ListView_Background"])

            ListView {
                id: listView_LabTests

                anchors.fill: parent

                anchors.margins: 15

                spacing: 2
                clip: true

                model: ListModel { id: listModel_ListView_LabTests }

                ScrollBar.vertical: ScrollBar {
                    id: scrollBar_LabTests

                    width: 10
                    policy: ScrollBar.AsNeeded
                }

                delegate: UFO_Delegate_LabTest {
                    width: listView_LabTests.width - scrollBar_LabTests.width / 2

                    labName: model["lab_name"]
                    labTestConductedDate: model["lab_test_date"]
                    labTestOutcome: model["lab_test_outcome"]

                    onRemoveClicked: {
                        listModel_ListView_LabTests.remove(index);
                    }

                    onDateChanged: {
                        model["lab_test_date"] = labTestConductedDate.trim();
                    }

                    onOutcomeChanged: {
                        model["lab_test_outcome"] = labTestOutcome.trim();
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        listModel_ListView_LabTests.clear();

                        Database.getPatientDataMap()["labTests"].forEach(function (labTest) {
                            listModel_ListView_LabTests.append({"lab_id": labTest["lab_id"], "lab_name": labTest["lab_name"], "lab_test_date": labTest["lab_test_date"], "lab_test_outcome": labTest["lab_test_outcome"]});
                        });
                    }
                }
            }
        }
    }

    // Pull and Push
    RowLayout {
        Layout.fillWidth: true

        UFO_Button {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus === true) ? true : false

            text: qsTr("بستن")
            icon.source: "./../../icons/Google icons/edit_off.svg"

            onClicked: {
                root.contentVisible = false
            }
        }

        Item {
            Layout.fillWidth: true
        }

        UFO_Button {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus === true) ? true : false

            text: qsTr("دریافت داده")
            icon.source: "./../../icons/Google icons/download.svg"

            onClicked: {
                Database.pullPatientData(Database.getPatientDataMap()["patient_id"]);
            }
        }

        UFO_Button {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 35

            enabled: (Database.connectionStatus === true) ? true : false

            text: qsTr("ارسال داده")
            icon.source: "./../../icons/Google icons/upload.svg"

            onClicked: {
                // Personal Information:
                let first_name = ufo_BasicData.patientFirstName.trim();
                let last_name = ufo_BasicData.patientLastName.trim();
                let birthYear = parseInt(ufo_BasicData.patientBirthYear.trim(), 10);
                let phone_number = ufo_BasicData.patientPhoneNumber.trim();
                let gender = gender = ufo_BasicData.patientGender;
                let marital_status = ufo_BasicData.patientMaritalStatus;
                let numberOfPreviousVisits = parseInt(ufo_BasicData.patientNumberOfPreviousVisits.trim(), 10);
                let firstVisitDate = ufo_BasicData.patientFirstVisitDate.trim();
                let recentVisitDate = ufo_BasicData.patientRecentVisitDate.trim();
                let servicePrice = parseFloat(ufo_BasicData.patientServicePrice.trim());


                // Lists:
                let newDiagnoses = ufo_Diagnoses.getListOfDiagnoses();
                let treatments = [];
                let medicalDrugs = [];
                let procedures = [];


                // Notes:
                let diagnosisNote;
                let treatmentNote;
                let medicalDrugNote;
                let procedureNote;

                let consultations = [];

                let labTests = [];

                for (let b = 0; b < listModel_ListView_LabTests.count; b++) {
                    let item = listModel_ListView_LabTests.get(b);

                    labTests.push({
                        lab_id: item.lab_id,
                        lab_test_date: item.lab_test_date,
                        lab_test_outcome: item.lab_test_outcome
                    });
                }

                // Push:
                Database.updatePatientData(first_name, last_name, birthYear, phone_number, gender, marital_status, numberOfPreviousVisits, firstVisitDate, recentVisitDate, servicePrice, newDiagnoses, diagnosisNote, treatments, treatmentNote, medicalDrugs, medicalDrugNote, procedures, procedureNote, consultations, labTests);
            }
        }
    }

    UFO_OperationResult {
        id: ufo_OperationResult

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        // Connections {
        //     target: Database

        //     function onConnectionStatusChanged(message) {
        //         if(Database.connectionStatus === true) {
        //             ufo_OperationResult.svg = "./../../icons/Google icons/check_box.svg";
        //             ufo_OperationResult.state = true;
        //             ufo_OperationResult.displayMessage(message, 5000);


        //             return;
        //         }


        //         if(Database.connectionStatus === false) {
        //             ufo_OperationResult.svg = "./../../icons/Google icons/error.svg";
        //             ufo_OperationResult.state = false;
        //             ufo_OperationResult.displayMessage(message, 5000);


        //             return;
        //         }
        //     }
        // }
    }
}
