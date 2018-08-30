import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root
    property alias text: textDisplayArea.text
    property color scrollBarColor: "black"
    property int scrollBarWidth: 10
    property int textRightMargin: 10
    property alias fontSize: textDisplayArea.font.pointSize
    property alias textColor: textDisplayArea.color

    ScrollView {
        id: scrollView
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
        anchors.fill: parent

        style: ScrollViewStyle {
            handleOverlap: 0
            incrementControl: null
            decrementControl: null

            handle: Rectangle {
                implicitWidth: scrollBarWidth
                color: scrollBarColor
                radius: scrollBarWidth
            }

            scrollBarBackground: Rectangle {
                implicitWidth: scrollBarWidth
                color: scrollBarColor
                radius: scrollBarWidth
                opacity: 0.5
            }
        }

        Text {
            id: textDisplayArea
            width: root.width - textRightMargin
            wrapMode: Text.Wrap
        }
    }
}
