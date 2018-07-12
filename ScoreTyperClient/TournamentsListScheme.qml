import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    id: root
    clip: true

    property alias notLoadedResponseText: notLoadedResponse.text
    property bool loadingState: false
    signal itemDoubleClicked(var tournamentName, var hostName)

    ListView {
        id: tournamentsListView
        model: tournamentsList
        spacing: 2
        headerPositioning: ListView.OverlayHeader
        anchors.fill: parent

        highlight: Rectangle {
            color: mainWindow.colorB
            radius: 5
            opacity: 0.8
        }

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
                    id: headerLayout
                    anchors.fill: parent
                    anchors.margins: 2
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5

                    Text {
                        id: tournamentNameHeader
                        text: qsTr("Tournament Name")
                        color: mainWindow.fontColor
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter

                        Layout.fillHeight: true
                        Layout.preferredWidth: headerLayout.width / 2
                    }

                    Text {
                        id: hostNameHeader
                        text: qsTr("Host Name")
                        color: mainWindow.fontColor
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter

                        Layout.fillHeight: true
                        Layout.preferredWidth: headerLayout.width / 2
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
                id: componentLayout
                anchors.fill: parent
                anchors.margins: 2
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Text {
                    id: tournamentNameData
                    text: tournamentName
                    color: mainWindow.fontColor
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight

                    Layout.fillHeight: true
                    Layout.preferredWidth: componentLayout.width / 2
                }

                Text {
                    id: hostNameData
                    text: hostName
                    color: mainWindow.fontColor
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight

                    Layout.fillHeight: true
                    Layout.preferredWidth: componentLayout.width / 2
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: tournamentsListView.currentIndex = index
                onDoubleClicked: {
                    var chosenTournament = tournamentsList.get(tournamentsListView.currentIndex)
                    root.itemDoubleClicked(chosenTournament.tournamentName, chosenTournament.hostName)
                }
            }
        }

        Text {
            id: notLoadedResponse
            color: mainWindow.fontColor
            opacity: 0.75
            font.bold: true
            font.pointSize: 16
            visible: !loadingState && tournamentsList.count === 0 ? true : false
            anchors.centerIn: parent
        }

        SearchIndicator {
            text: qsTr("Loading")
            color: mainWindow.fontColor
            opacityOnRunning: 0.75
            fontBold: true
            fontSize: 16
            running: loadingState && tournamentsList.count === 0 ? true : false
            anchors.centerIn: parent
        }
    }

    ListModel {
        id: tournamentsList
    }

    Timer {
        id: timeoutTimer
        interval: mainWindow.serverResponseWaitingTimeMsec

        onTriggered: loadingState = false
    }

    function addItem(tournamentName, hostName)
    {
        var item = {}
        item.tournamentName = tournamentName
        item.hostName = hostName
        tournamentsList.append(item)
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
        tournamentsList.clear()
    }
}
