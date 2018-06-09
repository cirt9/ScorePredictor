import QtQuick 2.9

Item {
    id: root
    height: inputText.font.pointSize * 2
    clip: true

    property alias text: inputText.text
    property alias placeholderText: placeholder.text
    property int fontSize: 12
    property color textColor: "white"
    property color placeholderTextColor: textColor
    property alias selectedTextColor: inputText.selectedTextColor
    property alias selectionColor: inputText.selectionColor
    property alias selectByMouse: inputText.selectByMouse
    property alias maximumLength: inputText.maximumLength
    property alias echoMode: inputText.echoMode

    Text {
        id: placeholder
        text: placeholderText
        font.pointSize: inputText.font.pointSize
        color: placeholderTextColor
        opacity: 0.3
        x: inputText.x + inputText.width / 2 - textMetrics.width / 2
        y: inputText.y
    }

    TextMetrics {
        id: textMetrics
        text: placeholder.text
        font.family: placeholder.font
        font.pointSize: placeholder.font.pointSize
        font.bold: placeholder.font.bold
        elide: Text.ElideMiddle
    }

    TextInput {
        id: inputText
        color: textColor
        font.pointSize: fontSize
        activeFocusOnTab: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent

        onFocusChanged: {
            if(focus)
            {
                if(inputText.text.length === 0)
                    placeholder.opacity = 0
            }
            else {
                if(inputText.text.length === 0)
                    placeholder.opacity = 0.3
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            cursorShape: Qt.IBeamCursor
        }
    }
}
