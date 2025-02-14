import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtMultimedia

// Custom CPP Registered Types
import AppTheme 1.0

Window {
    id: root

    property url imageUrl;

    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    modality: Qt.ApplicationModal
    color: "transparent"

    Component.onCompleted: {
        imageView.source = root.imageUrl;

        showFullScreen()
    }

    Rectangle {
        anchors.fill: parent

        color: "black"
        focus: true

        Keys.onPressed: (event)=> {
            if (event.key === Qt.Key_Escape) {
                event.accepted = true

                root.close()
            }
        }

        Image {
            id: imageView

            anchors.centerIn: parent

            fillMode: Image.PreserveAspectFit
            smooth: true
            cache: false
        }
    }
}
