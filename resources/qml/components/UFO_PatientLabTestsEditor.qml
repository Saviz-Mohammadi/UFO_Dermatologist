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

    function getListOfLabTests() {
        let labTests = [];

        for (let index = 0; index < listModel_ListView.count; index++) {
            let item = listModel_ListView.get(index);

            labTests.push({
                lab_id: item.lab_id,
                lab_test_date: item.lab_test_date,
                lab_test_outcome: item.lab_test_outcome
            });
        }

        return (labTests);
    }

    UFO_GroupBox {
        id: ufo_GroupBox

        anchors.fill: parent

        title: qsTr("Lab Tests")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("عبارت زیر لیست آزمایش‌های تعیین‌شده برای بیمار را نشان می‌دهد.")

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
                id: ufo_ComboBox_LabName

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "lab_name"

                canFilter: true
                proxyModel: ListModel { id: listModel_ComboBox_LabName }

                Connections {
                    target: Database

                    function onConnectionStatusChanged(message) {

                        if(Database.connectionStatus === false) {
                            return;
                        }

                        listModel_ComboBox_LabName.clear();

                        Database.getLabList().forEach(function (lab) {
                            listModel_ComboBox_LabName.append({"lab_id": lab["lab_id"], "lab_name": lab["lab_name"], "lab_specialization": lab["lab_specialization"]});
                        });

                        // Set default:
                        ufo_ComboBox_LabName.currentIndex = 0;
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

                        ufo_ComboBox_LabName.currentIndex = 0;
                    }
                }
            }

            UFO_ComboBox {
                id: ufo_ComboBox_LabSpecialization

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

                        ufo_ComboBox_LabSpecialization.currentIndex = 0;
                    }
                }

                onActivated: {
                    listModel_ComboBox_LabName.clear();

                    if(ufo_ComboBox_LabSpecialization.currentText === "All") {
                        Database.getLabList().forEach(function (lab) {
                            listModel_ComboBox_LabName.append({"lab_id": lab["lab_id"], "lab_name": lab["lab_name"], "lab_specialization": lab["lab_specialization"]});
                        });
                    }

                    else {
                        Database.getLabList().forEach(function (lab) {
                            if(lab["lab_specialization"] === ufo_ComboBox_LabSpecialization.currentText) {
                                listModel_ComboBox_LabName.append({"lab_id": lab["lab_id"], "lab_name": lab["lab_name"], "lab_specialization": lab["lab_specialization"]});
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
                    let proxyIndex = ufo_ComboBox_LabName.currentIndex;

                    let id = ufo_ComboBox_LabName.model.sourceData(proxyIndex, "lab_id");
                    let name = ufo_ComboBox_LabName.model.sourceData(proxyIndex, "lab_name");
                    let specialization = ufo_ComboBox_LabName.model.sourceData(proxyIndex, "lab_specialization");

                    listModel_ListView.append({
                        "lab_id": id,
                        "lab_name": name,
                        "lab_specialization": specialization,
                        "lab_test_date": "",
                        "lab_test_outcome": ""
                    });
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 500

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
                    id: scrollBar_LabTests

                    width: 10
                    policy: ScrollBar.AlwaysOn
                }

                delegate: UFO_Delegate_LabTest {
                    width: listView.width - scrollBar_LabTests.width / 2 - 15

                    onRemoveClicked: {
                        listModel_ListView.remove(index);
                    }

                    onDateChanged: {
                        model["lab_test_date"] = labTestDate.trim();
                    }

                    onOutcomeChanged: {
                        model["lab_test_outcome"] = labTestOutcome.trim();
                    }

                    // NOTE (SAVIZ): This technically works and gets called everytime, because the list gets cleared with every SELECT query. Therefore the data will be refreshed.
                    Component.onCompleted: {
                        labName = model["lab_name"]
                        labSpecialization = model["lab_specialization"]
                        labTestDate = model["lab_test_date"]
                        labTestOutcome = model["lab_test_outcome"]
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

                        Database.getPatientDataMap()["labTests"].forEach(function (labTest) {
                            listModel_ListView.append({"lab_id": labTest["lab_id"], "lab_name": labTest["lab_name"], "lab_specialization": labTest["lab_specialization"], "lab_test_date": labTest["lab_test_date"], "lab_test_outcome": labTest["lab_test_outcome"]});
                        });
                    }
                }
            }
        }
    }
}
