import QtQuick 2.9

Timer {
    id: root
    interval: startingIntervalValue
    repeat: true
    running: false

    property int startingIntervalValue: 1000
    property int targetIntervalValue: 200
    property int ticksToReachTargetValue: 5
    readonly property int valueDifferenceForEveryTick: (startingIntervalValue - targetIntervalValue) / ticksToReachTargetValue

    onRunningChanged: {
        if(!running)
            interval = startingIntervalValue
    }

    onTriggered: {
        interval = interval - valueDifferenceForEveryTick

        if(startingIntervalValue >= targetIntervalValue)
        {
            if(interval <= targetIntervalValue)
                interval = targetIntervalValue
        }
        else
        {
            if(interval >= targetIntervalValue)
                interval = targetIntervalValue
        }
    }
}
