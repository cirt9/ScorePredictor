import QtQuick 2.9

import QtQuick 2.9

Item  {
    id: root

    property url iconSource
    property int iconMargin: 3
    property int radius: 3
    property int radiusOnChecked: 8
    property color color: "black"
    property bool checked: false
    signal buttonChecked()
    signal buttonUnchecked()

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

        onClicked: {
            if(checked)
            {
                checked = false
                root.buttonUnchecked()
            }
            else
            {
                checked = true
                root.buttonChecked()
            }
        }
    }

    states: [
        State {
            name: "unchecked"
            when: !mouseArea.containsMouse && !checked
            PropertyChanges {
                target: background
                opacity: 0
                radius: root.radius
            }
        },
        State {
            name: "hovered"
            when: mouseArea.containsMouse && !checked
            PropertyChanges {
                target: background
                opacity: 0.5
                radius: root.radius
            }
        },
        State {
            name: "checked"
            when: checked
            PropertyChanges {
                target: background
                radius: radiusOnChecked
                opacity: 1
            }
        }
    ]

    transitions: [
        Transition {
            from: "unchecked"; to: "hovered"; reversible: true
            NumberAnimation {
                properties: "opacity"
                duration: 250
                easing.type: Easing.InOutSine
            }
        },
        Transition {
            from: "hovered"; to: "checked"; reversible: true
            NumberAnimation {
                properties: "radius, opacity"
                duration: 250
                easing.type: Easing.InOutSine
            }
        },
        Transition {
            from: "checked"; to: "unchecked"; reversible: false
            NumberAnimation {
                properties: "radius, opacity"
                duration: 250
                easing.type: Easing.InOutSine
            }
        }
    ]
}
