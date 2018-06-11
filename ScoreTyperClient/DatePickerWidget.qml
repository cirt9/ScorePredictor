import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: root
    width: textMetrics.width + expandCalendarButton.width * 2 + border.width * 2
    height: textMetrics.height * 1.5 + border.width * 2

    readonly property string date: dateText.text
    property alias fontSize: dateText.font.pointSize
    property alias fontColor: dateText.color
    property alias hoveredButtonColor: expandCalendarButton.color
    property alias selectedTextColor: dateText.selectedTextColor
    property alias selectionColor: dateText.selectionColor
    property alias selectByMouse: dateText.selectByMouse
    property bool selectByKeyboard : selectByMouse
    property url expandCalendarIcon

    MouseArea {
        anchors.fill: parent
        onClicked: calendar.visible = false
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

    IconButton {
        id: expandCalendarButton
        iconSource: expandCalendarIcon
        color: hoveredButtonColor
        height: parent.height
        width: height
        radius: parent.radius - 3
        radiusOnPressed: parent.radius
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: radius === 0 ? root.border.width : root.border.width + 3

        onClicked: {
            if(calendar.visible)
                calendar.visible = false
            else
                calendar.visible = true
        }
    }

    Calendar {
        id: calendar
        visible: false
        anchors.top: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5

        style: CalendarStyle {
                gridVisible: true
                gridColor: mainWindow.colorB

                background: Rectangle {
                    color: "#6A352E"
                    implicitWidth: 250
                    implicitHeight: 250
                }

                navigationBar: Rectangle {
                    color: "#6A352E"
                    height: 35

                    Label {
                        text: styleData.title
                        color: mainWindow.fontColor
                        font.pointSize: 14
                        anchors.centerIn: parent
                    }

                    IconButton {
                        id: leftButton
                        iconSource: "qrc://assets/icons/icons/icons8_Chevron_Left.png"
                        color: mainWindow.colorB
                        height: parent.height
                        width: height
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 3
                    }

                    IconButton {
                        id: rightButton
                        iconSource: "qrc://assets/icons/icons/icons8_Chevron_Right.png"
                        color: mainWindow.colorB
                        height: parent.height
                        width: height
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 3
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: mainWindow.colorB
                        anchors.bottom: parent.bottom
                    }
                }

                dayOfWeekDelegate: Rectangle {
                    color: "#6A352E"
                    height: 30

                    Label {
                        text: locale.dayName(styleData.dayOfWeek, Locale.ShortFormat)
                        color: mainWindow.fontColor
                        anchors.centerIn: parent
                    }
                }

                dayDelegate: Rectangle {
                    color: styleData.selected ? mainWindow.colorB : (styleData.visibleMonth && styleData.valid ? "#6A352E" : "#6A352E")

                    Label {
                        text: styleData.date.getDate()
                        color: styleData.visibleMonth && styleData.valid ? mainWindow.fontColor : "#766363"
                        anchors.centerIn: parent
                    }
                }
            }
    }
}
