import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components"

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

UFO_SplitView {
    id: root

    signal patientSelectedForEdit

    UFO_Page {
        Layout.fillWidth: true
        Layout.fillHeight: true

        title: qsTr("جستوجو")
        contentSpacing: 25

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.height - 100

            radius: 0

            color: Qt.color(AppTheme.colors["UFO_ListView_Background"])

            Rectangle {
                id: rectangle_Title

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                height: 50

                radius: 0
                color: Qt.color(AppTheme.colors["UFO_ListView_Title_Background"])

                RowLayout {
                    anchors.fill: parent

                    Text {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Layout.margins: 15

                        text: qsTr("Search Results : ") + listView_SearchResults.count
                        color: Qt.color(AppTheme.colors["UFO_ListView_Title_Text"])
                    }
                }
            }


            ListView {
                id: listView_SearchResults

                anchors.top: rectangle_Title.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

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
                    birthYear: model.birth_year
                    phoneNumber: model.phone_number
                    gender: model.gender
                    maritalStatus: model.marital_status
                    servicePrice: model.service_price


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
                                "last_name": searchResult["last_name"],
                                "birth_year": searchResult["birth_year"],
                                "phone_number": searchResult["phone_number"],
                                "gender": searchResult["gender"],
                                "marital_status": searchResult["marital_status"],
                                "service_price": searchResult["service_price"]
                            });
                        })
                    }
                }

                Connections {
                    target: ufo_SideBar_Search

                    function onClearClicked() {
                        listModel_SearchResults.clear();
                    }
                }
            }
        }
    }

    UFO_SideBar_Search {
        id: ufo_SideBar_Search

        Layout.preferredWidth: 200
        Layout.fillHeight: true
    }
}
