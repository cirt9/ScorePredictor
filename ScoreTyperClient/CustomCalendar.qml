import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Calendar {
    id: root

    property color mainColor: "black"
    property color sideColor: "white"
    property color fontColor: "white"
    property color inactiveColor: "grey"
    property url previousIcon
    property url nextIcon

    style: CalendarStyle {
        gridVisible: true
        gridColor: mainColor

        background: Rectangle {
            color: mainColor
            implicitWidth: 250
            implicitHeight: 250
        }

        navigationBar: Rectangle {
            color: sideColor
            height: 35

            Text {
                text: styleData.title
                color: fontColor
                font.pointSize: 14
                anchors.centerIn: parent
            }

            IconButtonHover {
                id: leftButton
                iconSource: previousIcon
                color: mainColor
                height: parent.height
                width: height
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 3

                onClicked: root.showPreviousMonth()
            }

            IconButtonHover {
                id: rightButton
                iconSource: nextIcon
                color: mainColor
                height: parent.height
                width: height
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 3

                onClicked: root.showNextMonth()
            }

            Rectangle {
                width: parent.width
                height: 1
                color: mainColor
                anchors.bottom: parent.bottom
            }
        }

        dayOfWeekDelegate: Rectangle {
            color: sideColor
            height: 30

            Text {
                text: locale.dayName(styleData.dayOfWeek, Locale.ShortFormat)
                color: fontColor
                anchors.centerIn: parent
            }
        }

        dayDelegate: Rectangle {
            color: styleData.selected ? mainColor : sideColor

            Text {
                text: styleData.date.getDate()
                color: styleData.selected ? fontColor : (styleData.valid ? (styleData.visibleMonth ?
                                            fontColor : inactiveColor) : sideColor)
                anchors.centerIn: parent
            }
        }
    }

    function reset()
    {
        selectedDate = new Date()
    }
}
