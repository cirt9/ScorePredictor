import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: root
    width: textMetrics.width + expandCalendarButton.width * 2 + border.width * 2
    height: textMetrics.height * 1.5 + border.width * 2

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
    }
}
