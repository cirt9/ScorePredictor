import QtQuick 2.0

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
    property int inputBottomMargin: 20
    property bool charactersCounterVisible: true

    Rectangle {
        id: background
        opacity: 0.2
        anchors.fill: parent
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        cursorShape: Qt.IBeamCursor
        anchors.fill: inputArea
    }

    Text {
        id: placeholder
        color: fontColor
        font.pointSize: fontSize
        opacity: 0.6
        visible: !inputArea.text && !inputArea.focus ? true : false
        anchors.top: inputArea.top
        anchors.left: inputArea.left
    }

    TextInput {
        id: inputArea
        color: fontColor
        font.pointSize: fontSize
        wrapMode: Text.Wrap
        maximumLength: 250
        selectByMouse: true
        anchors.fill: background
        anchors.margins: 5
        anchors.bottomMargin: inputBottomMargin
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
