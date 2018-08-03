import QtQuick 2.9

Item {
    id: root

    property alias text: input.text
    property alias placeholderText: placeholder.text
    property color color: "white"
    property int radius: 3
    property int fontSize: 12
    property alias maxLength: input.maximumLength
    property alias echoMode: input.echoMode
    property alias selectByMouse: input.selectByMouse
    property alias selectedTextColor: input.selectedTextColor
    property alias selectionColor: input.selectionColor
    property bool trimText: false
    readonly property int lengthWithoutWhitespaces: calculateLengthWithoutWhitespaces()

    Rectangle {
        id: inputBorder
        color: "transparent"
        border.color: root.color
        border.width: 2
        radius: root.radius
        opacity: 0.3
        anchors.fill: parent
    }

    Rectangle {
        id: inputBackground
        color: root.color
        opacity: input.activeFocus ? 0.15 : 0.1
        anchors.fill: inputBorder
        anchors.margins: inputBorder.border.width
    }

    Item {
        id: inputArea
        clip: true
        anchors.fill: inputBackground
        anchors.margins: 2

        Text {
            id: placeholder
            color: root.color
            font.pointSize: fontSize
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            opacity: 0.5
            visible: input.text.length === 0 && !input.activeFocus ? true : false
            anchors.fill: parent
        }

        TextInput {
            id: input
            color: root.color
            font.pointSize: root.fontSize
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            activeFocusOnTab: true
            anchors.fill: parent

            onEditingFinished: {
                if(trimText)
                    input.text = input.text.trim()
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            cursorShape: Qt.IBeamCursor
        }
    }

    states: [
        State {
            name: "unfocused"
            when: !input.activeFocus
            PropertyChanges {
                target: inputBackground
                opacity: 0.1
            }
        },
        State {
            name: "focused"
            when: input.activeFocus
            PropertyChanges {
                target: inputBackground
                opacity: 0.15
            }
        }
    ]

    transitions: [
        Transition {
            from: "unfocused"; to: "focused"; reversible: true
            NumberAnimation {
                properties: "opacity"
                duration: 150
                easing.type: Easing.Linear
            }
        }
    ]

    function calculateLengthWithoutWhitespaces()
    {
        var numberOfWhitespaces = 0

        for(var i=0; i<text.length; i++)
        {
            if(text.charAt(i) === " ")
                numberOfWhitespaces += 1
        }

        return text.length - numberOfWhitespaces
    }

    function reset()
    {
        input.text = ""
        input.focus = false
    }
}
