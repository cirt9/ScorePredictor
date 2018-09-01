import QtQuick 2.9

Rectangle {
    id: root
    color: "transparent"
    height: fontSize * 3
    clip: true

    property alias text: inputText.text
    property int fontSize: 10
    property int placeholderTextSize: fontSize / 2
    property color textColor: "white"
    property color placeholderTextColor: textColor
    property color underlineColor: "white"
    property color underlineColorOnFocus: "black"
    property color underlineColorBadData: "red"
    property alias selectedTextColor: inputText.selectedTextColor
    property alias selectionColor: inputText.selectionColor
    property alias placeholderText: placeholder.text
    property alias selectByMouse: inputText.selectByMouse
    property alias maximumLength: inputText.maximumLength
    property alias echoMode: inputText.echoMode
    property bool whitespacesAllowed: false
    signal focused()

    Text {
        id: placeholder
        text: placeholderText
        font.pointSize: fontSize
        color: placeholderTextColor
        opacity: 0.3
        x: inputText.x
        y: inputText.y
    }

    TextInput {
        id: inputText
        color: textColor
        font.pointSize: fontSize
        width: parent.width
        anchors.bottom: root.bottom
        anchors.left: parent.left
        anchors.bottomMargin: fontSize / 3
        activeFocusOnTab: true

        onFocusChanged: {
            if(focus)
            {
                if(inputText.text.length === 0)
                    animateMinimizingPlaceholder.start()
                underline.color = underlineColorOnFocus
                underline.height = 2
                underline.opacity = 1.0
                root.focused()
            }
            else if(inputText.text.length === 0)
            {
                animateEnlargingPlaceholder.start()
                underline.height = 1
                underline.color = underlineColor
                underline.opacity = 0.3
            }
            else
            {
                underline.height = 1
                underline.color = underlineColor
                underline.opacity = 0.3
            }
        }
        onTextChanged: {
            if(inputText.text.length === 0 && !focus)
            {
                animateEnlargingPlaceholder.start()
                underline.height = 1
                underline.color = underlineColor
                underline.opacity = 0.3
            }
            if(!whitespacesAllowed)
                inputText.text = inputText.text.split(' ').join('')
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            cursorShape: Qt.IBeamCursor

            onEntered: {
                underline.height = 2
                underline.opacity = 1.0
            }
            onExited: {
                if(!inputText.focus)
                {
                    underline.height = 1
                    underline.opacity = 0.3
                }
            }
        }
    }

    Rectangle {
        id: underline
        color: underlineColor
        width: parent.width
        height: 1
        radius: 1
        opacity: 0.3
        anchors.bottom: parent.bottom
    }

    ParallelAnimation {
        id: animateMinimizingPlaceholder

        NumberAnimation {
           target: placeholder
           properties: "font.pointSize"
           from: font.pointSize
           to: placeholderTextSize
           duration: 70
           easing {type: Easing.Linear;}
        }

        PathAnimation {
            target: placeholder
            path: Path {
                PathCurve { x: 0; y: 0}
            }
            duration: 100
        }
    }

    ParallelAnimation {
        id: animateEnlargingPlaceholder

        NumberAnimation {
           target: placeholder
           properties: "font.pointSize"
           from: font.pointSize
           to: fontSize
           duration: 100
           easing {type: Easing.Linear;}
        }

        PathAnimation {
            target: placeholder
            path: Path {
                PathCurve { x: inputText.x; y: inputText.y}
            }
            duration: 100
        }
    }

    function markBadData()
    {
        underline.color = underlineColorBadData
    }
}
