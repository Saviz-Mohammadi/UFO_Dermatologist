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

    RowLayout {
        Layout.fillWidth: true

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

        Item {
            Layout.fillWidth: true
        }

        // NOTE (SAVIZ): There is a disagreement weather this should be in basic section or just universally visible.
        Text {
            id: text_PatientID

            text: qsTr("شماره پرونده ()")

            verticalAlignment: Text.AlignVCenter

            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])

            font.pixelSize: Qt.application.font.pixelSize * 1.5
        }

        Connections {
            target: Database

            function onQueryExecuted(type, success, message) {
                if(type !== Database.QueryType.SELECT) {
                    return;
                }

                if(success === false) {
                    return;
                }

                text_PatientID.text = qsTr("شماره پرونده (") + Database.getPatientDataMap()["patient_id"] + qsTr(")");
            }
        }
    }

    RowLayout {
        id: rowLayout

        Layout.fillWidth: true

        ButtonGroup { id: buttonGroup }

        UFO_Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            text: qsTr("Basic")

            ButtonGroup.group: buttonGroup

            checkable: true
            autoExclusive: true
            checked: false

            onCheckedChanged: {
                if(this.checked === true) {
                    rowLayout.openTab("Basic")
                }
            }
        }

        UFO_Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            text: qsTr("Diagnoses")

            ButtonGroup.group: buttonGroup

            checkable: true
            autoExclusive: true
            checked: false

            onCheckedChanged: {
                if(this.checked === true) {
                    rowLayout.openTab("Diagnoses")
                }
            }
        }

        UFO_Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            text: qsTr("Treatments")

            ButtonGroup.group: buttonGroup

            checkable: true
            autoExclusive: true
            checked: false

            onCheckedChanged: {
                if(this.checked === true) {
                    rowLayout.openTab("Treatments")
                }
            }
        }

        UFO_Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            text: qsTr("Medical Drugs")

            ButtonGroup.group: buttonGroup

            checkable: true
            autoExclusive: true
            checked: false

            onCheckedChanged: {
                if(this.checked === true) {
                    rowLayout.openTab("Medical Drugs")
                }
            }
        }

        UFO_Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            text: qsTr("Procedures")

            ButtonGroup.group: buttonGroup

            checkable: true
            autoExclusive: true
            checked: false

            onCheckedChanged: {
                if(this.checked === true) {
                    rowLayout.openTab("Procedures")
                }
            }
        }

        UFO_Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            text: qsTr("Consultations")

            ButtonGroup.group: buttonGroup

            checkable: true
            autoExclusive: true
            checked: false

            onCheckedChanged: {
                if(this.checked === true) {
                    rowLayout.openTab("Consultations")
                }
            }
        }

        UFO_Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            text: qsTr("Lab Tests")

            ButtonGroup.group: buttonGroup

            checkable: true
            autoExclusive: true
            checked: false

            onCheckedChanged: {
                if(this.checked === true) {
                    rowLayout.openTab("Lab Tests")
                }
            }
        }

        function openTab(target) {

            // TODO (SAVIZ): I like to replace these with an enum, but currently I don't know how in QML.
            switch (target) {
                case "Basic":
                    stackLayout.currentIndex = ufo_BasicData.StackLayout.index
                    break
                case "Diagnoses":
                    stackLayout.currentIndex = ufo_Diagnoses.StackLayout.index
                    break
                case "Treatments":
                    stackLayout.currentIndex = ufo_Treatments.StackLayout.index
                    break
                case "Medical Drugs":
                    stackLayout.currentIndex = ufo_MedicalDrugs.StackLayout.index
                    break
                case "Procedures":
                    stackLayout.currentIndex = ufo_Procedures.StackLayout.index
                    break
                case "Consultations":
                    stackLayout.currentIndex = ufo_Consultations.StackLayout.index
                    break
                case "Lab Tests":
                    stackLayout.currentIndex = ufo_LabTests.StackLayout.index
                    break
                default:
                    console.log("No valid value");
            }
        }
    }

    StackLayout {
        id: stackLayout

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        UFO_PatientBasicDataEditor {
            id: ufo_BasicData

            Layout.fillWidth: true
        }

        UFO_PatientDiagnosesEditor {
            id: ufo_Diagnoses

            Layout.fillWidth: true
        }

        UFO_PatientTreatmentsEditor {
            id: ufo_Treatments

            Layout.fillWidth: true
        }

        UFO_PatientMedicalDrugsEditor {
            id: ufo_MedicalDrugs

            Layout.fillWidth: true
        }

        UFO_PatientProceduresEditor {
            id: ufo_Procedures

            Layout.fillWidth: true
        }

        UFO_PatientConsultationsEditor {
            id: ufo_Consultations

            Layout.fillWidth: true
        }

        UFO_PatientLabTestsEditor {
            id: ufo_LabTests

            Layout.fillWidth: true
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
                // Basic Data:
                let first_name = ufo_BasicData.patientFirstName.trim();
                let last_name = ufo_BasicData.patientLastName.trim();
                let birthYear = parseInt(ufo_BasicData.patientBirthYear.trim(), 10);
                let phone_number = ufo_BasicData.patientPhoneNumber.trim();
                let email = ufo_BasicData.patientEmail.trim();
                let gender = ufo_BasicData.patientGender;
                let marital_status = ufo_BasicData.patientMaritalStatus;
                let numberOfPreviousVisits = parseInt(ufo_BasicData.patientNumberOfPreviousVisits.trim(), 10);
                let firstVisitDate = ufo_BasicData.patientFirstVisitDate.trim();
                let recentVisitDate = ufo_BasicData.patientRecentVisitDate.trim();
                let expectedVisitDate = ufo_BasicData.patientExpectedVisitDate.trim();
                let servicePrice = parseFloat(ufo_BasicData.patientServicePrice.trim());

                // Lists:
                let newDiagnoses = ufo_Diagnoses.getListOfDiagnoses();
                let treatments = ufo_Treatments.getListOfTreatments();
                let medicalDrugs = ufo_MedicalDrugs.getListOfMedicalDrugs();
                let procedures = ufo_Procedures.getListOfProcedures();
                let consultations = ufo_Consultations.getListOfConsultations();
                let labTests = ufo_LabTests.getListOfLabTests();

                // Notes:
                let diagnosisNote = ufo_Diagnoses.getDiagnosisNote();
                let treatmentNote = ufo_Treatments.getTreatmentNote();
                let medicalDrugNote = ufo_MedicalDrugs.getMedicalDrugNote();
                let procedureNote = ufo_Procedures.getProcedureNote();

                // Push:
                Database.updatePatientData(first_name, last_name, birthYear, phone_number, email, gender, marital_status, numberOfPreviousVisits, firstVisitDate, recentVisitDate, expectedVisitDate, servicePrice, newDiagnoses, diagnosisNote, treatments, treatmentNote, medicalDrugs, medicalDrugNote, procedures, procedureNote, consultations, labTests);
            }
        }
    }

    UFO_OperationResult {
        id: ufo_OperationResult

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        Connections {
            target: Database

            function onQueryExecuted(type, success, message) {
                if(type === Database.QueryType.CREATE) {
                    return;
                }

                if(type === Database.QueryType.SEARCH) {
                    return;
                }

                if(type === Database.QueryType.DELETE) {
                    return;
                }

                if(success === true) {
                    ufo_OperationResult.svg = "./../../icons/Google icons/check_box.svg";
                    ufo_OperationResult.state = true;
                    ufo_OperationResult.displayMessage(message, 8000);

                    return;
                }


                if(success === false) {
                    ufo_OperationResult.svg = "./../../icons/Google icons/error.svg";
                    ufo_OperationResult.state = false;
                    ufo_OperationResult.displayMessage(message, 8000);

                    return;
                }
            }
        }
    }
}
