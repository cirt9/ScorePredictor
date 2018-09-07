import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root
    clip: true

    property alias text: inputArea.text
    property alias backgroundColor: background.color
    property alias backgroundRadius: background.radius
    property alias placeholderText: placeholder.text
    property color fontColor: "white"
    property int fontSize: 12
    property int counterFontSize: 10
    property alias maximumLength: inputArea.maximumLength
    property alias wrapMode: inputArea.wrapMode
    property alias selectByMouse: inputArea.selectByMouse
    property alias selectionColor: inputArea.selectionColor
    property alias selectedTextColor: inputArea.selectedTextColor
    property color scrollBarColor: "black"
    property int scrollBarWidth: 10
    property int scrollBarRadius: 10
    property bool charactersCounterVisible: true
    property int inputAreaRightMargin: 30

    Rectangle {
        id: background
        opacity: 0.2
        anchors.fill: parent
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        cursorShape: Qt.IBeamCursor
        anchors.fill: background
        anchors.rightMargin: 15
        anchors.leftMargin: 15
        anchors.topMargin: 10
        anchors.bottomMargin: charactersCounter.contentHeight + 10

        onClicked: inputArea.forceActiveFocus()
    }

    Text {
        id: placeholder
        color: fontColor
        font.pointSize: fontSize
        opacity: 0.6
        visible: !inputArea.text && !inputArea.focus ? true : false
        anchors.top: background.top
        anchors.left: background.left
    }

    ScrollView {
        id: scrollView
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
        anchors.fill: background
        anchors.rightMargin: 1
        anchors.leftMargin: 15
        anchors.topMargin: 10
        anchors.bottomMargin: charactersCounter.contentHeight + 10

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

        TextInput {
            id: inputArea
            width: background.width - inputAreaRightMargin
            color: fontColor
            font.pointSize: fontSize
            wrapMode: Text.Wrap
            maximumLength: 250
            selectByMouse: true
            activeFocusOnTab: true
        }
    }

    Text {
        id: charactersCounter
        text: inputArea.text.length + "/" + inputArea.maximumLength
        color: fontColor
        font.pointSize: counterFontSize
        opacity: 0.6
        visible: charactersCounterVisible
        anchors.right: background.right
        anchors.bottom: background.bottom
        anchors.margins: 5
    }
}
