import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Custom QML Files
import "./../components"

// Custom CPP Registered Types
import AppTheme 1.0

UFO_Page {
    id: root

    title: qsTr("درباره برنامه")
    contentSpacing: 25

    UFO_GroupBox {
        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("اطلاعات کلی")
        contentSpacing: 7

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 20
            Layout.bottomMargin: 20
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            text: qsTr("نام برنامه: مطب") + "     " + qsTr("نسخه برنامه: 0.0.1")
            wrapMode: Text.Wrap
            elide: Text.ElideRight
        }
    }

    UFO_GroupBox {
        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("مجوز نرم‌افزار")
        contentSpacing: 7

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 20
            Layout.bottomMargin: 20
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            text: qsTr("Copyright © 2025 Saviz Mohammadi") + "\n"
                  + qsTr("Licensed under the MIT License. See LICENSE for details.")
                  + "\n\n" + qsTr(
                      "MIT License") + "\n\n" + qsTr("Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"UFO_Dermatologist\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:") + "\n\n" + qsTr(
                      "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.") + "\n\n" + qsTr("THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.")
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }
    }

    UFO_GroupBox {
        Layout.fillWidth: true
        // NOTE (SAVIZ): No point using "Layout.fillHeight" as "UFO_Page" ignores height to enable vertical scrolling.

        title: qsTr("مشارکت")
        contentSpacing: 7

        Text {
            Layout.fillWidth: true

            Layout.topMargin: 20
            Layout.bottomMargin: 0
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: qsTr("ما از پشتیبانی در این برنامه استقبال می‌کنیم! لطفاً برای اطلاعات بیشتر با کلیک روی دکمه زیر به صفحه گیت‌هاب ما مراجعه کنید.")
            color: Qt.color(AppTheme.colors["UFO_GroupBox_Content_Text"])
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }

        UFO_Button {
            Layout.topMargin: 15
            Layout.bottomMargin: 20
            Layout.leftMargin: 15
            Layout.rightMargin: 15

            text: "گیت‌هاب"
            icon.source: "./../../icons/Google icons/globe.svg"

            onClicked: {
                Qt.openUrlExternally("https://github.com/Saviz-Mohammadi/UFO_Dermatologist")
            }
        }
    }
}
