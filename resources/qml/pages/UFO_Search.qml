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

        title: qsTr("Search Patients")
        contentSpacing: 25

        // UFO_GroupBox {
        //     id: ufo_GroupBox_SearchResults

        //     Layout.fillWidth: true
        //     // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        //     title: qsTr("Search Results")
        //     contentSpacing: 0


        // }

        ListView {
            id: listView_SearchResults

            Layout.fillWidth: true
            Layout.preferredHeight: 600

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            spacing: 2
            clip: true

            model: ListModel { id: listModel_SearchResults }



            ScrollBar.vertical: ScrollBar {
                id: scrollBar

                width: 10
                policy: ScrollBar.AsNeeded
            }

            // WheelHandler {
            //     // Consume the wheel event to stop propagation.
            //     acceptedDevices: PointerDevice.Mouse

            //     property int speed: 2
            //     property Flickable flickable: parent.parent

            //     onWheel: (event) => {

            //         let scroll_flick = event.angleDelta.y * speed;

            //         if(flickable.verticalOvershoot != 0.0 ||
            //           (scroll_flick>0 && (flickable.verticalVelocity<=0)) ||
            //           (scroll_flick<0 && (flickable.verticalVelocity>=0)))
            //         {
            //             flickable.flick(0, (scroll_flick - flickable.verticalVelocity));
            //             return;
            //         }
            //         else
            //         {
            //             flickable.cancelFlick();
            //             return;
            //         }
            //     }
            // }

            delegate: UFO_SearchDelegate {
                width: listView_SearchResults.width - scrollBar.width - 10

                patientId: model.patient_id
                header: model.first_name + model.last_name
                birthYear: model.birth_year
                phoneNumber: model.phone_number
                gender: model.gender
                maritalStatus: model.marital_status
                servicePrice: model.service_price


                onEditClicked: {
                    // var operationStatus = Database.readyPatientData(model.patient_ID)


                    // if(operationStatus !== true) {
                    //     ufo_StatusBar.displayMessage("Could not make patient ready for editting!");

                    //     return;
                    // }

                    // root.patientSelectedForEdit()
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
        }
    }

    UFO_SearchSideBar {
        Layout.preferredWidth: 200
        Layout.fillHeight: true
    }
}
