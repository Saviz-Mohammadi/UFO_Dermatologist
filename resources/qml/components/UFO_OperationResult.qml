import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0

Item {
    id: root

    property alias svg: iconImage.source
    property bool state: true
    property int svgWidth: 42
    property int svgHeight: 42
    property int borderRadius: 0

    implicitWidth: 120
    implicitHeight: svgHeight + 20

    visible: false

    function displayMessage(message, duration) {
        text_DisplayMessage.text = qsTr(message);
        root.visible = true;

        if(duration === undefined) {
            return;
        }

        timer.interval = duration;
        timer.restart();
    }

    Timer {
        id: timer

        onTriggered: {
            root.visible = false;
        }
    }

    Rectangle {
        id: rectangle_Background

        anchors.fill: parent

        radius: root.borderRadius

        color: {
            if(root.state === true) {
                return ("springgreen");
            }

            if(root.state === false) {
                return ("tomato");
            }
        }

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

                color: Qt.rgba(0, 0, 0, 0.85)
            }

            Text {
                id: text_DisplayMessage

                Layout.fillWidth: true
                Layout.fillHeight: true

                elide: Text.ElideRight
                wrapMode: Text.Wrap

                verticalAlignment: Text.AlignVCenter

                color: Qt.rgba(0, 0, 0, 0.85)
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }
}
