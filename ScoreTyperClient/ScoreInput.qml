import QtQuick 2.9

Item {
    id: root
    property int maxLength: 3
    property color color: "white"
    property int inputWidth: 30
    property int inputHeight: 30
    property alias leftScore: leftScoreText.text
    property alias rightScore: rightScoreText.text
    property alias enteredLeftScore: leftScoreInput.text
    property alias enteredRightScore: rightScoreInput.text

    Rectangle {
        id: leftScoreBorder
        width: inputWidth
        height: inputHeight
        color: "transparent"
        border.color: root.color
        border.width: 2
        radius: 3
        opacity: 0.3
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: leftScoreBackground
        color: root.color
        opacity: 0.1
        anchors.fill: leftScoreBorder
        anchors.margins: leftScoreBorder.border.width
    }

    Item {
        id: leftScoreInputArea
        clip: true
        anchors.fill: leftScoreBackground

        Text {
            id: leftScoreText
            color: root.color
            font.pointSize: leftScoreBorder.width / 3
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            visible: leftScoreInput.text.length === 0 && !leftScoreInput.activeFocus ? true : false
            anchors.fill: parent
        }

        TextInput {
            id: leftScoreInput
            color: root.color
            font.pointSize: leftScoreBorder.width / 3
            maximumLength: maxLength
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            activeFocusOnTab: true
            validator : RegExpValidator { regExp : /[0-9]+/ }
            anchors.fill: parent
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            cursorShape: Qt.IBeamCursor
        }
    }

    Text {
        id: colon
        text: ":"
        color: root.color
        font.pointSize: leftScoreBorder.height / 2
        anchors.left: leftScoreBorder.right
        anchors.verticalCenter: leftScoreBorder.verticalCenter
    }

    Rectangle {
        id: rightScoreBorder
        width: inputWidth
        height: inputHeight
        color: "transparent"
        border.color: root.color
        border.width: 2
        radius: 3
        opacity: 0.3
        anchors.left: colon.right
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: rightScoreBackground
        color: root.color
        opacity: 0.1
        anchors.fill: rightScoreBorder
        anchors.margins: rightScoreBorder.border.width
    }

    Item {
        id: rightScoreInputArea
        clip: true
        anchors.fill: rightScoreBackground

        Text {
            id: rightScoreText
            color: root.color
            font.pointSize: rightScoreBorder.width / 3
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            visible: rightScoreInput.text.length === 0 && !rightScoreInput.activeFocus ? true : false
            anchors.fill: parent
        }

        TextInput {
            id: rightScoreInput
            color: root.color
            font.pointSize: rightScoreBorder.width / 3
            maximumLength: maxLength
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            activeFocusOnTab: true
            validator : RegExpValidator { regExp : /[0-9]+/ }
            anchors.fill: parent
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            cursorShape: Qt.IBeamCursor
        }
    }

    function reset()
    {
        leftScoreInput.text = ""
        rightScoreInput.text = ""
    }
}
