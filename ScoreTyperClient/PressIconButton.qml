import QtQuick 2.9

Item {
    id: root
    clip: true

    property url iconSource
    property alias color: background.color
    property alias radius: background.radius
    property int iconMargin: 3
    readonly property alias buttonPressed: mouseArea.pressed
    signal pressedChanged()

    Rectangle {
        id: background
        opacity: 0
        anchors.fill: parent
    }

    Rectangle {
        id: backgroundSurface
        color: background.color
        width: 0
        height: 0
        radius: root.width
        opacity: 1
        anchors.centerIn: parent
    }

    Image {
        source: iconSource
        fillMode: Image.PreserveAspectFit

        anchors.fill: parent
        anchors.margins: iconMargin
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onPressedChanged: root.pressedChanged()
    }

    states: [
        State {
            name: "notHovered"
            when: !mouseArea.containsMouse && !mouseArea.pressed
            PropertyChanges { target: background; opacity: 0 }
            PropertyChanges {
                target: backgroundSurface
                width: 0
                height: 0
                radius: root.width
            }
        },
        State {
            name: "hovered"
            when: mouseArea.containsMouse && !mouseArea.pressed
            PropertyChanges { target: background; opacity: 0.5 }
        },
        State {
            name: "pressed"
            when: mouseArea.pressed
            PropertyChanges { target: background; opacity: 0.5 }
            PropertyChanges {
                target: backgroundSurface
                width: root.radius === 0 ? (root.width > root.height ? root.width * 1.4 : root.height * 1.4) : root.width
                height: root.radius === 0 ? (root.height > root.width ? root.height * 1.4 : root.width * 1.4) : root.height
                radius: root.radius
            }
        }
    ]

    transitions: [
        Transition {
            from: "notHovered"; to: "hovered"; reversible: true
            NumberAnimation {
                properties: "opacity"
                duration: 250
                easing.type: Easing.Linear
            }
        },
        Transition {
            from: "hovered"; to: "pressed"; reversible: true
            NumberAnimation {
                target: backgroundSurface
                properties: "width, height, radius"
                duration: 300
                easing.type: Easing.Linear
            }
        },
        Transition {
            from: "pressed"; to: "notHovered"; reversible: false
                NumberAnimation {
                    target: backgroundSurface
                    properties: "width, height, radius"
                    duration: 200
                    easing.type: Easing.Linear
                }
                NumberAnimation {
                    target: background
                    properties: "opacity"
                    duration: 500
                    easing.type: Easing.Linear
                }
        }
    ]
}
