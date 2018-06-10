import QtQuick 2.9

Item  {
    id: root

    property url iconSource
    property int iconMargin: 3
    property int radius: 3
    property int radiusOnPressed: 8
    property color color: "black"
    property alias backgroundOpacity: background.opacity
    signal clicked()

    Rectangle {
        id: background
        color: root.color
        radius: root.radius
        opacity: 0.0

        anchors.fill: parent
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

        onClicked: root.clicked()
    }

    states: [
        State {
            name: "notHovered"
            when: !mouseArea.containsMouse && !mouseArea.pressed
            PropertyChanges {
                target: background
                opacity: 0
                radius: root.radius
            }
        },
        State {
            name: "hovered"
            when: mouseArea.containsMouse && !mouseArea.pressed
            PropertyChanges {
                target: background
                opacity: 1
                radius: root.radius
            }
        },
        State {
            name: "pressed"
            when: mouseArea.pressed
            PropertyChanges {
                target: background
                radius: radiusOnPressed
                opacity: 1
            }
        }
    ]

    transitions: [
        Transition {
            from: "notHovered"; to: "hovered"; reversible: true
            NumberAnimation {
                properties: "opacity"
                duration: 250
                easing.type: Easing.InOutSine
            }
        },
        Transition {
            from: "hovered"; to: "pressed"; reversible: true
            NumberAnimation {
                properties: "radius"
                duration: 250
                easing.type: Easing.InOutSine
            }
        },
        Transition {
            from: "pressed"; to: "notHovered"; reversible: false
            NumberAnimation {
                properties: "radius, opacity"
                duration: 250
                easing.type: Easing.InOutSine
            }
        }
    ]
}
