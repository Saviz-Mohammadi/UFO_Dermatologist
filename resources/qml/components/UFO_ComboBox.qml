import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import AppTheme 1.0
import CustomProxyModel 1.0

ComboBox {
    id: root

    property real dropDownTopMargin: 0
    property alias proxyModel: proxyModel.sourceModel // Bind source model for external updates

    opacity: enabled ? 1.0 : 0.5

    CustomProxyModel {
        id: proxyModel
        filterRole: root.textRole
    }

    model: proxyModel

    delegate: ItemDelegate {
        id: itemDelegate

        width: root.width
        height: 30

        contentItem: Text {
            leftPadding: 7
            text: model[root.textRole]

            color: itemDelegate.highlighted
                ? Qt.color(AppTheme.colors["UFO_ComboBox_Item_Text_Highlighted"])
                : Qt.color(AppTheme.colors["UFO_ComboBox_Item_Text_Normal"])

            font: root.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            width: root.width
            radius: 0
            color: itemDelegate.highlighted
                ? Qt.color(AppTheme.colors["UFO_ComboBox_Item_Background_Highlighted"])
                : Qt.color(AppTheme.colors["UFO_ComboBox_Item_Background_Normal"])
        }

        highlighted: root.highlightedIndex === index
    }

    contentItem: Text {
        leftPadding: 20
        rightPadding: root.indicator.width + root.spacing

        text: root.displayText
        font: root.font
        color: root.pressed
            ? Qt.color(AppTheme.colors["UFO_ComboBox_Text_Pressed"])
            : Qt.color(AppTheme.colors["UFO_ComboBox_Text_Normal"])
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
        radius: 0
        color: Qt.color(AppTheme.colors["UFO_ComboBox_Background"])
        border.color: root.pressed
            ? Qt.color(AppTheme.colors["UFO_ComboBox_Border_Pressed"])
            : Qt.color(AppTheme.colors["UFO_ComboBox_Border_Normal"])
        border.width: root.visualFocus ? 2 : 1
    }

    indicator: Canvas {
        id: canvas

        x: root.width - width - root.rightPadding
        y: root.topPadding + (root.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: root

            function onPressedChanged() {
                canvas.requestPaint();
            }
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = root.pressed
                ? Qt.color(AppTheme.colors["UFO_ComboBox_Arrow_Background_Pressed"])
                : Qt.color(AppTheme.colors["UFO_ComboBox_Arrow_Background_Normal"]);
            context.fill();
        }
    }

    popup: Popup {
        y: root.height - 1
        width: root.width
        implicitHeight: contentItem.implicitHeight
        padding: 0

        contentItem: ColumnLayout {
            TextInput {
                id: filterText
                Layout.preferredHeight: 30
                Layout.fillWidth: true
                onTextChanged: proxyModel.filterText = text; // Update filter text
            }

            ListView {
                id: listView
                Layout.preferredHeight: Math.min(contentHeight, 200)
                Layout.fillWidth: true
                clip: true
                model: root.popup.visible ? root.delegateModel : null
                currentIndex: root.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator {}
            }
        }

        background: Rectangle {
            radius: 0
            color: Qt.color(AppTheme.colors["UFO_ComboBox_Popup_Background"])
            border.color: Qt.color(AppTheme.colors["UFO_ComboBox_DropBox_Border"])
        }
    }
}
