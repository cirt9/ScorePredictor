import QtQuick 2.9

Item {
    id: root
    width: textMetrics.width
    height: textMetrics.height

    property string text: "Searching"
    property bool running: false
    property alias color: indicatorText.color
    property alias fontSize: indicatorText.font.pointSize
    property alias fontBold: indicatorText.font.bold
    property real opacityOnRunning: 1

    Text {
        id: indicatorText
        text: root.text
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    TextMetrics {
        id: textMetrics
        text: root.text + ".."
        font.family: indicatorText.font
        font.pointSize: root.fontSize
        font.bold: root.fontBold
        elide: Text.ElideMiddle
    }

    Timer {
        id: dotTimer
        interval: 500
        repeat: true

        onTriggered: {
            if(indicatorText.text.length - root.text.length === 3)
                indicatorText.text = indicatorText.text.slice(0, root.text.length)
            else
                indicatorText.text += "."
        }
    }

    onRunningChanged: {
        if(running)
            dotTimer.start()
        else
        {
            dotTimer.stop()
            indicatorText.text = root.text
        }
    }

    states: [
        State {
            name: "notRunning"
            when: !root.running
            PropertyChanges {
                target: root
                opacity: 0
            }
        },
        State {
            name: "running"
            when: root.running
            PropertyChanges {
                target: root
                opacity: opacityOnRunning
            }
        }
    ]

    transitions: [
        Transition {
            from: "notRunning"; to: "running"; reversible: true
            NumberAnimation {
                properties: "opacity"
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
    ]
}
