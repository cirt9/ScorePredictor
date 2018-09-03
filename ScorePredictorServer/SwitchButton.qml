import QtQuick 2.0

Item {
    id: root

    property bool state: false
    property string falseStateText
    property string trueStateText
    property alias color: background.color
    property alias radius: background.radius
    property color textColor: "black"
    property int fontSize: 10
    property bool fontBold: false
    signal clicked()

    Rectangle {
        id: background
        color: "white"
        opacity: 0.7
        anchors.fill: parent

        MouseArea {
            id: mouseArea
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            anchors.fill: parent

            onClicked: root.clicked()
        }

        states: [
            State {
                name: "notHovered"
                when: !mouseArea.containsMouse
                PropertyChanges {
                    target: background
                    opacity: 0.7
                }
            },
            State {
                name: "hovered"
                when: mouseArea.containsMouse
                PropertyChanges {
                    target: background
                    opacity: 1.0
                }
            }
        ]

        transitions: Transition {
            from: "notHovered"; to: "hovered"; reversible: true
            NumberAnimation {
                properties: "opacity"
                duration: 250
                easing.type: Easing.Linear
            }
        }
    }

    Text {
        id: falseText
        color: root.textColor
        text: falseStateText
        font.pointSize: root.fontSize
        font.bold: root.fontBold
        opacity: 1.0
        anchors.centerIn: background
    }

    Text {
        id: trueText
        color: root.textColor
        text: trueStateText
        font.pointSize: root.fontSize
        font.bold: root.fontBold
        opacity: 0.0
        anchors.centerIn: background
    }

    states: [
        State {
            name: "falseState"
            when: !root.state

            PropertyChanges {
                target: falseText
                opacity: 1.0
            }

            PropertyChanges {
                target: trueText
                opacity: 0.0
            }
        },
        State {
            name: "trueState"
            when: root.state

            PropertyChanges {
                target: falseText
                opacity: 0.0
            }

            PropertyChanges {
                target: trueText
                opacity: 1.0
            }
        }
    ]

    transitions: [
        Transition {
            from: "falseState"; to: "trueState"; reversible: false

            SequentialAnimation {
                NumberAnimation {
                    target: falseText
                    properties: "opacity"
                    duration: 200
                    easing.type: Easing.Linear
                }

                NumberAnimation {
                    target: trueText
                    properties: "opacity"
                    duration: 200
                    easing.type: Easing.Linear
                }
            }
        },

        Transition {
            from: "trueState"; to: "falseState"; reversible: false

            SequentialAnimation {
                NumberAnimation {
                    target: trueText
                    properties: "opacity"
                    duration: 200
                    easing.type: Easing.Linear
                }

                NumberAnimation {
                    target: falseText
                    properties: "opacity"
                    duration: 200
                    easing.type: Easing.Linear
                }
            }
        }
    ]
}
