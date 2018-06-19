import QtQuick 2.9

Rectangle {
    id: root
    color: descriptionAreaColor
    height: descriptionMetrix.height * 1.5
    width: descriptionWidth + inputWidth + 25
    radius: 10

    property alias description: descriptionText.text
    property alias text: inputText.text
    property int fontSize: 14
    property alias inputWidth: inputArea.width
    property int descriptionWidth: descriptionMetrix.width
    property color descriptionTextColor: "red"
    property color inputTextColor: descriptionTextColor
    property color descriptionAreaColor: "black"
    property color inputAreaColor: "white"
    property alias selectedTextColor: inputText.selectedTextColor
    property alias selectionColor: inputText.selectionColor
    property alias selectByMouse: inputText.selectByMouse
    property alias maximumLength: inputText.maximumLength
    property alias echoMode: inputText.echoMode
    property bool whitespacesAllowed: false

    Text {
        id: descriptionText
        color: descriptionTextColor
        font.pointSize: fontSize
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
    }

    TextMetrics {
        id: descriptionMetrix
        text: descriptionText.text
        font.family: descriptionText.font
        font.pointSize: descriptionText.font.pointSize
        font.bold: descriptionText.font.bold
        elide: Text.ElideMiddle
    }

    Rectangle {
        id: inputArea
        color: inputAreaColor
        height: root.height - 10
        radius: parent.radius / 2
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 5

        TextInput {
            id: inputText
            color: inputTextColor
            font.pointSize: fontSize
            activeFocusOnTab: true
            anchors.fill: parent
            anchors.leftMargin: inputArea.radius
            anchors.rightMargin: inputArea.radius
            clip: true

            onTextChanged: {
                if(!whitespacesAllowed)
                    inputText.text = inputText.text.split(' ').join('')
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                cursorShape: Qt.IBeamCursor
            }
        }
    }
}
