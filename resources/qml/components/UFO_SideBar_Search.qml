import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components"

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

Item {
    id: root

    signal clearClicked

    implicitWidth: 200
    implicitHeight: 500

    Rectangle {
        anchors.fill: parent

        color: Qt.color(AppTheme.colors["UFO_SideBar_Background"])
        radius: 0

        ColumnLayout {
            anchors.fill: parent

            anchors.topMargin: 20
            anchors.bottomMargin: 20
            anchors.rightMargin: 20
            anchors.leftMargin: 20

            spacing: 10

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // NOTE (SAVIZ): Setting "contentWidth" to -1 will disable horizontal scrolling.
                contentWidth: -1
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ColumnLayout {
                    anchors.fill: parent

                    anchors.rightMargin: 20

                    clip: true
                    spacing: 5

                    RowLayout {
                        Layout.fillWidth: true

                        spacing: 5

                        UFO_SideBar_TextField {
                            id: textField_PatientID

                            Layout.fillWidth: true
                            Layout.preferredHeight: 35

                            enabled: (Database.connectionStatus === true) ? true : false

                            validator: RegularExpressionValidator {
                                regularExpression: /^\p{Nd}+$/
                            }
                        }

                        Text {
                            Layout.preferredWidth: 100
                            Layout.preferredHeight: 35

                            color: Qt.color(AppTheme.colors["UFO_SideBar_Text"])
                            text: qsTr("شماره پرونده")

                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.NoWrap
                            elide: Text.ElideRight
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        spacing: 5

                        UFO_SideBar_TextField {
                            id: textField_PhoneNumber

                            Layout.fillWidth: true
                            Layout.preferredHeight: 35

                            enabled: (Database.connectionStatus === true) ? true : false

                            validator: RegularExpressionValidator {
                                regularExpression: /^\+\d{1,3} \(\d{3}\) \d{3}-\d{4}$/
                            }
                        }

                        Text {
                            Layout.preferredWidth: 100
                            Layout.preferredHeight: 35

                            color: Qt.color(AppTheme.colors["UFO_SideBar_Text"])
                            text: qsTr("شماره تلفن")

                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.NoWrap
                            elide: Text.ElideRight
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        spacing: 5

                        UFO_SideBar_TextField {
                            id: textField_FirstName

                            Layout.fillWidth: true
                            Layout.preferredHeight: 35

                            Layout.topMargin: 20

                            enabled: (Database.connectionStatus === true) ? true : false

                            validator: RegularExpressionValidator {
                                regularExpression: /^[\p{L}]+$/u
                            }
                        }

                        Text {
                            Layout.preferredWidth: 100
                            Layout.preferredHeight: 35

                            color: Qt.color(AppTheme.colors["UFO_SideBar_Text"])
                            text: qsTr("نام اول")

                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.NoWrap
                            elide: Text.ElideRight
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        spacing: 5

                        UFO_SideBar_TextField {
                            id: textField_LastName

                            Layout.fillWidth: true
                            Layout.preferredHeight: 35

                            enabled: (Database.connectionStatus === true) ? true : false

                            validator: RegularExpressionValidator {
                                regularExpression: /^[A-Za-z]+$/
                            }
                        }

                        Text {
                            Layout.preferredWidth: 100
                            Layout.preferredHeight: 35

                            color: Qt.color(AppTheme.colors["UFO_SideBar_Text"])
                            text: qsTr("نام خانوادگی")

                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.NoWrap
                            elide: Text.ElideRight
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Layout.topMargin: 20

                        spacing: 3

                        UFO_SideBar_CheckBox {
                            id: ufo_CheckBox_BirthYearStart

                            Layout.preferredWidth: 35
                            Layout.preferredHeight: 35

                            enabled: (Database.connectionStatus === true) ? true : false
                            checked: false
                        }

                        UFO_SideBar_TextField {
                            id: textField_BirthYearStart

                            Layout.fillWidth: true
                            Layout.preferredHeight: 35

                            enabled: (Database.connectionStatus && ufo_CheckBox_BirthYearStart.checked)

                            validator: RegularExpressionValidator {
                                regularExpression: /^[1-9]\d*$/
                            }
                        }

                        Text {
                            Layout.preferredWidth: 100
                            Layout.preferredHeight: 35

                            color: Qt.color(AppTheme.colors["UFO_SideBar_Text"])
                            text: qsTr("شروع سال تولد")

                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.NoWrap
                            elide: Text.ElideRight
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        spacing: 3

                        UFO_SideBar_CheckBox {
                            id: ufo_CheckBox_BirthYearEnd

                            Layout.preferredWidth: 35
                            Layout.preferredHeight: 35

                            enabled: (Database.connectionStatus === true) ? true : false
                            checked: false
                        }

                        UFO_SideBar_TextField {
                            id: textField_BirthYearEnd

                            Layout.fillWidth: true
                            Layout.preferredHeight: 35

                            enabled: (Database.connectionStatus && ufo_CheckBox_BirthYearEnd.checked)

                            validator: RegularExpressionValidator {
                                regularExpression: /^[1-9]\d*$/
                            }
                        }

                        Text {
                            Layout.preferredWidth: 100
                            Layout.preferredHeight: 35

                            color: Qt.color(AppTheme.colors["UFO_SideBar_Text"])
                            text: qsTr("پایان سال تولد")

                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.NoWrap
                            elide: Text.ElideRight
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Layout.topMargin: 20

                        spacing: 3

                        UFO_SideBar_CheckBox {
                            id: ufo_CheckBox_Gender

                            Layout.preferredWidth: 35
                            Layout.preferredHeight: 35

                            enabled: (Database.connectionStatus === true) ? true : false
                            checked: false
                        }

                        UFO_SideBar_ComboBox {
                            id: comboBox_Gender

                            Layout.fillWidth: true
                            Layout.preferredHeight: 35

                            enabled: (Database.connectionStatus && ufo_CheckBox_Gender.checked)
                            model: ["Unknown", "Male", "Female"]
                        }

                        Text {
                            Layout.preferredWidth: 100
                            Layout.preferredHeight: 35

                            color: Qt.color(AppTheme.colors["UFO_SideBar_Text"])
                            text: qsTr("جنسیت")

                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.NoWrap
                            elide: Text.ElideRight
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        spacing: 3

                        UFO_SideBar_CheckBox {
                            id: ufo_CheckBox_MaritalStatus

                            Layout.preferredWidth: 35
                            Layout.preferredHeight: 35

                            enabled: (Database.connectionStatus === true) ? true : false
                            checked: false
                        }

                        UFO_SideBar_ComboBox {
                            id: comboBox_MaritalStatus

                            Layout.fillWidth: true
                            Layout.preferredHeight: 35

                            enabled: (Database.connectionStatus && ufo_CheckBox_MaritalStatus.checked)
                            model: ["Unknown", "Single", "Married"]
                        }

                        Text {
                            Layout.preferredWidth: 100
                            Layout.preferredHeight: 35

                            color: Qt.color(AppTheme.colors["UFO_SideBar_Text"])
                            text: qsTr("وضعیت تأهل")

                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.NoWrap
                            elide: Text.ElideRight
                        }
                    }
                }
            }

            UFO_SideBar_Separator {
                Layout.fillWidth: true
                Layout.preferredHeight: 1

                Layout.leftMargin: 4
                Layout.rightMargin: 4
            }

            UFO_SideBar_Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                Layout.topMargin: 10

                enabled: (Database.connectionStatus === true) ? true : false
                text: qsTr("پاک")
                icon.source: "./../../icons/Google icons/delete.svg"

                onClicked: {
                    textField_PatientID.clear();
                    textField_PhoneNumber.clear();
                    textField_FirstName.clear();
                    textField_LastName.clear();
                    textField_BirthYearStart.clear();
                    textField_BirthYearEnd.clear();


                    ufo_CheckBox_BirthYearStart.checked = false;
                    ufo_CheckBox_BirthYearEnd.checked = false;
                    ufo_CheckBox_Gender.checked = false;
                    ufo_CheckBox_MaritalStatus.checked = false;


                    comboBox_Gender.currentIndex = 0;
                    comboBox_MaritalStatus.currentIndex = 0;

                    root.clearClicked();
                }
            }

            UFO_SideBar_Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                enabled: (Database.connectionStatus === true) ? true : false
                text: qsTr("اول ۱۰")
                icon.source: "./../../icons/Google icons/list.svg"

                onClicked: {
                    Database.findFirstXPatients(10)
                }
            }

            UFO_SideBar_Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                enabled: (Database.connectionStatus === true) ? true : false
                text: qsTr("اخر ۱۰")
                icon.source: "./../../icons/Google icons/list.svg"

                onClicked: {
                    Database.findLastXPatients(10)
                }
            }

            UFO_SideBar_Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                enabled: (Database.connectionStatus === true) ? true : false
                text: qsTr("جستوجو")
                icon.source: "./../../icons/Google icons/person_search.svg"

                onClicked: {
                    // Grab data:
                    let patientID = Number(textField_PatientID.text.trim().replace(/[۰۱۲۳۴۵۶۷۸۹]/g, d => d.charCodeAt(0) - 1776));
                    let firstName = textField_FirstName.text.trim()
                    let lastName = textField_LastName.text.trim()
                    let birthYearStart = parseInt(textField_BirthYearStart.text.trim(), 10);
                    let birthYearEnd = parseInt(textField_BirthYearEnd.text.trim(), 10);
                    let phoneNumber = textField_PhoneNumber.text
                    let gender = comboBox_Gender.currentText
                    let maritalStatus = comboBox_MaritalStatus.currentText

                    console.log(patientID)

                    // Perform checks:
                    if(!isNaN(patientID)) {
                        Database.findPatient(patientID);

                        return;
                    }

                    if(ufo_CheckBox_BirthYearStart.checked === false || isNaN(birthYearStart)) {
                        birthYearStart = 0
                    }

                    if(ufo_CheckBox_BirthYearEnd.checked === false || isNaN(birthYearEnd)) {
                        birthYearEnd = 0
                    }

                    if(ufo_CheckBox_Gender.checked === false) {
                        gender = ""
                    }

                    if(ufo_CheckBox_MaritalStatus.checked === false) {
                        maritalStatus = ""
                    }


                    Database.findPatient(firstName, lastName, birthYearStart, birthYearEnd, phoneNumber, gender, maritalStatus);
                }
            }
        }
    }
}
