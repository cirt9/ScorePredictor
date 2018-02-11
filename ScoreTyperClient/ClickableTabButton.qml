import QtQuick 2.9
import QtQuick.Controls 2.2

TabButton {
    id: root

    checkable: false
    font.bold: true
    property color color: "#b2ab80"
    property color hoveredColor: "#ccc288"
    property color bottomBorderColor: "#303030"
    property color textColor: "#615d45"
    property color hoveredTextColor: "#494739"
    signal clicked()

    contentItem: Text {
        id: text

        text: parent.text
        font: parent.font
        color: root.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        id: background

        implicitWidth: 100
        implicitHeight: 40
        color: root.color

        Rectangle {
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
            color: "transparent"
            border.color: root.bottomBorderColor
        }
    }

    MouseArea {
        id: clickingArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: root.clicked()
        onPressed: animateTextScaleUp.start()
        onReleased: animateTextScaleDown.start()
        onEntered: {
            animateToHoveredColor.start();
            text.color = root.hoveredTextColor
            }
        onExited: {
                animateToNormalColor.start();
                text.color = root.textColor
            }
    }

    ColorAnimation {
        id: animateToHoveredColor
        target: background
        properties: "color"
        from: background.color
        to: root.hoveredColor
        duration: 300
        easing {type: Easing.OutInQuad;}
    }

    ColorAnimation {
        id: animateToNormalColor
        target: background
        properties: "color"
        from: background.color
        to: root.color
        duration: 300
        easing {type: Easing.InOutQuad;}
    }

    NumberAnimation {
       id: animateTextScaleUp
       target: text
       properties: "scale"
       from: text.scale
       to: 1.2
       duration: 100
       easing {type: Easing.InOutQuad;}
    }

    NumberAnimation {
       id: animateTextScaleDown
       target: text
       properties: "scale"
       from: text.scale
       to: 1.0
       duration: 100
       easing {type: Easing.OutInQuad;}
    }
}
