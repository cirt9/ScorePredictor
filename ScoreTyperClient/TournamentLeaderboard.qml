import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../components"

Item {
    id: root
    clip: true

    property bool loadingState: false

    ListView {
        id: leaderboardsView
        model: participantsList
        spacing: 2
        headerPositioning: ListView.OverlayHeader
        highlightMoveDuration: 250
        anchors.fill: parent

        header: Item {
            width: parent.width
            height: 45
            z: 2

            Rectangle {
                id: headerComponent
                width: parent.width
                height: 40
                color: mainWindow.colorB
                radius: 5
                anchors.top: parent.top
                anchors.left: parent.left

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 2
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5

                    Item {
                        id: positionHeader

                        Layout.preferredWidth: 40
                        Layout.fillHeight: true
                    }

                    Text {
                        id: nameHeader
                        text: qsTr("Name")
                        color: mainWindow.fontColor
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }

                    Text {
                        id: exactScoreHeader
                        text: qsTr("Exact Score")
                        color: mainWindow.fontColor
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter

                        Layout.fillHeight: true
                        Layout.preferredWidth: 100
                    }

                    Text {
                        id: predictedResultHeader
                        text: qsTr("Predicted Result")
                        color: mainWindow.fontColor
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter

                        Layout.fillHeight: true
                        Layout.preferredWidth: 140
                    }

                    Text {
                        id: pointsHeader
                        text: qsTr("Points")
                        color: mainWindow.fontColor
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter

                        Layout.fillHeight: true
                        Layout.preferredWidth: 70
                    }
                }
            }
        }

        delegate: Item {
            id: delegateComponent
            width: parent.width
            height: 30

            Rectangle {
                id: delegateBackground
                property color goldColor: "#ffd700"
                property color silverColor: "#C0C0C0"
                property color bronzeColor: "#cd7f32"

                color: {
                    if(position === 1)
                        return goldColor

                    if(position === 2)
                        return silverColor

                    if(position === 3)
                        return bronzeColor

                    return mainWindow.colorB
                }

                radius: 5
                opacity: 0.3

                anchors.fill: parent
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 2
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Text {
                    id: positionData
                    text: position
                    color: mainWindow.fontColor
                    font.pointSize: 10
                    font.bold: nickname === currentUser.username ? true : false
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight

                    Layout.preferredWidth: 40
                    Layout.fillHeight: true
                }

                Text {
                    id: nameData
                    text: nickname
                    color: mainWindow.fontColor
                    font.pointSize: 10
                    font.bold: nickname === currentUser.username ? true : false
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                Text {
                    id: exactScoreData
                    text: exactScore
                    color: mainWindow.fontColor
                    font.pointSize: 10
                    font.bold: nickname === currentUser.username ? true : false
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight

                    Layout.fillHeight: true
                    Layout.preferredWidth: 100
                }

                Text {
                    id: predictedResultData
                    text: predictedResult
                    color: mainWindow.fontColor
                    font.pointSize: 10
                    font.bold: nickname === currentUser.username ? true : false
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight

                    Layout.fillHeight: true
                    Layout.preferredWidth: 140
                }

                Text {
                    id: pointsData
                    text: points
                    color: mainWindow.fontColor
                    font.pointSize: 10
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight

                    Layout.fillHeight: true
                    Layout.preferredWidth: 70
                }
            }
        }

        TextEdit {
            id: infoText
            text: qsTr("Couldn't load leaderboard")
            font.pointSize: 22
            font.bold: true
            color: mainWindow.fontColor
            readOnly: true
            wrapMode: TextEdit.WordWrap
            visible: !loadingState && participantsList.count === 0 ? true : false
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 10
        }

        LoadingIndicator {
            text: qsTr("Loading")
            color: mainWindow.fontColor
            opacityOnRunning: 0.75
            fontBold: true
            fontSize: 22
            running: loadingState && participantsList.count === 0 ? true : false
            anchors.centerIn: parent
        }
    }

    ListModel {
        id: participantsList

        onCountChanged: {
            if(root.loadingState && count > 0)
                hideLoadingText()
        }
    }

    Timer {
        id: timeoutTimer
        interval: mainWindow.serverResponseWaitingTimeMsec

        onTriggered: loadingState = false
    }

    function addParticipant(participant)
    {
        if(participantsList.count === 0)
            participant.position = 1
        else
        {
            var lastParticipant = participantsList.get(participantsList.count - 1)

            if(equalParticipants(participant, lastParticipant))
                participant.position = lastParticipant.position
            else
                participant.position = participantsList.count + 1
        }

        participantsList.append(participant)
    }

    function equalParticipants(participant1, participant2)
    {
        if(participant1.points !== participant2.points)
            return false

        if(participant1.exactScore !== participant2.exactScore)
            return false

        if(participant1.predictedResult !== participant2.predictedResult)
            return false

        return true
    }

    function showLoadingText()
    {
        loadingState = true
        timeoutTimer.restart()
    }

    function hideLoadingText()
    {
        loadingState = false
        timeoutTimer.stop()
    }

    function clear()
    {
        participantsList.clear()
    }
}
