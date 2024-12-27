import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0

Item {
    id: root

    property alias svg: iconImage.source
    property int svgWidth: 42
    property int svgHeight: 42
    property int borderRadius: 0

    implicitWidth: 120
    implicitHeight: 60

    visible: false

    function displayMessage(message, duration) {
        text_DisplayMessage.text = qsTr(message);
        root.visible = true;

        if(duration === undefined) {
            return;
        }

        timer.interval = duration;
        timer.start();
    }

    Timer {
        id: timer

        onTriggered: {
            root.visible = false;
        }
    }

    Rectangle {
        anchors.fill: parent

        radius: root.borderRadius

        color: "green"
        //color: Qt.color(AppTheme.colors["UFO_Button_Icon_Checked"])

        RowLayout {
            anchors.fill: parent

            IconImage {
                id: iconImage

                Layout.preferredWidth: root.svgWidth
                Layout.preferredHeight: root.svgHeight

                Layout.leftMargin: 10
                Layout.rightMargin: 10

                sourceSize.width: root.svgWidth
                sourceSize.height: root.svgHeight

                source: ""
                verticalAlignment: Image.AlignVCenter

                color: {
                    if (root.checked) {
                        Qt.color(AppTheme.colors["UFO_Button_Icon_Checked"])
                    }

                    else if (root.hovered) {
                        Qt.color(AppTheme.colors["UFO_Button_Icon_Hovered"])
                    }

                    else {
                        Qt.color(AppTheme.colors["UFO_Button_Icon_Normal"])
                    }
                }
            }

            Text {
                id: text_DisplayMessage

                Layout.fillWidth: true
                Layout.fillHeight: true

                elide: Text.ElideRight

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter

                color: {
                    if (root.checked) {
                        Qt.color(AppTheme.colors["UFO_Button_Text_Checked"])
                    }

                    else if (root.hovered) {
                        Qt.color(AppTheme.colors["UFO_Button_Text_Hovered"])
                    }

                    else {
                        Qt.color(AppTheme.colors["UFO_Button_Text_Normal"])
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }
}
