import QtQuick 2.9

Item {
    id: root

    property string text
    property color textColor
    property color textColorHovered: textColor
    property color textColorPressed: textColorHovered
    property string font: "Arial"
    property int fontSize: 12
    property bool bold: false
    signal clicked()

    width: textMetrics.width
    height: textMetrics.height

    TextMetrics {
        id: textMetrics
        text: root.text
        font.family: root.font
        font.pointSize: root.fontSize
        font.bold: root.bold
        elide: Text.ElideMiddle
    }

    Text {
        id: buttonText

        text: root.text
        color: root.textColor

        font.family: root.font
        font.pointSize: fontSize
        font.bold: root.bold
        elide: Text.ElideMiddle

        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: root.clicked()
        onPressed: {
            animateToPressedColor.start()
            animateTextScaleUp.start()
        }
        onReleased: {
            animateTextScaleDown.start()
            if(containsMouse)
                animateToHoverColor.start()
            else
                animateToNormalColor.start()
        }
        onEntered: animateToHoverColor.start()
        onExited: animateToNormalColor.start()
    }

    NumberAnimation {
       id: animateTextScaleUp
       target: buttonText
       properties: "scale"
       from: buttonText.scale
       to: 1.1
       duration: 100
       easing {type: Easing.InOutQuad;}
    }

    NumberAnimation {
       id: animateTextScaleDown
       target: buttonText
       properties: "scale"
       from: buttonText.scale
       to: 1.0
       duration: 100
       easing {type: Easing.OutInQuad;}
    }

    ColorAnimation {
        id: animateToNormalColor
        target: buttonText
        properties: "color"
        from: buttonText.color
        to: textColor
        duration: 250
        easing {type: Easing.InOutQuad;}
    }

    ColorAnimation {
        id: animateToHoverColor
        target: buttonText
        properties: "color"
        from: buttonText.color
        to: textColorHovered
        duration: 250
        easing {type: Easing.InOutQuad;}
    }

    ColorAnimation {
        id: animateToPressedColor
        target: buttonText
        properties: "color"
        from: buttonText.color
        to: textColorPressed
        duration: 250
        easing {type: Easing.InOutQuad;}
    }
}
