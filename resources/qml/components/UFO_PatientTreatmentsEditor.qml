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

    function getListOfTreatments() {
        let treatments = [];

        for (let index = 0; index < listModel_ListView.count; index++) {
            treatments.push(listModel_ListView.get(index)["treatment_id"]);
        }

        return (treatments);
    }

    function getTreatmentNote() {
        return (ufo_TextArea.text.trim());
    }

    UFO_GroupBox {
        id: ufo_GroupBox

        anchors.fill: parent

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

            spacing: 3

            UFO_ComboBox {
                id: ufo_ComboBox

                Layout.fillWidth: true
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                textRole: "treatment_name"

                canFilter: true
                proxyModel: ListModel { id: ufo_ComboBox_Model }

                Connections {
                    target: Database

                    function onConnectionStatusChanged(message) {

                        if(Database.connectionStatus === false) {
                            return;
                        }

                        ufo_ComboBox_Model.clear();

                        Database.getTreatmentList().forEach(function (treatment) {
                            ufo_ComboBox_Model.append({"treatment_id": treatment["treatment_id"], "treatment_name": treatment["treatment_name"]});
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
                    let proxyIndex = ufo_ComboBox.currentIndex;

                    let id = ufo_ComboBox.model.sourceData(proxyIndex, "treatment_id");
                    let name = ufo_ComboBox.model.sourceData(proxyIndex, "treatment_name");

                    let exists = false;

                    for (let index = 0; index < listModel_ListView.count; index++) {
                        if (listView.model.get(index)["treatment_id"] === id) {
                            exists = true;
                            break;
                        }
                    }

                    if (exists) {
                        ufo_StatusBar.displayMessage("A treatment of the same type already exists.", 8000);
                        return;
                    }

                    listModel_ListView.append({
                        "treatment_id": id,
                        "treatment_name": name
                    });
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 300

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

                delegate: UFO_Delegate_Treatment {
                    width: listView.width - scrollBar.width / 2 - 15

                    treatmentName: model["treatment_name"]

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

                        Database.getPatientDataMap()["treatments"].forEach(function (treatment) {
                            listModel_ListView.append({"treatment_id": treatment["treatment_id"], "treatment_name": treatment["treatment_name"]});
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

                        ufo_TextArea.text = Database.getPatientDataMap()["treatment_note"];
                    }
                }
            }
        }
    }
}
