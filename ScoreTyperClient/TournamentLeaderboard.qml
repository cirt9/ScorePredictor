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
                color: mainWindow.colorB
                radius: 5
                opacity: 0.4
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

        SearchIndicator {
            text: qsTr("Loading")
            color: mainWindow.fontColor
            opacityOnRunning: 0.75
            fontBold: true
            fontSize: 16
            running: loadingState && participantsList.count === 0 ? true : false
            anchors.centerIn: parent
        }
    }

    ListModel {
        id: participantsList

        onCountChanged: {
            if(root.loadingState && count > 0)
                stopLoading()
        }

        /*ListElement {
            position: 1
            nickname: "IAmTheBest"
            exactScore: 4
            predictedResult: 15
            points: 23
        }

        ListElement {
            position: 2
            nickname: "SecondToNone"
            exactScore: 3
            predictedResult: 14
            points: 20
        }

        ListElement {
            position: 3
            nickname: "ThirdBird"
            exactScore: 1
            predictedResult: 17
            points: 19
        }*/
    }

    Timer {
        id: timeoutTimer
        interval: mainWindow.serverResponseWaitingTimeMsec

        onTriggered: loadingState = false
    }

    function addParticipant(participant)
    {
        participant.position = 1
        participantsList.append(participant)
    }

    function startLoading()
    {
        loadingState = true
        timeoutTimer.restart()
    }

    function stopLoading()
    {
        loadingState = false
        timeoutTimer.stop()
    }

    function clear()
    {
        participantsList.clear()
    }
}
