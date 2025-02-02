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

    function getListOfConsultations() {
        let consultations = [];

        for (let index = 0; index < listModel_ListView.count; index++) {
            let item = listModel_ListView.get(index);

            consultations.push({
                consultant_id: item.consultant_id,
                consultation_date: item.consultation_date,
                consultation_outcome: item.consultation_outcome
            });
        }

        return (consultations);
    }

    UFO_GroupBox {
        id: ufo_GroupBox

        anchors.fill: parent

        title: qsTr("Consultations")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("عبارت زیر فهرست مشاوره‌های اختصاص داده شده به بیمار را نشان می‌دهد.")

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
                id: ufo_ComboBox_ConsultantName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "consultant_name"

                canFilter: true
                proxyModel: ListModel { id: listModel_ComboBox_ConsultantName }

                Connections {
                    target: Database

                    function onConnectionStatusChanged(message) {

                        if(Database.connectionStatus === false) {
                            return;
                        }

                        listModel_ComboBox_ConsultantName.clear();

                        Database.getConsultantList().forEach(function (consultant) {
                            listModel_ComboBox_ConsultantName.append({"consultant_id": consultant["consultant_id"], "consultant_name": consultant["consultant_name"], "consultant_specialization": consultant["consultant_specialization"]});
                        });

                        // Set default:
                        ufo_ComboBox_ConsultantName.currentIndex = 0;
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

                        ufo_ComboBox_ConsultantName.currentIndex = 0;
                    }
                }
            }

            UFO_ComboBox {
                id: ufo_ComboBox_ConsultantSpecialization

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "specialization"

                canFilter: true
                proxyModel: ListModel {
                    id: listModel_ComboBox_LabSpeciality

                    ListElement { specialization: "All" }
                    ListElement { specialization: "Optometrist" }
                    ListElement { specialization: "Dentist" }
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

                        ufo_ComboBox_ConsultantSpecialization.currentIndex = 0;
                    }
                }

                onActivated: {
                    listModel_ComboBox_ConsultantName.clear();

                    if(ufo_ComboBox_ConsultantSpecialization.currentText === "All") {
                        Database.getConsultantList().forEach(function (consultant) {
                            listModel_ComboBox_ConsultantName.append({"consultant_id": consultant["consultant_id"], "consultant_name": consultant["consultant_name"], "consultant_specialization": consultant["consultant_specialization"]});
                        });
                    }

                    else {
                        Database.getConsultantList().forEach(function (consultant) {
                            if(consultant["consultant_specialization"] === ufo_ComboBox_ConsultantSpecialization.currentText) {
                                listModel_ComboBox_ConsultantName.append({"consultant_id": consultant["consultant_id"], "consultant_name": consultant["consultant_name"], "consultant_specialization": consultant["consultant_specialization"]});
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
                    let proxyIndex = ufo_ComboBox_ConsultantName.currentIndex;

                    let id = ufo_ComboBox_ConsultantName.model.sourceData(proxyIndex, "consultant_id");
                    let name = ufo_ComboBox_ConsultantName.model.sourceData(proxyIndex, "consultant_name");
                    let specialization = ufo_ComboBox_ConsultantName.model.sourceData(proxyIndex, "consultant_specialization");

                    listModel_ListView.append({
                        "consultant_id": id,
                        "consultant_name": name,
                        "consultant_specialization": specialization,
                        "consultation_date": "",
                        "consultation_outcome": ""
                    });
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 250

            Layout.topMargin: 5
            Layout.bottomMargin: 15
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
                    id: scrollBar_Consultations

                    width: 10
                    policy: ScrollBar.AlwaysOn
                }

                delegate: UFO_Delegate_Consultation {
                    width: listView.width - scrollBar_Consultations.width / 2 - 15

                    onRemoveClicked: {
                        listModel_ListView.remove(index);
                    }

                    onDateChanged: {
                        model["consultation_date"] = consultationDate.trim();
                    }

                    onOutcomeChanged: {
                        model["consultation_outcome"] = consultationOutcome.trim();
                    }

                    // NOTE (SAVIZ): This technically works and gets called everytime, because the list gets cleared with every SELECT query. Therefore the data will be refreshed.
                    Component.onCompleted: {
                        consultantName = model["consultant_name"]
                        consultantSpecialization = model["consultant_specialization"]
                        consultationDate = model["consultation_date"]
                        consultationOutcome = model["consultation_outcome"]
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

                        Database.getPatientDataMap()["consultations"].forEach(function (consultation) {
                            listModel_ListView.append({"consultant_id": consultation["consultant_id"], "consultant_name": consultation["consultant_name"], "consultant_specialization": consultation["consultant_specialization"], "consultation_date": consultation["consultation_date"], "consultation_outcome": consultation["consultation_outcome"]});
                        });
                    }
                }
            }
        }
    }
}
