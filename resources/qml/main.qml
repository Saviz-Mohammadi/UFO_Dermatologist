import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "components"
import "pages"

// Custom CPP Registered Types
import AppTheme 1.0

ApplicationWindow {
    id: rootWindow

    width: 800
    height: 600

    visible: true
    title: qsTr("DermaBase")

    menuBar: UFO_MenuBar {
        spacing: 0

        UFO_Menu {
            topMargin: 0
            leftMargin: 0

            title: qsTr("فایل")

            UFO_MenuItem {
                leftPadding: 10
                rightPadding: 10

                text: qsTr("خروج")

                onTriggered: {
                    Qt.quit()
                }
            }
        }

        UFO_Menu {
            topMargin: 0
            leftMargin: 0

            title: qsTr("نمایش")

            UFO_MenuItem {
                leftPadding: 10
                rightPadding: 10

                text: qsTr("صفحه جستجو")

                onTriggered: {
                    stackLayout.currentIndex = ufo_Search.StackLayout.index

                    ufo_SideBar_Main.checkTabButton("Search Page")
                }
            }

            UFO_MenuItem {
                leftPadding: 10
                rightPadding: 10

                text: qsTr("صفحه تاریخچه جستجو")

                onTriggered: {
                    stackLayout.currentIndex = ufo_SearchHistory.StackLayout.index

                    ufo_SideBar_Main.checkTabButton("Search History Page")
                }
            }

            UFO_MenuItem {
                leftPadding: 10
                rightPadding: 10

                text: qsTr("صفحه ویرایش")

                onTriggered: {
                    stackLayout.currentIndex = ufo_Edit.StackLayout.index

                    ufo_SideBar_Main.checkTabButton("Edit Page")
                }
            }

            UFO_MenuItem {
                leftPadding: 10
                rightPadding: 10

                text: qsTr("صفحه ایجاد")

                onTriggered: {
                    stackLayout.currentIndex = ufo_Create.StackLayout.index

                    ufo_SideBar_Main.checkTabButton("Create Page")
                }
            }

            UFO_MenuItem {
                leftPadding: 10
                rightPadding: 10

                text: qsTr("صفحه چاپ")

                onTriggered: {
                    stackLayout.currentIndex = ufo_Print.StackLayout.index

                    ufo_SideBar_Main.checkTabButton("Print Page")
                }
            }

            UFO_MenuItem {
                leftPadding: 10
                rightPadding: 10

                text: qsTr("ارسال پیام")

                onTriggered: {
                    stackLayout.currentIndex = ufo_Notify.StackLayout.index

                    ufo_SideBar_Main.checkTabButton("Notify Page")
                }
            }

            UFO_MenuItem {
                leftPadding: 10
                rightPadding: 10

                text: qsTr("صفحه تنظیمات")

                onTriggered: {
                    stackLayout.currentIndex = ufo_Settings.StackLayout.index

                    ufo_SideBar_Main.checkTabButton("Settings Page")
                }
            }

            UFO_MenuItem {
                leftPadding: 10
                rightPadding: 10

                text: qsTr("صفحه درباره برنامه")

                onTriggered: {
                    stackLayout.currentIndex = ufo_About.StackLayout.index

                    ufo_SideBar_Main.checkTabButton("About Page")
                }
            }
        }

        UFO_Menu {
            topMargin: 0
            leftMargin: 0

            title: qsTr("راهنما")

            UFO_MenuItem {
                leftPadding: 10
                rightPadding: 10

                text: qsTr("درباره برنامه")

                onTriggered: {
                    stackLayout.currentIndex = ufo_About.StackLayout.index

                    ufo_SideBar_Main.checkTabButton("About Page")
                }
            }
        }
    }

    footer: UFO_StatusBar {
        id: ufo_StatusBar

        text: qsTr("برنامه آماده است")
    }

    UFO_Dialog {
        id: ufo_Dialog

        anchors.centerIn: parent

        visible: false
    }

    UFO_SplitView {
        anchors.fill: parent

        UFO_SideBar_Main {
            id: ufo_SideBar_Main

            // NOTE (SAVIZ): Initial startup width for the main SideBar.
            Layout.preferredWidth: 200
            Layout.fillHeight: true
        }

        StackLayout {
            id: stackLayout

            Layout.fillWidth: true
            Layout.fillHeight: true

            UFO_Search {
                id: ufo_Search

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            UFO_SearchHistory {
                id: ufo_SearchHistory

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            UFO_Edit {
                id: ufo_Edit

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            UFO_Create {
                id: ufo_Create

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            UFO_Print {
                id: ufo_Print

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            UFO_Notify {
                id: ufo_Notify

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            UFO_Settings {
                id: ufo_Settings

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            UFO_About {
                id: ufo_About

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Connections {
                target: ufo_Search

                function onPatientSelectedForEdit() {
                    ufo_Edit.contentVisible = true

                    stackLayout.currentIndex = ufo_Edit.StackLayout.index

                    ufo_SideBar_Main.checkTabButton("Edit Page")
                }
            }

            Connections {
                target: ufo_SearchHistory

                function onPatientSelectedForEdit() {
                    ufo_Edit.contentVisible = true

                    stackLayout.currentIndex = ufo_Edit.StackLayout.index

                    ufo_SideBar_Main.checkTabButton("Edit Page")
                }
            }

            Connections {
                target: ufo_SideBar_Main

                function onTabChanged(pageName) {

                    // TODO (SAVIZ): I like to replace these with an enum, but currently I don't know how in QML.
                    switch (pageName) {
                        case "Create Page":
                            stackLayout.currentIndex = ufo_Create.StackLayout.index
                            break
                        case "Print Page":
                            stackLayout.currentIndex = ufo_Print.StackLayout.index
                            break
                        case "Notify Page":
                            stackLayout.currentIndex = ufo_Notify.StackLayout.index
                            break
                        case "Edit Page":
                            stackLayout.currentIndex = ufo_Edit.StackLayout.index
                            break
                        case "Search Page":
                            stackLayout.currentIndex = ufo_Search.StackLayout.index
                            break
                        case "Search History Page":
                            stackLayout.currentIndex = ufo_SearchHistory.StackLayout.index
                            break
                        case "Settings Page":
                            stackLayout.currentIndex = ufo_Settings.StackLayout.index
                            break
                        case "About Page":
                            stackLayout.currentIndex = ufo_About.StackLayout.index
                            break
                        default:
                            stackLayout.currentIndex = -1
                    }
                }
            }

            Component.onCompleted: {
                stackLayout.currentIndex = ufo_About.StackLayout.index
            }
        }
    }
}
