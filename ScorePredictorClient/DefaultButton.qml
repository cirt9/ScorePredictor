import QtQuick 2.9

Item {
    id: root
    width: textMetrics.width * 1.15
    height: textMetrics.height * 1.25
    clip: true

    property alias fontSize: label.font.pointSize
    property alias textColor: label.color
    property alias fontBold: label.font.bold
    property color color: "black"
    property int borderWidth: 2
    property alias text: label.text
    property int radius: 0
    signal clicked()

    Rectangle {
        id: background
        color: "transparent"
        border.color: root.color
        border.width: borderWidth
        radius: root.radius
        anchors.fill: parent

        Rectangle {
            id: surface
            color: root.color
            radius: parent.radius
            opacity: 0.9
            anchors.fill: parent
        }
    }

    TextMetrics {
        id: textMetrics
        text: label.text
        font.pointSize: fontSize
        font.family: label.font
        font.bold: label.font.bold
    }

    Rectangle {
        id: highlight
        opacity: 0
        color: "white"
        radius: root.radius
        anchors.fill: parent
    }

    Text {
        id: label
        anchors.centerIn: parent
        font.bold: true
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent

        onClicked: root.clicked()
    }

    states: [
        State {
            name: "notHovered"
            when: !mouseArea.containsMouse  && !mouseArea.pressed
            PropertyChanges {
                target: surface
                opacity: 0.9
            }
            PropertyChanges {
                target: background
                radius: root.radius
                anchors.margins: 0
            }
        },
        State {
            name: "hovered"
            when: mouseArea.containsMouse  && !mouseArea.pressed
            PropertyChanges {
                target: surface
                opacity: 1
            }
        },
        State {
            name: "pressed"
            when: mouseArea.pressed
            PropertyChanges {
                target: surface
                opacity: 1
            }
            PropertyChanges {
                target: background
                anchors.margins: 1
                radius: root.radius + 3
            }
        }
    ]

    transitions: [
        Transition {
            from: "notHovered"; to: "hovered"; reversible: true
            NumberAnimation {
                properties: "opacity"
                duration: 200
                easing.type: Easing.InOutSine
            }
        },
        Transition {
            from: "hovered"; to: "pressed"; reversible: true
            NumberAnimation {
                properties: "anchors.margins, radius"
                duration: 200
                easing.type: Easing.InOutSine
            }
        },
        Transition {
            from: "pressed"; to: "notHovered"; reversible: true
            NumberAnimation {
                target: background
                properties: "anchors.margins, radius"
                duration: 200
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                target: surface
                properties: "opacity"
                duration: 200
                easing.type: Easing.InOutSine
            }
        }
    ]
}
