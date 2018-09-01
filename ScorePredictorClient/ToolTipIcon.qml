import QtQuick 2.9
import QtQuick.Controls 2.3

Item {
    id: root
    property url iconSource
    property int margins: 0
    property int marginsOnHovered: 3
    property alias text: toolTip.text

    Image {
        id: icon
        source: iconSource
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
        }
    }

    ToolTip {
        id: toolTip
        parent: root
        visible: mouseArea.containsMouse
    }

    states: [
        State {
            name: "notHovered"
            when: !mouseArea.containsMouse
            PropertyChanges {
                target: icon
                anchors.margins: margins
            }
        },
        State {
            name: "hovered"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: icon
                anchors.margins: marginsOnHovered
            }
        }
    ]

    transitions: [
        Transition {
            from: "notHovered"; to: "hovered"; reversible: true
            NumberAnimation {
                properties: "anchors.margins"
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
    ]
}
