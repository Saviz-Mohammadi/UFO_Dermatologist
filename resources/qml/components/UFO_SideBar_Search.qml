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

                    UFO_SideBar_TextField {
                        id: textField_PatientID

                        Layout.fillWidth: true
                        Layout.preferredHeight: 35

                        enabled: (Database.connectionStatus === true) ? true : false
                        placeholderText: qsTr("Patient ID (e.g., 277)")

                        validator: RegularExpressionValidator {
                            regularExpression: /^[0-9]*$/
                        }
                    }

                    UFO_SideBar_TextField {
                        id: textField_PhoneNumber

                        Layout.fillWidth: true
                        Layout.preferredHeight: 35

                        enabled: (Database.connectionStatus === true) ? true : false
                        placeholderText: qsTr("Phone number (e.g., +1 (250) 800-1234)")

                        validator: RegularExpressionValidator {
                            regularExpression: /^\+\d{1,3} \(\d{3}\) \d{3}-\d{4}$/
                        }
                    }

                    UFO_SideBar_Separator {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1

                        Layout.topMargin: 15
                        Layout.leftMargin: 4
                        Layout.rightMargin: 4
                        Layout.bottomMargin: 15
                    }

                    UFO_SideBar_TextField {
                        id: textField_FirstName

                        Layout.fillWidth: true
                        Layout.preferredHeight: 35

                        enabled: (Database.connectionStatus === true) ? true : false
                        placeholderText: qsTr("First name (e.g., Hank)")

                        validator: RegularExpressionValidator {
                            regularExpression: /^[A-Za-z]+$/
                        }
                    }

                    UFO_SideBar_TextField {
                        id: textField_LastName

                        Layout.fillWidth: true
                        Layout.preferredHeight: 35

                        enabled: (Database.connectionStatus === true) ? true : false
                        placeholderText: qsTr("Last name (e.g. Miller)")

                        validator: RegularExpressionValidator {
                            regularExpression: /^[A-Za-z]+$/
                        }
                    }

                    UFO_SideBar_Separator {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1

                        Layout.topMargin: 15
                        Layout.leftMargin: 4
                        Layout.rightMargin: 4
                        Layout.bottomMargin: 15
                    }

                    RowLayout {
                        Layout.fillWidth: true

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
                            placeholderText: qsTr("Birth year start range (e.g. 1379)")

                            validator: RegularExpressionValidator {
                                regularExpression: /^[1-9]\d*$/
                            }
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
                            placeholderText: qsTr("Birth year end range (e.g. 1400)")

                            validator: RegularExpressionValidator {
                                regularExpression: /^[1-9]\d*$/
                            }
                        }
                    }

                    UFO_SideBar_Separator {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1

                        Layout.topMargin: 15
                        Layout.leftMargin: 4
                        Layout.rightMargin: 4
                        Layout.bottomMargin: 15
                    }

                    RowLayout {
                        Layout.fillWidth: true

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

                enabled: (Database.connectionStatus === true) ? true : false
                text: qsTr("Clear")
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
                text: qsTr("First 10")
                icon.source: "./../../icons/Google icons/list.svg"

                onClicked: {
                    Database.findFirstXPatients(10)
                }
            }

            UFO_SideBar_Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                enabled: (Database.connectionStatus === true) ? true : false
                text: qsTr("Last 10")
                icon.source: "./../../icons/Google icons/list.svg"

                onClicked: {
                    Database.findLastXPatients(10)
                }
            }

            UFO_SideBar_Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                enabled: (Database.connectionStatus === true) ? true : false
                text: qsTr("Search")
                icon.source: "./../../icons/Google icons/person_search.svg"

                onClicked: {
                    // Grab data:
                    let patientID = parseInt(textField_PatientID.text.trim(), 10);
                    let firstName = textField_FirstName.text.trim()
                    let lastName = textField_LastName.text.trim()
                    let birthYearStart = parseInt(textField_BirthYearStart.text.trim(), 10);
                    let birthYearEnd = parseInt(textField_BirthYearEnd.text.trim(), 10);
                    let phoneNumber = textField_PhoneNumber.text
                    let gender = comboBox_Gender.currentText
                    let maritalStatus = comboBox_MaritalStatus.currentText


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
