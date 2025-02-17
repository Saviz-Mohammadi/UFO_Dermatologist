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

    signal patientSelectedForEdit

    title: qsTr("تاریخچه جستجو")
    contentSpacing: 25

    UFO_GroupBox {
        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("اطلاعات بیمار")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true

            text: qsTr("شماره پرونده")

            elide: Text.ElideRight
            wrapMode: Text.NoWrap

            verticalAlignment: Text.AlignBottom

            font.pixelSize: Qt.application.font.pixelSize * 1
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
        }

        UFO_TextField {
            id: ufo_TextField_ID
        }

        RowLayout {
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
            }

            UFO_Button {
                id: ufo_Button_Add

                text: qsTr("افزودن")

                onClicked: {
                    let id = parseInt(ufo_TextField_ID.text.trim(), 10);

                    if(isNaN(id)) {
                        return;
                        // TODO (SAVIZ): Show something here...
                    }

                    let status = Database.addHistory();

                    // Make a QVariantList and set it to model
                    if(status === true) {

                    }
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: root.height - 325

        radius: 0

        color: Qt.color(AppTheme.colors["UFO_ListView_Background"])

        ListView {
            id: listView_SearchResults

            anchors.fill: parent

            anchors.margins: 15

            spacing: 2
            clip: true

            model: ListModel { id: listModel_SearchResults }

            ScrollBar.vertical: ScrollBar {
                id: scrollBar

                width: 10
                policy: ScrollBar.AsNeeded
            }

            delegate: UFO_Delegate_Search {
                width: listView_SearchResults.width - scrollBar.width / 2

                patientId: model.patient_id
                header: model.first_name + " " + model.last_name

                onEditClicked: {
                    Database.pullPatientData(model.patient_id)

                    root.patientSelectedForEdit()
                }
            }

            Connections {
                target: Database

                function onQueryExecuted(type, success, message) {
                    if(type !== Database.QueryType.SEARCH) {
                        return;
                    }

                    if(success === false) {
                        return;
                    }

                    listModel_SearchResults.clear();

                    Database.getSearchResultList().forEach(function (searchResult) {
                        listModel_SearchResults.append({
                            "patient_id": searchResult["patient_id"],
                            "first_name": searchResult["first_name"],
                            "last_name": searchResult["last_name"]
                        });
                    })
                }
            }

            Connections {
                target: ufo_Button_Clear

                function onClicked() {
                    listModel_SearchResults.clear();
                }
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true

        Item {
            Layout.fillWidth: true
        }

        UFO_Button {
            id: ufo_Button_Clear

            onClicked: {
                // Call Database clear.
            }
        }

        UFO_Button {
            id: ufo_Button_Sync

            onClicked: {
                // Call Database Sync.
            }
        }
    }
}
