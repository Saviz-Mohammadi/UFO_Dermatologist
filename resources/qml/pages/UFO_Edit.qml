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

    title: qsTr("ویرایش")
    contentSpacing: 25

    contentVisible: false

    UFO_Button {
        id: ufo_Button_MarkedForDeletion

        Layout.preferredHeight: 40

        enabled: (Database.connectionStatus === true) ? true : false

        text: qsTr("علامت‌گذاری شده برای حذف")
        icon.source: "./../../icons/Google icons/delete.svg"
        checkable: true

        Connections {
            target: Database

            function onPatientDataPulled(success, message) {
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

    UFO_GroupBox {
        id: ufo_GroupBox_PersonalInformation

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("اطلاعات پایه")
        contentSpacing: 2

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

                text: qsTr("شماره پرونده ()")

                verticalAlignment: Text.AlignVCenter

                color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            }

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    text_PatinetID.text = qsTr("شماره پرونده (") + Database.getPatientDataMap()["patient_id"] + qsTr(")");
                }
            }
        }

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 30
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("نام")

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

            text: qsTr("نام خانوادگی")

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

            text: qsTr("سال تولد")

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

            text: qsTr("شماره تلفن")

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

            Layout.topMargin: 45
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("جنسیت")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

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
            model: ["نامشخص", "مرد", "زن"]

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    switch (Database.getPatientDataMap()["gender"]) {
                        case "نامشخص":
                            comboBox_Gender.currentIndex = 0;
                            break;
                        case "مرد":
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

            text: qsTr("وضعیت تأهل")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

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
            model: ["نامشخص", "مجرد", "متاهل"]

            Connections {
                target: Database

                function onPatientDataPulled(success, message) {
                    if(success === false) {
                        return;
                    }

                    switch (Database.getPatientDataMap()["marital_status"]) {
                        case "نامشخص":
                            comboBox_Gender.currentIndex = 0;
                            break;
                        case "مجرد":
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

            Layout.topMargin: 45
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("تعداد بازدیدهای قبلی")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

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

            text: qsTr("تاریخ اولین بازدید")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

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

            text: qsTr("تاریخ آخرین بازدید")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

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

            Layout.topMargin: 45
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("قیمت خدمات")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

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
        id: ufo_GroupBox_Diagnoses

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Diagnoses")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("موارد زیر نشان‌دهنده فهرست تشخیص‌هایی است که به بیمار اختصاص داده شده‌اند.")

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
                id: ufo_ComboBox_Diagnoses

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "name"

                model: ListModel { id: listModel_ComboBoxDiagnoses }

                Connections {
                    target: Database

                    function onDiagnosisListPopulated() {
                        listModel_ComboBoxDiagnoses.clear();

                        Database.getDiagnosisList().forEach(function (diagnosis) {
                            listModel_ComboBoxDiagnoses.append({"diagnosis_id": diagnosis["diagnosis_id"], "name": diagnosis["name"]});
                        });

                        // Set default:
                        ufo_ComboBox_Diagnoses.currentIndex = 0;
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        ufo_ComboBox_Diagnoses.currentIndex = 0;
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

                    for (let index = 0; index < listModel_ListViewDiagnoses.count; index++) {
                        if (listView_Diagnoses.model.get(index)["diagnosis_id"] === ufo_ComboBox_Diagnoses.model.get(ufo_ComboBox_Diagnoses.currentIndex)["diagnosis_id"]) {
                            exists = true;
                        }
                    }


                    if(exists) {
                        ufo_StatusBar.displayMessage("A diagnosis of the same type already exists.")

                        return;
                    }


                    listModel_ListViewDiagnoses.append({"diagnosis_id": ufo_ComboBox_Diagnoses.model.get(ufo_ComboBox_Diagnoses.currentIndex)["diagnosis_id"], "diagnosis_name": ufo_ComboBox_Diagnoses.model.get(ufo_ComboBox_Diagnoses.currentIndex)["diagnosis_name"]});
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
                id: listView_Diagnoses

                anchors.fill: parent

                anchors.margins: 15

                spacing: 2
                clip: true

                model: ListModel { id: listModel_ListViewDiagnoses }

                ScrollBar.vertical: ScrollBar {
                    id: scrollBar_Diagnoses

                    width: 10
                    policy: ScrollBar.AsNeeded
                }

                delegate: UFO_Delegate_Diagnosis {
                    width: listView_Diagnoses.width - scrollBar_Diagnoses.width / 2

                    diagnosisName: model["diagnosis_name"]

                    onRemoveClicked: {
                        listModel_ListViewDiagnoses.remove(index);
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        listModel_ListViewDiagnoses.clear();

                        Database.getPatientDataMap()["diagnoses"].forEach(function (diagnosis) {
                            listModel_ListViewDiagnoses.append({"diagnosis_id": diagnosis["diagnosis_id"], "diagnosis_name": diagnosis["diagnosis_name"]});
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

            text: qsTr("Diagnosis Note")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            verticalAlignment: Text.AlignBottom

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        ScrollView {
            id: scrollView_DiagnosisNote

            Layout.fillWidth: true
            Layout.preferredHeight: 200

            Layout.bottomMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            ScrollBar.vertical: UFO_ScrollBar {
                parent: scrollView_DiagnosisNote

                x: scrollView_DiagnosisNote.mirrored ? 0 : scrollView_DiagnosisNote.width - width
                y: scrollView_DiagnosisNote.topPadding

                height: scrollView_DiagnosisNote.availableHeight

                active: scrollView_DiagnosisNote.ScrollBar.horizontal.active
            }

            UFO_TextArea {
                id: ufo_TextArea_DiagnosisNote

                enabled: (Database.connectionStatus === true) ? true : false

                Connections {
                    target: Database

                    function onPatientDataPulled(success, message) {
                        if(success === false) {
                            return;
                        }

                        ufo_TextArea_DiagnosisNote.text = Database.getPatientDataMap()["diagnosis_note"];
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


                    listModel_ListViewTreatments.append({"treatment_id": ufo_ComboBox_Treatments.model.get(ufo_ComboBox_Treatments.currentIndex)["treatment_id"], "treatment_name": ufo_ComboBox_Treatments.model.get(ufo_ComboBox_Treatments.currentIndex)["treatment_name"]});
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

                    treatmentName: model["treatment_name"]

                    onRemoveClicked: {
                        listModel_ListViewTreatments.remove(index);
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        listModel_ListViewTreatments.clear();

                        Database.getPatientDataMap()["treatments"].forEach(function (treatment) {
                            listModel_ListViewTreatments.append({"treatment_id": treatment["treatment_id"], "treatment_name": treatment["treatment_name"]});
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


                    listModel_ListViewMedicalDrugs.append({"medical_drug_id": ufo_ComboBox_MedicalDrugs.model.get(ufo_ComboBox_MedicalDrugs.currentIndex)["medical_drug_id"], "medical_drug_name": ufo_ComboBox_MedicalDrugs.model.get(ufo_ComboBox_MedicalDrugs.currentIndex)["medical_drug_name"]});
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

                    medicalDrugName: model["medical_drug_name"]

                    onRemoveClicked: {
                        listModel_ListViewMedicalDrugs.remove(index);
                    }
                }

                Connections {
                    target: Database

                    function onPatientDataPulled() {
                        listModel_ListViewMedicalDrugs.clear();

                        Database.getPatientDataMap()["medicalDrugs"].forEach(function (medicalDrug) {
                            listModel_ListViewMedicalDrugs.append({"medical_drug_id": medicalDrug["medical_drug_id"], "medical_drug_name": medicalDrug["medical_drug_name"]});
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
                            listModel_UFO_ComboBox_ConsultantName.append({"consultant_id": consultant["consultant_id"], "consultant_name": consultant["consultant_name"]});
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

                textRole: "speciality"

                model: ListModel {
                    id: listModel_UFO_ComboBox_ConsultantSpeciality

                    ListElement { speciality: "All" }
                    ListElement { speciality: "Optometrist" }
                    ListElement { speciality: "Dentist" }
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
                            listModel_UFO_ComboBox_ConsultantName.append({"consultant_id": consultant["consultant_id"], "consultant_name": consultant["consultant_name"]});
                        });
                    }

                    else {
                        Database.getConsultantList().forEach(function (consultant) {
                            if(consultant["consultant_speciality"] === ufo_ComboBox_ConsultantSpeciality.currentText) {
                                listModel_UFO_ComboBox_ConsultantName.append({"consultant_id": consultant["consultant_id"], "consultant_name": consultant["consultant_name"]});
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
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            radius: 0

            color: Qt.color(AppTheme.colors["UFO_GroupBox_ListView_Background"])

            ListView {
                id: listView_Consultations

                anchors.fill: parent

                anchors.margins: 15

                spacing: 2
                clip: true

                model: ListModel { id: listModel_ListView_Consultations }

                ScrollBar.vertical: ScrollBar {
                    id: scrollBar_Consultations

                    width: 10
                    policy: ScrollBar.AsNeeded
                }

                // delegate: UFO_Delegate_Consultation {
                //     width: listView_Consultations.width - scrollBar_Consultations.width / 2

                //     consultantName: model["consultant_name"]
                //     consultationConductedDate: model["consultation_date"]
                //     consultationOutcome: model["consultation_outcome"]

                //     onRemoveClicked: {
                //         listModel_ListView_Consultations.remove(index);
                //     }

                //     onDateChanged: {
                //         model["consultation_date"] = consultationConductedDate.trim();
                //     }

                //     onOutcomeChanged: {
                //         model["consultation_outcome"] = consultationOutcome.trim();
                //     }
                // }

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
                let first_name = textField_FirstName.text.trim();
                let last_name = textField_LastName.text.trim();
                let birthYear = parseInt(textField_BirthYear.text.trim(), 10);
                let phone_number = textField_PhoneNumber.text.trim();
                let gender = gender = comboBox_Gender.currentText;
                let marital_status = comboBox_MaritalStatus.currentText;
                let numberOfPreviousVisits = parseInt(textField_NumberOfPreviousVisits.text.trim(), 10);
                let firstVisitDate = textField_FirstVisitDate.text.trim();
                let recentVisitDate = textField_RecentVisitDate.text.trim();
                let servicePrice = parseFloat(textField_ServicePrice.text.trim());


                // Lists:
                let diagnoses = [];
                let treatments = [];
                let medicalDrugs = [];

                for (let j = 0; j < listModel_ListViewDiagnoses.count; j++) {
                    diagnoses.push(listModel_ListViewDiagnoses.get(j)["diagnosis_id"]);
                }

                for (let i = 0; i < listModel_ListViewTreatments.count; i++) {
                    treatments.push(listModel_ListViewTreatments.get(i)["treatment_id"]);
                }

                for (let z = 0; z < listModel_ListViewMedicalDrugs.count; z++) {
                    medicalDrugs.push(listModel_ListViewMedicalDrugs.get(z)["medical_drug_id"]);
                }


                // Notes:
                let diagnosisNote = ufo_TextArea_DiagnosisNote.text.trim();
                let treatmentNote = ufo_TextArea_TreatmentNote.text.trim();
                let medicalDrugNote = ufo_TextArea_MedicalDrugNote.text.trim();

                // After populating the lists, print them to the console for debugging
                console.log("Diagnoses:", JSON.stringify(diagnoses));
                console.log("Treatments:", JSON.stringify(treatments));
                console.log("Medical Drugs:", JSON.stringify(medicalDrugs));


                let consultations = [];

                for (let a = 0; a < listModel_ListView_Consultations.count; a++) {
                    let item = listModel_ListView_Consultations.get(a);

                    consultations.push({
                        consultant_id: item.consultant_id,
                        consultation_date: item.consultation_date,
                        consultation_outcome: item.consultation_outcome
                    });
                }

                console.log("Consultations:", JSON.stringify(consultations));

                // Push:
                Database.updatePatientData(first_name, last_name, birthYear, phone_number, gender, marital_status, numberOfPreviousVisits, firstVisitDate, recentVisitDate, servicePrice, diagnoses, diagnosisNote, treatments, treatmentNote, medicalDrugs, medicalDrugNote, consultations);
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

// TODO (SAVIZ): You need to come up with someway to show or hide the page for the first time, when the patient is not selected yet, other wise pressing the buttons can cause issues.
// TODO (SAVIZ): There is a problem with dates first and recent in C++, check it out.
