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

    function getListOfDiagnoses() {
        let diagnoses = [];

        for (let index = 0; index < listModel_ListView.count; index++) {
            diagnoses.push(listModel_ListView.get(index)["diagnosis_id"]);
        }

        return (diagnoses);
    }

    function getDiagnosisNote() {
        return (ufo_TextArea.text.trim());
    }

    UFO_GroupBox {
        id: ufo_GroupBox

        anchors.fill: parent

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

            spacing: 3

            UFO_ComboBox {
                id: ufo_ComboBox

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "diagnosis_name"

                canFilter: true
                proxyModel: ListModel { id: ufo_ComboBox_Model }

                Connections {
                    target: Database

                    function onConnectionStatusChanged(message) {

                        if(Database.connectionStatus === false) {
                            return;
                        }

                        ufo_ComboBox_Model.clear();

                        Database.getDiagnosisList().forEach(function (diagnosis) {
                            ufo_ComboBox_Model.append({"diagnosis_id": diagnosis["diagnosis_id"], "diagnosis_name": diagnosis["diagnosis_name"]});
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
                    let currentText = ufo_ComboBox.currentText;

                    if (!currentText || currentText.trim() === "") {
                        console.log("No valid selection");
                        return;
                    }

                    // Check if diagnosis_name already exists in listView model
                    let exists = false;
                    for (let index = 0; index < listModel_ListView.count; index++) {
                        if (listView.model.get(index)["diagnosis_name"] === currentText) {
                            exists = true;
                            break;
                        }
                    }

                    if (exists) {
                        ufo_StatusBar.displayMessage("A diagnosis of the same type already exists.", 8000);
                        return;
                    }

                    // Find the corresponding diagnosis_id
                    let proxyIndex = ufo_ComboBox.currentIndex;
                    let diagnosisId = ufo_ComboBox.model.data(ufo_ComboBox.model.index(proxyIndex, 0), "diagnosis_id");

                    // Append the new diagnosis to listModel_ListView
                    listModel_ListView.append({
                        "diagnosis_id": diagnosisId,
                        "diagnosis_name": currentText
                    });
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

                delegate: UFO_Delegate_Diagnosis {
                    width: listView.width - scrollBar.width / 2 - 15

                    diagnosisName: model["diagnosis_name"]

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

                        Database.getPatientDataMap()["diagnoses"].forEach(function (diagnosis) {
                            listModel_ListView.append({"diagnosis_id": diagnosis["diagnosis_id"], "diagnosis_name": diagnosis["diagnosis_name"]});
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

                        ufo_TextArea.text = Database.getPatientDataMap()["diagnosis_note"];
                    }
                }
            }
        }
    }
}
