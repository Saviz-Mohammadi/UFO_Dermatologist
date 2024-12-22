import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components_ufo"

// Custom CPP Registered Types
import AppTheme 1.0
import Database 1.0

UFO_Page {
    id: root

    title: qsTr("Application Settings")
    contentSpacing: 20

    UFO_GroupBox {
        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("Style")
        contentSpacing: 0

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

            Layout.topMargin: 7
            Layout.bottomMargin: 20
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            model: Object.keys(AppTheme.themes)

            onActivated: {
                AppTheme.loadColorsFromTheme(currentText)
            }

            Component.onCompleted: {
                var cachedTheme = AppTheme.getCachedTheme()

                for (var index = 0; index < ufo_ComboBox_Style.model.length; ++index) {

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
        contentSpacing: 0

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

            Layout.topMargin: 7
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

            // NOTE (SAVIZ): I am not sure if schema name needs RegularExpression, because it is just a name that can be anything.

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

            // NOTE (SAVIZ): I am not sure if username needs RegularExpression, because it is just a name that can be anything.

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

            // NOTE (SAVIZ): I am not sure if password needs RegularExpression, because it is just a password that can be anything.

            placeholderText: qsTr("password")

            text: "1345750"
        }

        RowLayout {
            Layout.fillWidth: true

            Layout.topMargin: 15
            Layout.bottomMargin: 20
            Layout.leftMargin: 15

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? false : true

                text: qsTr("Connect")
                svg: "./../../icons/Google icons/wifi.svg"

                onClicked: {
                    var ipAddress = ipAddressField.text
                    var port = parseInt(portField.text)
                    var schema = schemaField.text
                    var username = usernameField.text
                    var password = passwordField.text

                    if (ipAddress === "") {

                        ufo_StatusBar.displayMessage("IP Address is a required field!")

                        return
                    }

                    if (isNaN(port)) {

                        ufo_StatusBar.displayMessage("Port is a required field!")

                        return
                    }

                    if (schema === "") {

                        ufo_StatusBar.displayMessage("Schema is a required field!")

                        return
                    }

                    if (username === "") {

                        ufo_StatusBar.displayMessage("Username is a required field!")

                        return
                    }

                    if (password === "") {

                        ufo_StatusBar.displayMessage("Password is a required field!")

                        return
                    }


                    // If all requirements are meet, then attempt connection:
                    Database.establishConnection(ipAddress, port, schema, username, password);
                }
            }

            UFO_Button {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 35

                enabled: (Database.connectionStatus === true) ? true : false

                text: qsTr("Disconnect")
                svg: "./../../icons/Google icons/wifi_off.svg"

                onClicked: {

                    Database.disconnect();
                }
            }
        }
    }
}
