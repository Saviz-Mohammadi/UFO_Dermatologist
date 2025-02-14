import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore

// Custom QML Files
import "./../components"

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0
import ImageProvider 1.0

Item {
    id: root

    implicitWidth: 200
    implicitHeight: ufo_GroupBox.implicitHeight

    function getListOfImages() {
        let images = [];

        for (let index = 0; index < listModel_ListView.count; index++) {
            let item = listModel_ListView.get(index);

            images.push({
                image_name: item.image_name,
                image_data: item.image_data,
            });
        }

        return (images);
    }

    UFO_GroupBox {
        id: ufo_GroupBox

        anchors.fill: parent

        title: qsTr("Images")
        contentSpacing: 0

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("فهرست زیر تصاویر پزشکی مرتبط با بیمار را نمایش می‌دهد.")

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

            FileDialog {
                id: fileDialog

                title: "Open File"
                fileMode: FileDialog.OpenFile
                nameFilters: ["Image Files (*.png *.jpg *.jpeg)", "All Files (*)"]
                currentFolder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)

                onAccepted: {
                    console.log("Selected file path:", fileDialog.selectedFile)

                    fileDialog.selectedFile

                    // fullScreen.closing.connect(onFullScreenClosed)

                    return;

                    // listModel_ListView.append({
                    //     "consultant_id": id,
                    //     "consultant_name": name,
                    //     "consultant_specialization": specialization,
                    //     "consultation_date": "",
                    //     "consultation_outcome": ""
                    // });
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
                    fileDialog.open()
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
                    id: scrollBar_Consultations

                    width: 10
                    policy: ScrollBar.AlwaysOn
                }

                delegate: UFO_Delegate_Image {
                    width: listView.width - scrollBar_Consultations.width / 2 - 15

                    onRemoveClicked: {
                        listModel_ListView.remove(index);
                    }

                    onViewClicked: {
                        let component = Qt.createComponent("./UFO_FullScreen.qml");
                        let fullScreen = component.createObject(root, {imageUrl: fileDialog.selectedFile});
                    }

                    // NOTE (SAVIZ): This technically works and gets called everytime, because the list gets cleared with every SELECT query. Therefore the data will be refreshed.
                    Component.onCompleted: {
                        imageName = model["image_name"]
                        imageData = model["image_data"]
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

                        Database.getPatientDataMap()["images"].forEach(function (image) {
                            listModel_ListView.append({"image_name": image["image_name"], "image_data": image["image_data"]});
                        });
                    }
                }
            }
        }
    }
}
