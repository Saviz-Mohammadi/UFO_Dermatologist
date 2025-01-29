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

    UFO_GroupBox {
        id: ufo_GroupBox_Treatments

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Treatments")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("موارد زیر نشان‌دهنده فهرست درمان‌هایی است که به بیمار اختصاص داده شده‌اند.")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

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
                id: ufo_ComboBox_Treatments

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "name"

                model: ListModel { id: listModel_ComboBoxTreatments }

                Connections {
                    target: Database

                    function onTreatmentListPopulated() {
                        listModel_ComboBoxTreatments.clear();

                        Database.getTreatmentList().forEach(function (treatment) {
                            listModel_ComboBoxTreatments.append({"treatment_id": treatment["treatment_id"], "name": treatment["name"]});
                        });

                        // Set default:
                        ufo_ComboBox_Treatments.currentIndex = 0;
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        ufo_ComboBox_Treatments.currentIndex = 0;
                    }
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
                    let exists = false;

                    for (let index = 0; index < listModel_ListViewTreatments.count; index++) {
                        if (listView_Treatments.model.get(index)["treatment_id"] === ufo_ComboBox_Treatments.model.get(ufo_ComboBox_Treatments.currentIndex)["treatment_id"]) {
                            exists = true;
                        }
                    }


                    if(exists) {
                        ufo_StatusBar.displayMessage("A treatment of the same type already exists.")

                        return;
                    }


                    listModel_ListViewTreatments.append({"treatment_id": ufo_ComboBox_Treatments.model.get(ufo_ComboBox_Treatments.currentIndex)["treatment_id"], "name": ufo_ComboBox_Treatments.model.get(ufo_ComboBox_Treatments.currentIndex)["name"]});
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 300

            Layout.topMargin: 2
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            radius: 0

            color: Qt.color(AppTheme.colors["UFO_GroupBox_ListView_Background"])

            ListView {
                id: listView_Treatments

                anchors.fill: parent

                anchors.margins: 15

                spacing: 2
                clip: true

                model: ListModel { id: listModel_ListViewTreatments }

                ScrollBar.vertical: ScrollBar {
                    id: scrollBar_Treatments

                    width: 10
                    policy: ScrollBar.AsNeeded
                }

                delegate: UFO_Delegate_Treatment {
                    width: listView_Treatments.width - scrollBar_Treatments.width / 2

                    treatmentName: model["name"]

                    onRemoveClicked: {
                        listModel_ListViewTreatments.remove(index);
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        listModel_ListViewTreatments.clear();

                        Database.getPatientDataMap()["treatments"].forEach(function (treatment) {
                            listModel_ListViewTreatments.append({"treatment_id": treatment["treatment_id"], "name": treatment["name"]});
                        });
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 25
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("Treatment Note")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            verticalAlignment: Text.AlignBottom

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        ScrollView {
            id: scrollView_TreatmentNote

            Layout.fillWidth: true
            Layout.preferredHeight: 200

            Layout.bottomMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

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
    }

    UFO_GroupBox {
        id: ufo_GroupBox_MedicalDrugs

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Medical Drugs")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("موارد زیر نشان‌دهنده فهرست داروهای پزشکی است که به بیمار اختصاص داده شده‌اند.")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

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
                id: ufo_ComboBox_MedicalDrugs

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "name"

                model: ListModel { id: listModel_ComboBoxMedicalDrugs }

                Connections {
                    target: Database

                    function onMedicalDrugListPopulated() {
                        listModel_ComboBoxMedicalDrugs.clear();

                        Database.getMedicalDrugList().forEach(function (medicalDrug) {
                            listModel_ComboBoxMedicalDrugs.append({"medical_drug_id": medicalDrug["medical_drug_id"], "name": medicalDrug["name"]});
                        });

                        // Set default:
                        ufo_ComboBox_MedicalDrugs.currentIndex = 0;
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        ufo_ComboBox_MedicalDrugs.currentIndex = 0;
                    }
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
                    let exists = false;

                    for (let index = 0; index < listModel_ListViewMedicalDrugs.count; index++) {
                        if (listView_MedicalDrugs.model.get(index)["medical_drug_id"] === ufo_ComboBox_MedicalDrugs.model.get(ufo_ComboBox_MedicalDrugs.currentIndex)["medical_drug_id"]) {
                            exists = true;
                        }
                    }


                    if(exists) {
                        ufo_StatusBar.displayMessage("A medical drug of the same type already exists.")

                        return;
                    }


                    listModel_ListViewMedicalDrugs.append({"medical_drug_id": ufo_ComboBox_MedicalDrugs.model.get(ufo_ComboBox_MedicalDrugs.currentIndex)["medical_drug_id"], "name": ufo_ComboBox_MedicalDrugs.model.get(ufo_ComboBox_MedicalDrugs.currentIndex)["name"]});
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 300

            Layout.topMargin: 2
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            radius: 0

            color: Qt.color(AppTheme.colors["UFO_GroupBox_ListView_Background"])

            ListView {
                id: listView_MedicalDrugs

                anchors.fill: parent

                anchors.margins: 15

                spacing: 2
                clip: true

                model: ListModel { id: listModel_ListViewMedicalDrugs }

                ScrollBar.vertical: ScrollBar {
                    id: scrollBar_MedicalDrugs

                    width: 10
                    policy: ScrollBar.AsNeeded
                }

                delegate: UFO_Delegate_MedicalDrug {
                    width: listView_MedicalDrugs.width - scrollBar_MedicalDrugs.width / 2

                    medicalDrugName: model["name"]

                    onRemoveClicked: {
                        listModel_ListViewMedicalDrugs.remove(index);
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        listModel_ListViewMedicalDrugs.clear();

                        Database.getPatientDataMap()["medicalDrugs"].forEach(function (medicalDrug) {
                            listModel_ListViewMedicalDrugs.append({"medical_drug_id": medicalDrug["medical_drug_id"], "name": medicalDrug["name"]});
                        });
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 25
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("Medical Drug Note")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            verticalAlignment: Text.AlignBottom

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        ScrollView {
            id: scrollView_MedicalDrugNote

            Layout.fillWidth: true
            Layout.preferredHeight: 200

            Layout.bottomMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            ScrollBar.vertical: UFO_ScrollBar {
                parent: scrollView_MedicalDrugNote

                x: scrollView_MedicalDrugNote.mirrored ? 0 : scrollView_MedicalDrugNote.width - width
                y: scrollView_MedicalDrugNote.topPadding

                height: scrollView_MedicalDrugNote.availableHeight

                active: scrollView_MedicalDrugNote.ScrollBar.horizontal.active
            }

            UFO_TextArea {
                id: ufo_TextArea_MedicalDrugNote

                enabled: (Database.connectionStatus === true) ? true : false

                Connections {
                    target: Database

                    function onPatientDataPulled(success, message) {
                        if(success === false) {
                            return;
                        }

                        ufo_TextArea_MedicalDrugNote.text = Database.getPatientDataMap()["medical_drug_note"];
                    }
                }
            }
        }
    }

    UFO_GroupBox {
        id: ufo_GroupBox_Procedures

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Procedures")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("فهرست زیر نمایانگر مجموعه‌ای از اقدامات پزشکی است که به بیمار اختصاص داده شده‌اند.")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

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
                id: ufo_ComboBox_Procedures

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "name"

                model: ListModel { id: listModel_ComboBox_Procedures }

                Connections {
                    target: Database

                    function onProcedureListPopulated() {
                        listModel_ComboBox_Procedures.clear();

                        Database.getProcedureList().forEach(function (procedure) {
                            listModel_ComboBox_Procedures.append({"procedure_id": procedure["procedure_id"], "name": procedure["name"]});
                        });

                        // Set default:
                        ufo_ComboBox_Procedures.currentIndex = 0;
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        ufo_ComboBox_Procedures.currentIndex = 0;
                    }
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
                    let exists = false;

                    for (let index = 0; index < listModel_ListView_Procedures.count; index++) {
                        if (listView_Procedures.model.get(index)["procedure_id"] === ufo_ComboBox_Procedures.model.get(ufo_ComboBox_Procedures.currentIndex)["procedure_id"]) {
                            exists = true;
                        }
                    }


                    if(exists) {
                        ufo_StatusBar.displayMessage("A procedure of the same type already exists.")

                        return;
                    }


                    listModel_ListView_Procedures.append({"procedure_id": ufo_ComboBox_Procedures.model.get(ufo_ComboBox_Procedures.currentIndex)["procedure_id"], "name": ufo_ComboBox_Procedures.model.get(ufo_ComboBox_Procedures.currentIndex)["name"]});
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 300

            Layout.topMargin: 2
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            radius: 0

            color: Qt.color(AppTheme.colors["UFO_GroupBox_ListView_Background"])

            ListView {
                id: listView_Procedures

                anchors.fill: parent

                anchors.margins: 15

                spacing: 2
                clip: true

                model: ListModel { id: listModel_ListView_Procedures }

                ScrollBar.vertical: ScrollBar {
                    id: scrollBar_Procedures

                    width: 10
                    policy: ScrollBar.AsNeeded
                }

                delegate: UFO_Delegate_MedicalDrug {
                    width: listView_Procedures.width - scrollBar_Procedures.width / 2

                    medicalDrugName: model["name"]

                    onRemoveClicked: {
                        listModel_ListView_Procedures.remove(index);
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        listModel_ListView_Procedures.clear();

                        Database.getPatientDataMap()["procedures"].forEach(function (procedure) {
                            listModel_ListView_Procedures.append({"procedure_id": procedure["procedure_id"], "name": procedure["name"]});
                        });
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 25
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("Procedure Note")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            verticalAlignment: Text.AlignBottom

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        ScrollView {
            id: scrollView_ProcedureNote

            Layout.fillWidth: true
            Layout.preferredHeight: 200

            Layout.bottomMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            ScrollBar.vertical: UFO_ScrollBar {
                parent: scrollView_ProcedureNote

                x: scrollView_ProcedureNote.mirrored ? 0 : scrollView_ProcedureNote.width - width
                y: scrollView_ProcedureNote.topPadding

                height: scrollView_ProcedureNote.availableHeight

                active: scrollView_ProcedureNote.ScrollBar.horizontal.active
            }

            UFO_TextArea {
                id: ufo_TextArea_ProcedureNote

                enabled: (Database.connectionStatus === true) ? true : false

                Connections {
                    target: Database

                    function onPatientDataPulled(success, message) {
                        if(success === false) {
                            return;
                        }

                        ufo_TextArea_ProcedureNote.text = Database.getPatientDataMap()["procedure_note"];
                    }
                }
            }
        }
    }

    // TODO (SAVIZ): Have the default on populates be set and then have a onCurrentChangedfor the type combo where every time it changes it will filter the model of the other one based on type selected directly here in qml by looking at teh origin list from C++.
    UFO_GroupBox {
        id: ufo_GroupBox_Consultations

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Consultations")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("The following represents the list of consultations assigned to the patient")

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
                id: ufo_ComboBox_ConsultantName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "consultant_name"

                model: ListModel { id: listModel_UFO_ComboBox_ConsultantName }

                Connections {
                    target: Database

                    function onConsultantListPopulated() {
                        listModel_UFO_ComboBox_ConsultantName.clear();

                        Database.getConsultantList().forEach(function (consultant) {
                            listModel_UFO_ComboBox_ConsultantName.append({"consultant_id": consultant["consultant_id"], "consultant_name": consultant["name"]});
                        });

                        // Set default:
                        ufo_ComboBox_ConsultantName.currentIndex = 0;
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        ufo_ComboBox_ConsultantName.currentIndex = 0;
                    }
                }
            }

            UFO_ComboBox {
                id: ufo_ComboBox_ConsultantSpeciality

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "specialization"

                model: ListModel {
                    id: listModel_UFO_ComboBox_ConsultantSpeciality

                    ListElement { specialization: "All" }
                    ListElement { specialization: "Optometrist" }
                    ListElement { specialization: "Dentist" }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        ufo_ComboBox_ConsultantSpeciality.currentIndex = 0;
                    }
                }

                onActivated:  {
                    listModel_UFO_ComboBox_ConsultantName.clear();

                    if(ufo_ComboBox_ConsultantSpeciality.currentText === "All") {
                        Database.getConsultantList().forEach(function (consultant) {
                            listModel_UFO_ComboBox_ConsultantName.append({"consultant_id": consultant["consultant_id"], "consultant_name": consultant["name"]});
                        });
                    }

                    else {
                        Database.getConsultantList().forEach(function (consultant) {
                            if(consultant["consultant_specialization"] === ufo_ComboBox_ConsultantSpeciality.currentText) {
                                listModel_UFO_ComboBox_ConsultantName.append({"consultant_id": consultant["consultant_id"], "consultant_name": consultant["name"]});
                            }
                        });
                    }

                    ufo_ComboBox_ConsultantName.currentIndex = 0
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
                    listModel_ListView_Consultations.append({"consultant_id": ufo_ComboBox_ConsultantName.model.get(ufo_ComboBox_ConsultantName.currentIndex)["consultant_id"], "consultant_name": ufo_ComboBox_ConsultantName.model.get(ufo_ComboBox_ConsultantName.currentIndex)["consultant_name"], "consultation_date": "", "consultation_outcome": ""});
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
                id: listView_Consultations

                anchors.fill: parent

                anchors.margins: 15

                spacing: 5
                clip: true

                model: ListModel { id: listModel_ListView_Consultations }

                ScrollBar.vertical: ScrollBar {
                    id: scrollBar_Consultations

                    width: 10
                    policy: ScrollBar.AsNeeded
                }

                delegate: UFO_Delegate_Consultation {
                    width: listView_Consultations.width - scrollBar_Consultations.width / 2

                    consultantName: model["consultant_name"]
                    consultationConductedDate: model["consultation_date"]
                    consultationOutcome: model["consultation_outcome"]

                    onRemoveClicked: {
                        listModel_ListView_Consultations.remove(index);
                    }

                    onDateChanged: {
                        model["consultation_date"] = consultationConductedDate.trim();
                    }

                    onOutcomeChanged: {
                        model["consultation_outcome"] = consultationOutcome.trim();
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        listModel_ListView_Consultations.clear();

                        Database.getPatientDataMap()["consultations"].forEach(function (consultation) {
                            listModel_ListView_Consultations.append({"consultant_id": consultation["consultant_id"], "consultant_name": consultation["consultant_name"], "consultation_date": consultation["consultation_date"], "consultation_outcome": consultation["consultation_outcome"]});
                        });
                    }
                }
            }
        }
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



                for (let i = 0; i < listModel_ListViewTreatments.count; i++) {
                    treatments.push(listModel_ListViewTreatments.get(i)["treatment_id"]);
                }

                for (let z = 0; z < listModel_ListViewMedicalDrugs.count; z++) {
                    medicalDrugs.push(listModel_ListViewMedicalDrugs.get(z)["medical_drug_id"]);
                }

                for (let h = 0; h < listModel_ListView_Procedures.count; h++) {
                    procedures.push(listModel_ListView_Procedures.get(h)["procedure_id"]);
                }


                // Notes:
                let diagnosisNote = ufo_TextArea_DiagnosisNote.text.trim();
                let treatmentNote = ufo_TextArea_TreatmentNote.text.trim();
                let medicalDrugNote = ufo_TextArea_MedicalDrugNote.text.trim();
                let procedureNote = ufo_TextArea_ProcedureNote.text.trim();

                let consultations = [];

                for (let a = 0; a < listModel_ListView_Consultations.count; a++) {
                    let item = listModel_ListView_Consultations.get(a);

                    consultations.push({
                        consultant_id: item.consultant_id,
                        consultation_date: item.consultation_date,
                        consultation_outcome: item.consultation_outcome
                    });
                }

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
