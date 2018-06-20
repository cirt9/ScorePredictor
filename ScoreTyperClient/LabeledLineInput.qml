import QtQuick 2.9

Rectangle {
    id: root
    color: labelAreaColor
    height: descriptionMetrix.height * 1.5
    width: labelWidth + inputWidth + 25
    radius: 10

    property alias labelText: label.text
    property alias text: inputText.text
    property int fontSize: 14
    property alias inputWidth: inputArea.width
    property int labelWidth: descriptionMetrix.width
    property color labelTextColor: "red"
    property color inputTextColor: labelTextColor
    property color labelAreaColor: "black"
    property color inputAreaColor: "white"
    property alias selectedTextColor: inputText.selectedTextColor
    property alias selectionColor: inputText.selectionColor
    property alias selectByMouse: inputText.selectByMouse
    property alias maximumLength: inputText.maximumLength
    property alias echoMode: inputText.echoMode
    property bool whitespacesAllowed: false

    Text {
        id: label
        color: labelTextColor
        font.pointSize: fontSize
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
    }

    TextMetrics {
        id: descriptionMetrix
        text: label.text
        font.family: label.font
        font.pointSize: label.font.pointSize
        font.bold: label.font.bold
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
