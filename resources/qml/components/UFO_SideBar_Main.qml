import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0

Item {
    id: root

    signal tabChanged(string pageName)

    function checkTabButton(targetButton) {

        // TODO (SAVIZ): I like to replace these with an enum, but currently I don't know how in QML.
        switch (targetButton) {
            case "Search Page":
                ufo_SideBar_Button_Search.checked = true
                break
            case "Edit Page":
                ufo_SideBar_Button_Edit.checked = true
                break
            case "Create Page":
                ufo_SideBar_Button_Create.checked = true
                break
            case "Settings Page":
                ufo_SideBar_Button_Settings.checked = true
                break
            case "About Page":
                ufo_SideBar_Button_About.checked = true
                break
            default:
                console.log("No valid value");
        }
    }

    implicitWidth: 200
    implicitHeight: 200

    ButtonGroup { id: buttonGroup }

    Rectangle {
        anchors.fill: parent

        color: Qt.color(AppTheme.colors["UFO_SideBar_Background"])

        ColumnLayout {
            anchors.fill: parent

            anchors.topMargin: 20
            anchors.bottomMargin: 20

            spacing: 10

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // NOTE (SAVIZ): Setting "contentWidth" to -1 will disable horizontal scrolling.
                contentWidth: -1
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ColumnLayout {
                    anchors.fill: parent

                    clip: true
                    spacing: 10

                    UFO_SideBar_Button {
                        id: ufo_SideBar_Button_Search

                        Layout.fillWidth: true
                        Layout.preferredHeight: 40

                        Layout.leftMargin: 15
                        Layout.rightMargin: 15

                        ButtonGroup.group: buttonGroup

                        checkable: true
                        autoExclusive: true
                        checked: false

                        text: qsTr("جستجو")
                        icon.source: "./../../icons/Google icons/person_search.svg"

                        onClicked: {
                            root.tabChanged("Search Page")
                        }
                    }

                    UFO_SideBar_Button {
                        id: ufo_SideBar_Button_Edit

                        Layout.fillWidth: true
                        Layout.preferredHeight: 40

                        Layout.leftMargin: 15
                        Layout.rightMargin: 15

                        ButtonGroup.group: buttonGroup

                        checkable: true
                        autoExclusive: true
                        checked: false

                        text: qsTr("ویرایش")
                        icon.source: "./../../icons/Google icons/person_edit.svg"

                        onClicked: {
                            root.tabChanged("Edit Page")
                        }
                    }

                    UFO_SideBar_Button {
                        id: ufo_SideBar_Button_Create

                        Layout.fillWidth: true
                        Layout.preferredHeight: 40

                        Layout.leftMargin: 15
                        Layout.rightMargin: 15

                        ButtonGroup.group: buttonGroup

                        checkable: true
                        autoExclusive: true
                        checked: false

                        text: qsTr("ایجاد")
                        icon.source: "./../../icons/Google icons/person_add.svg"

                        onClicked: {
                            root.tabChanged("Create Page")
                        }
                    }

                    // NOTE (SAVIZ): Add more buttons as needed...
                }
            }

            // NOTE (SAVIZ): The entire below section can be placed inside the "ScrollView" in the above section. However, I think it's beneficial to always have pages like "Settings" and "About" be visible at the bottom at all times.
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            UFO_SideBar_Separator {
                Layout.fillWidth: true
                Layout.preferredHeight: 1

                Layout.leftMargin: 4
                Layout.rightMargin: 4
            }

            UFO_SideBar_Button {
                id: ufo_SideBar_Button_Settings

                Layout.fillWidth: true
                Layout.preferredHeight: 40

                Layout.topMargin: 10
                Layout.leftMargin: 15
                Layout.rightMargin: 15

                ButtonGroup.group: buttonGroup

                checkable: true
                autoExclusive: true
                checked: false

                text: qsTr("تنظیمات برنامه")
                icon.source: "./../../icons/Google icons/settings.svg"

                onClicked: {
                    root.tabChanged("Settings Page")
                }
            }

            UFO_SideBar_Button {
                id: ufo_SideBar_Button_About

                Layout.fillWidth: true
                Layout.preferredHeight: 40

                Layout.leftMargin: 15
                Layout.rightMargin: 15

                ButtonGroup.group: buttonGroup

                checkable: true
                autoExclusive: true
                checked: true

                text: qsTr("درباره برنامه")
                icon.source: "./../../icons/Google icons/help.svg"

                onClicked: {
                    root.tabChanged("About Page")
                }
            }
        }
    }
}
