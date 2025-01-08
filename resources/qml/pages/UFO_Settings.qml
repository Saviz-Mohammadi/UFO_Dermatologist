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

    title: qsTr("Application Settings")
    contentSpacing: 25

    UFO_GroupBox {
        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Style")
        contentSpacing: 7

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 20
            Layout.bottomMargin: 0
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            text: qsTr("The theme will be cached and loaded on application launch.")
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }

        UFO_ComboBox {
            id: ufo_ComboBox_Style

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.topMargin: 15
            Layout.bottomMargin: 20
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            model: Object.keys(AppTheme.themes)

            onActivated: {
                AppTheme.loadColorsFromTheme(currentText)
            }

            Component.onCompleted: {
                let cachedTheme = AppTheme.getCachedTheme()


                for (let index = 0; index < ufo_ComboBox_Style.model.length; ++index) {
                    if (cachedTheme === "" && ufo_ComboBox_Style.model[index] === "ufo_light") {
                        ufo_ComboBox_Style.currentIndex = index

                        break
                    }


                    if (ufo_ComboBox_Style.model[index] === cachedTheme) {
                        ufo_ComboBox_Style.currentIndex = index

                        break
                    }
                }
            }
        }
    }

    UFO_GroupBox {
        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Database")
        contentSpacing: 1

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 20
            Layout.bottomMargin: 0
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])

            text: qsTr("Enter the required information and press 'Connect' to establish connection to database.")

            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }

        UFO_TextField {
            id: ipAddressField

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.topMargin: 15
            Layout.bottomMargin: 0
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            validator: RegularExpressionValidator {
                regularExpression: /^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$/
            }

            placeholderText: qsTr("IP address")
            text: "192.168.1.66"
        }

        UFO_TextField {
            id: portField

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.topMargin: 7
            Layout.bottomMargin: 0
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            validator: RegularExpressionValidator {
                regularExpression: /^[0-9]{1,5}$/ // Ranges between (0 – 65535)
            }

            placeholderText: qsTr("port")
            text: "3306"
        }

        UFO_TextField {
            id: schemaField

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.topMargin: 7
            Layout.bottomMargin: 0
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            placeholderText: qsTr("schema")
            text: "ufo_dermatologist"
        }

        UFO_TextField {
            id: usernameField

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.topMargin: 7
            Layout.bottomMargin: 0
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            placeholderText: qsTr("username")
            text: "UFO_Dermatologist"
        }

        UFO_TextField {
            id: passwordField

            Layout.fillWidth: true
            Layout.preferredHeight: 35

            Layout.topMargin: 7
            Layout.bottomMargin: 0
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            placeholderText: qsTr("password")
            text: "1345750"
        }

        RowLayout {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.bottomMargin: 20
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            UFO_Button {
                enabled: (Database.connectionStatus === true) ? false : true

                text: qsTr("Connect")
                icon.source: "./../../icons/Google icons/wifi_on.svg"

                onClicked: {
                    let ipAddress = ipAddressField.text.trim();
                    let port = parseInt(portField.text.trim(), 10);
                    let schema = schemaField.text.trim();
                    let username = usernameField.text.trim();
                    let password = passwordField.text.trim();


                    if (ipAddress === "") {
                        ufo_Dialog.titleString = "<b>WARNING!<b>";
                        ufo_Dialog.messageString = "IP Address field cannot be empty.";
                        ufo_Dialog.callbackIdentifier = "<UFO_Settings>: Connect";
                        ufo_Dialog.hasAccept = true;
                        ufo_Dialog.hasReject = false;
                        ufo_Dialog.acceptButtonText = qsTr("OK");
                        ufo_Dialog.rejectButtonText = qsTr("Cancel");
                        ufo_Dialog.open();


                        ufo_StatusBar.displayMessage("IP Address is a required field!");


                        return;
                    }

                    if (isNaN(port)) {
                        ufo_Dialog.titleString = "<b>WARNING!<b>";
                        ufo_Dialog.messageString = "Port field cannot be empty.";
                        ufo_Dialog.callbackIdentifier = "<UFO_Settings>: Connect";
                        ufo_Dialog.hasAccept = true;
                        ufo_Dialog.hasReject = false;
                        ufo_Dialog.acceptButtonText = qsTr("OK");
                        ufo_Dialog.rejectButtonText = qsTr("Cancel");
                        ufo_Dialog.open();


                        ufo_StatusBar.displayMessage("Port is a required field!");


                        return;
                    }

                    if (schema === "") {
                        ufo_Dialog.titleString = "<b>WARNING!<b>";
                        ufo_Dialog.messageString = "Schema field cannot be empty.";
                        ufo_Dialog.callbackIdentifier = "<UFO_Settings>: Connect";
                        ufo_Dialog.hasAccept = true;
                        ufo_Dialog.hasReject = false;
                        ufo_Dialog.acceptButtonText = qsTr("OK");
                        ufo_Dialog.rejectButtonText = qsTr("Cancel");
                        ufo_Dialog.open();


                        ufo_StatusBar.displayMessage("Schema is a required field!");


                        return;
                    }

                    if (username === "") {
                        ufo_Dialog.titleString = "<b>WARNING!<b>";
                        ufo_Dialog.messageString = "Port field cannot be empty.";
                        ufo_Dialog.callbackIdentifier = "<UFO_Settings>: Connect";
                        ufo_Dialog.hasAccept = true;
                        ufo_Dialog.hasReject = false;
                        ufo_Dialog.acceptButtonText = qsTr("OK");
                        ufo_Dialog.rejectButtonText = qsTr("Cancel");
                        ufo_Dialog.open();


                        ufo_StatusBar.displayMessage("Username is a required field!");


                        return;
                    }

                    if (password === "") {
                        ufo_Dialog.titleString = "<b>WARNING!<b>";
                        ufo_Dialog.messageString = "Password field cannot be empty.";
                        ufo_Dialog.callbackIdentifier = "<UFO_Settings>: Connect";
                        ufo_Dialog.hasAccept = true;
                        ufo_Dialog.hasReject = false;
                        ufo_Dialog.acceptButtonText = qsTr("OK");
                        ufo_Dialog.rejectButtonText = qsTr("Cancel");
                        ufo_Dialog.open();


                        ufo_StatusBar.displayMessage("Password is a required field!");


                        return;
                    }


                    Database.establishConnection(ipAddress, port, schema, username, password);
                }

                Connections {
                    target: ufo_Dialog

                    function onAccepted() {
                        if(ufo_Dialog.callbackIdentifier === "<UFO_Settings>: Connect") {
                            ufo_Dialog.close();


                            return;
                        }
                    }
                }
            }

            UFO_Button {
                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Disconnect")
                icon.source: "./../../icons/Google icons/wifi_off.svg"

                onClicked: {
                    Database.disconnect();
                }
            }
        }
    }

    UFO_OperationResult {
        id: ufo_OperationResult

        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        Connections {
            target: Database

            function onConnectionStatusChanged(message) {
                if(Database.connectionStatus === true) {
                    ufo_OperationResult.svg = "./../../icons/Google icons/check_box.svg";
                    ufo_OperationResult.state = true;
                    ufo_OperationResult.displayMessage(message, 8000);


                    return;
                }


                if(Database.connectionStatus === false) {
                    ufo_OperationResult.svg = "./../../icons/Google icons/error.svg";
                    ufo_OperationResult.state = false;
                    ufo_OperationResult.displayMessage(message, 8000);


                    return;
                }
            }
        }
    }
}
