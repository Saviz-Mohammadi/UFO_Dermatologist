import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom CPP Registered Types
import AppTheme 1.0

Item {
    id: root

    property alias borderRadius: rectangle_Background.radius
    property alias text: text_DisplayMessage.text
    property real textLeftMargin: 7

    function displayMessage(message, duration) {
        text_DisplayMessage.text = qsTr(message)

        if(duration === undefined) {
            return
        }

        timer.interval = duration
        timer.restart()
    }

    implicitWidth: 200
    implicitHeight: 28

    Timer {
        id: timer

        onTriggered: {
            text_DisplayMessage.text = qsTr("")
        }
    }

    Rectangle {
        id: rectangle_Background

        anchors.fill: parent

        radius: 0
        color: Qt.color(AppTheme.colors["UFO_StatusBar_Background"])

        Text {
            id: text_DisplayMessage

            anchors.fill: parent
            anchors.leftMargin: textLeftMargin

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            text: qsTr("")
            color: Qt.color(AppTheme.colors["UFO_StatusBar_Text"])
            elide: Text.ElideRight
        }
    }
}
