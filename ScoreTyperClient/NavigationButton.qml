import QtQuick 2.9

Item {
    id: root

    property bool checked: false
    property alias text: text.text
    property alias textColor: text.color
    property alias underlineColor: underline.color
    property int uncheckedFontSize: 10
    property int checkedFontSize: uncheckedFontSize
    property bool bold: true
    signal clicked()

    width: textMetrics.width + 35
    height: textMetrics.height + 10

    Text {
        id: text
        font.bold: root.bold
        font.pointSize: root.uncheckedFontSize
        anchors.centerIn: parent
    }

    Rectangle {
        id: underline
        width: parent.width
        height: 0
        radius: 1
        opacity: 0.3
        anchors.bottom: parent.bottom
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            root.clicked()
            checked = true
        }
        onEntered: {
            if(!checked)
                underline.height = 2
        }
        onExited: {
            if(!checked)
                underline.height = 0
        }
    }

    TextMetrics {
        id: textMetrics
        text: root.text
        font.family: text.font
        font.pointSize: root.uncheckedFontSize
        font.bold: root.bold
        elide: Text.ElideMiddle
    }

    states: [
        State {
            name: "checked"
            when: root.checked === true
            PropertyChanges { target: underline; opacity: 1.0 }
            PropertyChanges { target: text; font.pointSize: root.checkedFontSize }
            PropertyChanges { target: underline; height: 2 }
        },
        State {
            name: "unchecked"
            when: root.checked === false
            PropertyChanges { target: underline; opacity: 0.3 }
            PropertyChanges { target: text; font.pointSize: root.uncheckedFontSize }
            PropertyChanges { target: underline; height: 0 }
        }
    ]

    transitions: Transition {
            from: "checked"; to: "unchecked"; reversible: true
            NumberAnimation {
                properties: "opacity, font.pointSize, height"
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }
}
