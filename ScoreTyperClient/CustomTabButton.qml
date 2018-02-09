import QtQuick 2.9
import QtQuick.Controls 2.2

TabButton {
    id: root

    property color color: "#b2ab80"
    property color checkedColor: "#ccc288"
    property color bottomBorderColor: "#303030"
    property color textColor: "#303030"

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

    onCheckedChanged: {
        if(root.checked)
        {
            animateToCheckedColor.start()
            animateTextScaleUp.start()
        }
        else
        {
            animateTextScaleDown.start()
            animateToUncheckedColor.start()
        }
    }

    ColorAnimation {
        id: animateToCheckedColor
        target: background
        properties: "color"
        from: background.color
        to: root.checkedColor
        duration: 500
        easing {type: Easing.OutInQuad;}
    }

    ColorAnimation {
        id: animateToUncheckedColor
        target: background
        properties: "color"
        from: background.color
        to: root.color
        duration: 500
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
