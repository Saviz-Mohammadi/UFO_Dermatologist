import QtQuick
// import QtQuick.Controls.Basic
// import QtQuick.Layouts

// // Custom CPP Registered Types
// import AppTheme 1.0
// import Database 1.0

// Item {
//     id: root

//     property alias header: text_Header.text
//     property alias patientId: text_ID.text
//     property alias birthYear: text_BirthYear.text
//     property alias phoneNumber: text_PhoneNumber.text
//     property alias gender: text_Gender.text
//     property alias maritalStatus: text_MaritalStatus.text
//     property alias servicePrice: text_ServicePrice.text

//     signal editClicked

//     implicitWidth: 200
//     implicitHeight: 250

//     Rectangle {
//         anchors.fill: parent

//         anchors.margins: 10

//         color: Qt.color(AppTheme.colors["UFO_Delegate_Background"])
//         radius: 0

//         ColumnLayout {
//             id: columnLayout_Content

//             anchors.fill: parent

//             RowLayout {
//                 Layout.fillWidth: true

//                 Layout.leftMargin: 15
//                 Layout.rightMargin: 15

//                 spacing: 15

//                 IconImage {
//                     Layout.preferredWidth: 64
//                     Layout.preferredHeight: 64

//                     sourceSize.width: width
//                     sourceSize.height: height

//                     source: "./../../icons/Google icons/person.svg"
//                     verticalAlignment: Image.AlignVCenter

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Icon"])
//                 }

//                 Text {
//                     id: text_Header

//                     Layout.fillWidth: true
//                     Layout.fillHeight: true

//                     elide: Text.ElideRight
//                     wrapMode: Text.NoWrap

//                     horizontalAlignment: Text.AlignLeft
//                     verticalAlignment: Text.AlignVCenter

//                     font.pixelSize: Qt.application.font.pixelSize * 1.45
//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                 }

//                 UFO_Button {
//                     Layout.preferredWidth: 120
//                     Layout.preferredHeight: 35

//                     Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

//                     enabled: (Database.connectionStatus === true) ? true : false

//                     text: qsTr("Edit")
//                     svg: "./../../icons/Google icons/person_edit.svg"

//                     onClicked: {
//                         root.editClicked()
//                     }
//                 }
//             }

//             GridLayout {
//                 Layout.fillWidth: true
//                 Layout.fillHeight: true

//                 Layout.bottomMargin: 15
//                 Layout.leftMargin: 15
//                 Layout.rightMargin: 15

//                 columns: 3
//                 rows: 4

//                 Text {
//                     Layout.column: 0
//                     Layout.row: 0

//                     text: qsTr("Patient ID")

//                     horizontalAlignment: Text.AlignLeft
//                     verticalAlignment: Text.AlignBottom

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                 }

//                 Rectangle {
//                     Layout.fillWidth: true
//                     Layout.preferredHeight: 35

//                     Layout.column: 0
//                     Layout.row: 1

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

//                     Text {
//                         id: text_ID

//                         anchors.fill: parent
//                         anchors.leftMargin: 10

//                         horizontalAlignment: Text.AlignLeft
//                         verticalAlignment: Text.AlignVCenter

//                         color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                         font.pixelSize: Qt.application.font.pixelSize * 1
//                         elide: Text.ElideRight
//                     }
//                 }

//                 Text {
//                     Layout.column: 1
//                     Layout.row: 0

//                     text: qsTr("Birth year")

//                     horizontalAlignment: Text.AlignLeft
//                     verticalAlignment: Text.AlignBottom

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                 }

//                 Rectangle {
//                     Layout.fillWidth: true
//                     Layout.preferredHeight: 35

//                     Layout.column: 1
//                     Layout.row: 1

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

//                     Text {
//                         id: text_BirthYear

//                         anchors.fill: parent
//                         anchors.leftMargin: 10

//                         horizontalAlignment: Text.AlignLeft
//                         verticalAlignment: Text.AlignVCenter

//                         color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                         font.pixelSize: Qt.application.font.pixelSize * 1
//                         elide: Text.ElideRight
//                     }
//                 }

//                 Text {
//                     Layout.column: 2
//                     Layout.row: 0

//                     text: qsTr("Phone number")

//                     horizontalAlignment: Text.AlignLeft
//                     verticalAlignment: Text.AlignBottom

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                 }

//                 Rectangle {
//                     Layout.fillWidth: true
//                     Layout.preferredHeight: 35

//                     Layout.column: 2
//                     Layout.row: 1

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

//                     Text {
//                         id: text_PhoneNumber

//                         anchors.fill: parent
//                         anchors.leftMargin: 10

//                         horizontalAlignment: Text.AlignLeft
//                         verticalAlignment: Text.AlignVCenter

//                         color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                         font.pixelSize: Qt.application.font.pixelSize * 1
//                         elide: Text.ElideRight
//                     }
//                 }

//                 Text {
//                     Layout.column: 0
//                     Layout.row: 2

//                     text: qsTr("Gender")

//                     horizontalAlignment: Text.AlignLeft
//                     verticalAlignment: Text.AlignBottom

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                 }

//                 Rectangle {
//                     Layout.fillWidth: true
//                     Layout.preferredHeight: 35

//                     Layout.column: 0
//                     Layout.row: 3

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

//                     Text {
//                         id: text_Gender

//                         anchors.fill: parent
//                         anchors.leftMargin: 10

//                         horizontalAlignment: Text.AlignLeft
//                         verticalAlignment: Text.AlignVCenter

//                         color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                         font.pixelSize: Qt.application.font.pixelSize * 1
//                         elide: Text.ElideRight
//                     }
//                 }

//                 Text {
//                     Layout.column: 1
//                     Layout.row: 2

//                     text: qsTr("Marital status")

//                     horizontalAlignment: Text.AlignLeft
//                     verticalAlignment: Text.AlignBottom

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                 }

//                 Rectangle {
//                     Layout.fillWidth: true
//                     Layout.preferredHeight: 35

//                     Layout.column: 1
//                     Layout.row: 3

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

//                     Text {
//                         id: text_MaritalStatus

//                         anchors.fill: parent
//                         anchors.leftMargin: 10

//                         horizontalAlignment: Text.AlignLeft
//                         verticalAlignment: Text.AlignVCenter

//                         color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                         font.pixelSize: Qt.application.font.pixelSize * 1
//                         elide: Text.ElideRight
//                     }
//                 }

//                 Text {
//                     Layout.column: 2
//                     Layout.row: 2

//                     text: qsTr("Service price")

//                     horizontalAlignment: Text.AlignLeft
//                     verticalAlignment: Text.AlignBottom

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                 }

//                 Rectangle {
//                     Layout.fillWidth: true
//                     Layout.preferredHeight: 35

//                     Layout.column: 2
//                     Layout.row: 3

//                     color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Background"])

//                     Text {
//                         id: text_ServicePrice

//                         anchors.fill: parent
//                         anchors.leftMargin: 10

//                         horizontalAlignment: Text.AlignLeft
//                         verticalAlignment: Text.AlignVCenter

//                         color: Qt.color(AppTheme.colors["UFO_Delegate_Field_Text"])
//                         font.pixelSize: Qt.application.font.pixelSize * 1
//                         elide: Text.ElideRight
//                     }
//                 }
//             }
//         }
//     }
// }

Item{}
