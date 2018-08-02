import QtQuick 2.9

Rectangle {
    id: root
    width: container.width + addButton.width + substractButton.width * 1.5 +  border.width * 2
    height: container.height + border.width * 2

    readonly property string time: hoursInput.text + colon.text + minutesInput.text
    readonly property string fullTime: hoursInput.text + colon.text + minutesInput.text + ":" + "00"
    property string minimumTime
    readonly property bool minimumTimeSet: determineMinimumTimeSetState()
    property int fontSize: 12
    property color fontColor: "white"
    property color selectedTextColor: "black"
    property color selectionColor: "white"
    property bool selectByMouse: true
    property url addIcon
    property url substractIcon
    property color hoveredButtonColor: "black"

    onMinimumTimeSetChanged: adjustTimeForMinimumTime()

    Item {
        id: container
        width: textMetrics.width * 3 + colonMetrics.width
        height: textMetrics.height * 1.3
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: root.border.width + 3

        property var focusedInput: hoursInput

        TextInput {
            id: hoursInput
            color: fontColor
            width: textMetrics.width * 1.25
            height: textMetrics.height
            inputMask: "00"
            text: minimumTimeSet ? minimumTime.slice(0, 2) : "12"
            font.pointSize: fontSize
            activeFocusOnTab: true
            horizontalAlignment: Text.AlignHCenter
            selectByMouse: root.selectByMouse
            selectedTextColor: root.selectedTextColor
            selectionColor: root.selectionColor
            anchors.right: colon.left
            anchors.verticalCenter: parent.verticalCenter

            onEditingFinished: {
                text = resetText(text)

                if(minimumTimeSet)
                    validateMinimumTimeWhileModifyingHoursInput()
            }
            onTextChanged: text = validateText(text, "23")
            onFocusChanged: {
                if(focus)
                    container.focusedInput = hoursInput
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                cursorShape: Qt.IBeamCursor
            }
        }

        Text {
            id: colon
            color: fontColor
            text: ":"
            font.pointSize: fontSize
            anchors.centerIn: parent
        }

        TextInput {
            id: minutesInput
            color: fontColor
            width: textMetrics.width * 1.25
            height: textMetrics.height
            inputMask: "00"
            text: minimumTimeSet ? minimumTime.slice(3, 5) : "00"
            font.pointSize: fontSize
            activeFocusOnTab: true
            selectByMouse: root.selectByMouse
            selectedTextColor: root.selectedTextColor
            selectionColor: root.selectionColor
            horizontalAlignment: Text.AlignHCenter
            anchors.left: colon.right
            anchors.verticalCenter: parent.verticalCenter

            onEditingFinished: {
                text = resetText(text)

                if(minimumTimeSet)
                    validateMinimumTimeWhileModifyingMinutesInput()
            }
            onTextChanged: text = validateText(text, "59")
            onFocusChanged: {
                if(focus)
                    container.focusedInput = minutesInput
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                cursorShape: Qt.IBeamCursor
            }
        }

        TextMetrics {
            id: textMetrics
            font.pointSize: fontSize
            font.family: hoursInput.font
            text: "00"
        }

        TextMetrics {
            id: colonMetrics
            font.pointSize: fontSize
            font.family: colon.font
            text: colon.text
        }
    }

    PressIconButton {
        id: addButton
        color: hoveredButtonColor
        height: parent.height
        width: height
        radius: parent.radius
        iconSource: addIcon
        anchors.right: substractButton.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 3
        anchors.topMargin: radius === 0 ? root.border.width : root.border.width + 3
        anchors.bottomMargin: radius === 0 ? root.border.width : root.border.width + 3

        onPressedChanged: {
            if(buttonPressed)
            {
                container.focusedInput.focus = false
                addTime()
                addButtonTimer.running = true

                if(minimumTimeSet)
                    validateMinimumTimeWhileAdding()
            }
            else
                addButtonTimer.running = false
        }

        IntervalChangingTimer {
            id: addButtonTimer
            onTriggered: {
                addTime()

                if(minimumTimeSet)
                    validateMinimumTimeWhileAdding()
            }
            startingIntervalValue: 300
            targetIntervalValue: 50
            ticksToReachTargetValue: 7
        }
    }

    PressIconButton {
        id: substractButton
        color: hoveredButtonColor
        height: parent.height
        width: height
        radius: parent.radius
        iconSource: substractIcon
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: radius === 0 ? root.border.width : root.border.width + 3

        onPressedChanged: {
            if(buttonPressed)
            {
                container.focusedInput.focus = false
                substractTime()
                substractButtonTimer.running = true

                if(minimumTimeSet)
                    validateMinimumTimeWhileSubstracting()
            }
            else
                substractButtonTimer.running = false
        }

        IntervalChangingTimer {
            id: substractButtonTimer
            onTriggered: {
                substractTime()

                if(minimumTimeSet)
                    validateMinimumTimeWhileSubstracting()
            }
            startingIntervalValue: 300
            targetIntervalValue: 50
            ticksToReachTargetValue: 7
        }
    }

    function resetText(text)
    {
        if(text.length === 0)
            text = "00"
        else if(text.length === 1)
            text = "0" + text.charAt(0)

        return text
    }

    function validateText(text, validator)
    {
        if(text.charAt(0) > parseInt(validator.charAt(0)))
        {
            if(text.charAt(1) !== "")
            {
                text = validator.charAt(0) + text.charAt(1)
            }
        }
        if(text.charAt(0) + text.charAt(1) > parseInt(validator))
            text = validator

        return text
    }

    function addTime()
    {
        var oldTime = parseInt(container.focusedInput.text)
        var newTime = oldTime + 1

        if(container.focusedInput === hoursInput)
        {
            if(newTime === 24)
                newTime = 0
        }
        else if(container.focusedInput === minutesInput)
        {
            if(newTime === 60)
            {
                newTime = 0
                var newHour = parseInt(hoursInput.text) + 1

                if(newHour === 24)
                    hoursInput.text = formatTime(0)
                else
                    hoursInput.text = formatTime(newHour)
            }
        }
        container.focusedInput.text = formatTime(newTime)
    }

    function substractTime()
    {
        var oldTime = parseInt(container.focusedInput.text)
        var newTime = oldTime - 1

        if(container.focusedInput === hoursInput)
        {
            if(newTime === -1)
                newTime = 23
        }
        else if(container.focusedInput === minutesInput)
        {
            if(newTime === -1)
            {
                newTime = 59
                var newHour = parseInt(hoursInput.text) - 1

                if(newHour === -1)
                    hoursInput.text = 23
                else
                    hoursInput.text = formatTime(newHour)
            }
        }
        container.focusedInput.text = formatTime(newTime)
    }

    function formatTime(oldTime)
    {
        if(oldTime > 9)
            return oldTime
        else
            return "0" + oldTime
    }

    function validateMinimumTimeWhileModifyingHoursInput()
    {
        var minHours = minimumTime.slice(0, 2)
        var minMinutes = minimumTime.slice(3, 5)

        if(hoursInput.text < minHours)
            hoursInput.text = minHours

        if(hoursInput.text === minHours)
        {
            if(minutesInput.text < minMinutes)
                minutesInput.text = minMinutes
        }
    }

    function validateMinimumTimeWhileModifyingMinutesInput()
    {
        var minHours = minimumTime.slice(0, 2)
        var minMinutes = minimumTime.slice(3, 5)

        if(hoursInput.text === minHours)
        {
            if(minutesInput.text < minMinutes)
                minutesInput.text = minMinutes
        }
    }

    function validateMinimumTimeWhileAdding()
    {
        var minHours = minimumTime.slice(0, 2)
        var minMinutes = minimumTime.slice(3, 5)

        if(container.focusedInput === hoursInput)
        {
            if(hoursInput.text === "00")
                hoursInput.text = minHours

            if(hoursInput.text === minHours)
            {
                if(minutesInput.text < minMinutes)
                    minutesInput.text = minMinutes
            }
        }
        else if(container.focusedInput === minutesInput)
        {
            if(hoursInput.text === "00")
            {
                hoursInput.text = minHours

                if(minutesInput.text < minMinutes)
                    minutesInput.text = minMinutes
            }
        }
    }

    function validateMinimumTimeWhileSubstracting()
    {
        var minHours = minimumTime.slice(0, 2)
        var minMinutes = minimumTime.slice(3, 5)

        if(container.focusedInput === hoursInput)
        {
            if(hoursInput.text < minHours)
                hoursInput.text = "23"

            if(hoursInput.text === minHours)
            {
                if(minutesInput.text < minMinutes)
                    minutesInput.text = minMinutes
            }
        }
        else if(container.focusedInput === minutesInput)
        {
            if(hoursInput.text === minHours)
            {
                if(minutesInput.text < minMinutes)
                {
                    hoursInput.text = "23"
                    minutesInput.text = "59"
                }
            }
        }
    }

    function determineMinimumTimeSetState()
    {
        var minTimeSet = false

        if(minimumTime.length === 5)
        {
            var minTimeHours = parseInt(minimumTime.slice(0, 2))
            var minTimeMinutes = parseInt(minimumTime.slice(3, 5))

            var colonOccurs = minimumTime.charAt(2) === ":" ? true : false
            var hoursValid = minTimeHours >= 0 && minTimeHours <= 23 ? true : false
            var minutesValid = minTimeMinutes >= 0 && minTimeMinutes <= 59 ? true : false

            if(hoursValid && colonOccurs && minutesValid)
                minTimeSet = true
        }

        return minTimeSet
    }

    function adjustTimeForMinimumTime()
    {
        var timeNumber = parseInt(time.slice(0, 2) + time.slice(3, 5))
        var minimumTimeNumber = parseInt(minimumTime.slice(0, 2) + minimumTime.slice(3, 5))

        if(timeNumber < minimumTimeNumber)
        {
            hoursInput.text = minimumTime.slice(0, 2)
            minutesInput.text = minimumTime.slice(3, 5)
        }
    }

    function reset()
    {
        defocus()

        if(minimumTimeSet)
        {
            hoursInput.text = minimumTime.slice(0, 2)
            minutesInput.text = minimumTime.slice(3, 5)
        }
        else
        {
            hoursInput.text = "12"
            minutesInput.text = "00"
        }
    }

    function defocus()
    {
        hoursInput.focus = false
        minutesInput.focus = false
    }
}
