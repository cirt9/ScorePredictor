import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: root
    width: textMetrics.width + expandCalendarButton.width * 2 + border.width * 2
    height: textMetrics.height * 1.3 + border.width * 2

    readonly property string simplifiedDate: dateText.text
    readonly property date date: calendar.selectedDate
    property alias fontSize: dateText.font.pointSize
    property alias fontColor: dateText.color
    property alias hoveredButtonColor: expandCalendarButton.color
    property alias selectedTextColor: dateText.selectedTextColor
    property alias selectionColor: dateText.selectionColor
    property alias selectByMouse: dateText.selectByMouse
    property bool selectByKeyboard : selectByMouse
    property url expandCalendarIcon
    property url previousIcon
    property url nextIcon
    property color calendarMainColor: "black"
    property color calendarSideColor: "white"
    property color calendarInactiveColor: "grey"
    property alias minimumDate: calendar.minimumDate
    property alias maximumDate: calendar.maximumDate

    MouseArea {
        anchors.fill: parent
        onClicked: hideCalendar()
    }

    TextEdit {
        id: dateText
        text: calendar.selectedDate.toLocaleDateString(Qt.locale(), "dd.MM.yyyy")
        readOnly: true
        selectByKeyboard: root.selectByKeyboard
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: root.border.width + 3
    }

    TextMetrics {
        id: textMetrics
        font.pointSize: fontSize
        font.family: dateText.font
        text: dateText.text
    }

    CheckableIconButton {
        id: expandCalendarButton
        iconSource: expandCalendarIcon
        color: hoveredButtonColor
        height: parent.height
        width: height
        radius: parent.radius - 3
        radiusOnChecked: parent.radius
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: radius === 0 ? root.border.width : root.border.width + 3

        onButtonChecked: showCalendar()
        onButtonUnchecked: hideCalendar()
    }

    Calendar {
        id: calendar
        visible: false
        anchors.top: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5

        style: CalendarStyle {
                gridVisible: true
                gridColor: calendarMainColor

                background: Rectangle {
                    color: calendarMainColor
                    implicitWidth: 250
                    implicitHeight: 250
                }

                navigationBar: Rectangle {
                    color: calendarSideColor
                    height: 35

                    Label {
                        text: styleData.title
                        color: fontColor
                        font.pointSize: 14
                        anchors.centerIn: parent
                    }

                    IconButton {
                        id: leftButton
                        iconSource: previousIcon
                        color: calendarMainColor
                        height: parent.height
                        width: height
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 3

                        onClicked: calendar.showPreviousMonth()
                    }

                    IconButton {
                        id: rightButton
                        iconSource: nextIcon
                        color: calendarMainColor
                        height: parent.height
                        width: height
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 3

                        onClicked: calendar.showNextMonth()
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: calendarMainColor
                        anchors.bottom: parent.bottom
                    }
                }

                dayOfWeekDelegate: Rectangle {
                    color: calendarSideColor
                    height: 30

                    Label {
                        text: locale.dayName(styleData.dayOfWeek, Locale.ShortFormat)
                        color: fontColor
                        anchors.centerIn: parent
                    }
                }

                dayDelegate: Rectangle {
                    color: styleData.selected ? calendarMainColor : calendarSideColor

                    Label {
                        text: styleData.date.getDate()
                        color: styleData.selected ? fontColor : (styleData.valid ? (styleData.visibleMonth ?
                                                    fontColor : calendarInactiveColor) : calendarSideColor)
                        anchors.centerIn: parent
                    }
                }
            }
    }

    function showCalendar() {
        expandCalendarButton.checked = true
        calendar.visible = true
    }

    function hideCalendar() {
        expandCalendarButton.checked = false
        calendar.visible = false
    }
}
