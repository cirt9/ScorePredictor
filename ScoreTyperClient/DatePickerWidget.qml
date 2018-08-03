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
    property bool calendarAlignRight: false
    property bool calendarAlignLeft: false
    property alias calendarWidth: calendar.implicitWidth
    property alias calendarHeight: calendar.implicitHeight

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
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

    CustomCalendar {
        id: calendar
        visible: false
        mainColor: calendarMainColor
        sideColor: calendarSideColor
        fontColor: fontColor
        inactiveColor: calendarInactiveColor
        previousIcon: root.previousIcon
        nextIcon: root.nextIcon
        anchors.top: parent.bottom
        anchors.topMargin: 5

        Component.onCompleted: {
            if(calendarAlignLeft)
                anchors.left = parent.left
            else if(calendarAlignRight)
                anchors.right = parent.right
            else
                anchors.horizontalCenter = parent.horizontalCenter
        }
    }

    function showCalendar()
    {
        expandCalendarButton.checked = true
        calendar.visible = true
    }

    function hideCalendar()
    {
        expandCalendarButton.checked = false
        calendar.visible = false
    }

    function reset()
    {
        hideCalendar()
        calendar.reset()
    }
}
