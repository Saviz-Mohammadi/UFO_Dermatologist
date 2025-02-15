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

                    Database.addImage(fileDialog.selectedFile);

                    // fullScreen.closing.connect(onFullScreenClosed)
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
                        // TODO (SAVIZ): A better thing to do is to call this method and then see if it was succesful and only then remove index.
                        Database.deleteImage(this.imageName);
                        listModel_ListView.remove(index);
                    }

                    onViewClicked: {
                        // TODO (SAVIZ): A better thing to do is to see if temp save was succesful and then show full screen.
                        let tempImageurl = ImageProvider.urlFromData(Database.getImageData(this.imageName));

                        console.log(tempImageurl);

                        let component = Qt.createComponent("./UFO_FullScreen.qml");

                        if (component.status === Component.Ready) {
                            var fullscreen = component.createObject(root, {
                                "imageUrl": tempImageurl
                            });
                        }
                    }

                    // NOTE (SAVIZ): This technically works and gets called everytime, because the list gets cleared with every SELECT query. Therefore the data will be refreshed.
                    Component.onCompleted: {
                        imageName = model["image_name"]
                    }
                }

                Connections {
                    target: Database

                    function onImageAdded(success, fileName) {

                        // TODO (SAVIZ): You can do something better here and show something...
                        if(success === false) {
                            return;
                        }

                        listModel_ListView.append({
                            "image_name": fileName
                        });
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
                            listModel_ListView.append({"image_name": image["image_name"]});
                        });
                    }
                }
            }
        }
    }
}
