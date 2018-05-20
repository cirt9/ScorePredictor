import QtQuick 2.9

Item  {
    id: root

    property url iconSource
    property int iconMargin: 3
    property int backgroundRadius: 3
    property int backgroundRadiusOnPressed: 8
    property color backgroundColor: "#ccc288"
    signal clicked()

    Rectangle {
        id: background
        color: backgroundColor
        radius: backgroundRadius
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
        id: clickingArea
        anchors.fill: parent
        hoverEnabled: true

        onFocusChanged: {
            if(!focus && !hovered)
                animateOpacityOnExited.start()
        }

        onClicked: root.clicked()
        onPressed: animateRadiusOnPressed.start()
        onReleased: animateRadiusOnReleased.start()
        onEntered: animateOpacityOnEntered.start()
        onExited: animateOpacityOnExited.start()
    }

    NumberAnimation {
       id: animateOpacityOnEntered
       target: background
       properties: "opacity"
       from: 0.0
       to: 1.0
       duration: 250
       easing {type: Easing.InOutSine;}
    }

    NumberAnimation {
       id: animateOpacityOnExited
       target: background
       properties: "opacity"
       from: background.opacity
       to: 0.0
       duration: 250
       easing {type: Easing.OutInSine;}
    }

    NumberAnimation {
       id: animateRadiusOnPressed
       target: background
       properties: "radius"
       from: backgroundRadius
       to: backgroundRadiusOnPressed
       duration: 250
       easing {type: Easing.InOutSine;}
    }

    NumberAnimation {
       id: animateRadiusOnReleased
       target: background
       properties: "radius"
       from: background.radius
       to: backgroundRadius
       duration: 250
       easing {type: Easing.OutInSine;}
    }
}
