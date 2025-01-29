import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components"

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0
import Date 1.0

Item {
    id: root

    implicitWidth: 200
    implicitHeight: ufo_GroupBox.implicitHeight

    function getListOfMedicalDrugs() {
        let medical_drugs = [];

        for (let index = 0; index < listModel_ListView.count; index++) {
            medical_drugs.push(listModel_ListView.get(index)["medical_drug_id"]);
        }

        return (medical_drugs);
    }

    function getMedicalDrugNote() {
        return (ufo_TextArea.text.trim());
    }

    UFO_GroupBox {
        id: ufo_GroupBox

        anchors.fill: parent

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

            spacing: 3

            UFO_ComboBox {
                id: ufo_ComboBox

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "medical_drug_name"

                canFilter: true
                proxyModel: ListModel { id: ufo_ComboBox_Model }

                Connections {
                    target: Database

                    function onConnectionStatusChanged(message) {

                        if(Database.connectionStatus === false) {
                            return;
                        }

                        ufo_ComboBox_Model.clear();

                        Database.getMedicalDrugList().forEach(function (medical_drug) {
                            ufo_ComboBox_Model.append({"medical_drug_id": medical_drug["medical_drug_id"], "medical_drug_name": medical_drug["medical_drug_name"]});
                        });

                        // Set default:
                        ufo_ComboBox.currentIndex = 0;
                    }
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

                        ufo_ComboBox.currentIndex = 0;
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

                    let sourceIndex;

                    for (let index = 0; index < listModel_ListView.count; index++) {

                        sourceIndex = ufo_ComboBox.model.mapToSourceIndex(ufo_ComboBox.currentIndex);

                        if (listView.model.get(index)["medical_drug_id"] === ufo_ComboBox_Model.get(sourceIndex)["medical_drug_id"]) {
                            exists = true;
                            break;
                        }
                    }

                    if(exists) {
                        ufo_StatusBar.displayMessage("A medical drug of the same type already exists.", 8000)

                        return;
                    }

                    listModel_ListView.append({"medical_drug_id": ufo_ComboBox_Model.get(sourceIndex)["medical_drug_id"], "medical_drug_name": ufo_ComboBox_Model.get(sourceIndex)["medical_drug_name"]});
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 250

            Layout.topMargin: 5
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            radius: 0

            color: Qt.color(AppTheme.colors["UFO_GroupBox_ListView_Background"])

            ListView {
                id: listView

                anchors.fill: parent

                anchors.margins: 15

                spacing: 5
                clip: true

                model: ListModel { id: listModel_ListView }

                ScrollBar.vertical: ScrollBar {
                    id: scrollBar

                    width: 10
                    policy: ScrollBar.AlwaysOn
                }

                delegate: UFO_Delegate_MedicalDrug {
                    width: listView.width - scrollBar.width / 2 - 15

                    medicalDrugName: model["medical_drug_name"]

                    onRemoveClicked: {
                        listModel_ListView.remove(index);
                    }
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

                        listModel_ListView.clear();

                        Database.getPatientDataMap()["medicalDrugs"].forEach(function (medicalDrug) {
                            listModel_ListView.append({"medical_drug_id": medicalDrug["medical_drug_id"], "medical_drug_name": medicalDrug["medical_drug_name"]});
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

            text: qsTr("یادداشت")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            verticalAlignment: Text.AlignBottom

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        ScrollView {
            id: scrollView

            Layout.fillWidth: true
            Layout.preferredHeight: 150

            Layout.bottomMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            ScrollBar.vertical: UFO_ScrollBar {
                parent: scrollView

                x: scrollView.mirrored ? 0 : scrollView.width - width
                y: scrollView.topPadding

                height: scrollView.availableHeight

                active: scrollView.ScrollBar.horizontal.active
            }

            UFO_TextArea {
                id: ufo_TextArea

                enabled: (Database.connectionStatus === true) ? true : false

                Connections {
                    target: Database

                    function onQueryExecuted(type, success, message) {
                        if(type !== Database.QueryType.SELECT) {
                            return;
                        }

                        if(success === false) {
                            return;
                        }

                        ufo_TextArea.text = Database.getPatientDataMap()["medical_drug_note"];
                    }
                }
            }
        }
    }
}
