import QtQuick 2.9

Item {
    id: root
    property url iconSource
    property int margins: 0
    property int marginsOnPressed: 3
    signal clicked()

    Image {
        id: icon
        source: iconSource
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true

            onClicked: root.clicked()
        }
    }

    states: [
        State {
            name: "released"
            when: !mouseArea.pressed && root.enabled
            PropertyChanges {
                target: icon
                anchors.margins: margins
            }
        },
        State {
            name: "pressed"
            when: mouseArea.pressed && root.enabled
            PropertyChanges {
                target: icon
                anchors.margins: marginsOnPressed
            }
        },
        State {
            name: "disabled"
            when: !root.enabled
            PropertyChanges {
                target: icon
                anchors.margins: marginsOnPressed
            }
        }
    ]

    transitions: [
        Transition {
            from: "released"; to: "pressed"; reversible: true
            NumberAnimation {
                properties: "anchors.margins"
                duration: 100
                easing.type: Easing.InOutQuad
            }
        },
        Transition {
            from: "released"; to: "disabled"; reversible: true
            NumberAnimation {
                properties: "anchors.margins"
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
    ]
}
