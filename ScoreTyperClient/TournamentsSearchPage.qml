import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../components"

Page {
    id: tournamentsSearchPage

    Rectangle {
        id: tournamentsSearchArea
        color: mainWindow.colorA
        radius: 5
        anchors.fill: parent
        anchors.margins: 15

        SearchWidget {
            id: searchWidget
            width: parent.width * 0.3
            height: 30
            placeholderText: "Search Tournament"
            color: mainWindow.backgroundColor
            border.color: "black"
            textColor: mainWindow.fontColor
            radius: 10
            maximumLength: 30
            selectionColor: mainWindow.accentColor
            selectByMouse: true
            searchIcon: "qrc://assets/icons/icons/icons8_Search.png"
            clearIcon: "qrc://assets/icons/icons/icons8_Delete.png"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 30

            onSearchClicked: {
                clear()
                backend.pullTournaments(currentUser.username, tournamentsView.itemsForPage * 3,
                                        searchWidget.lastSearchedPhrase)
            }
            onClearClicked: {
                if(lastSearchedPhrase.length > 0)
                {
                    clear()
                    backend.pullTournaments(currentUser.username, tournamentsView.itemsForPage * 3, "")
                }
            }
        }

        Item {
            clip: true
            width: parent.width * 0.85
            anchors.top: searchWidget.bottom
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 30
            anchors.bottomMargin: 70

            Rectangle {
                id: tournamentsViewBackground
                color: mainWindow.backgroundColor
                radius: 5
                opacity: 0.35
                anchors.fill: parent
            }

            ListView {
                id: tournamentsView
                model: visibleTournamentsList
                spacing: 2
                headerPositioning: ListView.PullBackHeader
                highlightMoveDuration: 250
                anchors.fill: parent
                anchors.margins: 5
                property int itemsForPage: 23

                header: Item {
                    width: parent.width
                    height: 45

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

                            Text {
                                id: tournamentNameHeader
                                text: qsTr("Tournament Name")
                                color: mainWindow.fontColor
                                font.pointSize: 12
                                verticalAlignment: Text.AlignVCenter

                                Layout.preferredWidth: parent.width * 0.3
                                Layout.fillHeight: true
                            }

                            Text {
                                id: hostNameHeader
                                text: qsTr("Host Name")
                                color: mainWindow.fontColor
                                font.pointSize: 12
                                verticalAlignment: Text.AlignVCenter

                                Layout.preferredWidth: parent.width * 0.3
                                Layout.fillHeight: true
                            }

                            Text {
                                id: entriesEndTimeHeader
                                text: qsTr("Entries End Time")
                                color: mainWindow.fontColor
                                font.pointSize: 12
                                verticalAlignment: Text.AlignVCenter

                                Layout.preferredWidth: parent.width * 0.15
                                Layout.fillHeight: true
                            }

                            Text {
                                id: typersHeader
                                text: qsTr("Typers")
                                color: mainWindow.fontColor
                                font.pointSize: 12
                                verticalAlignment: Text.AlignVCenter

                                Layout.preferredWidth: parent.width * 0.15
                                Layout.fillHeight: true
                            }

                            Text {
                                id: passwordHeader
                                text: qsTr("Password")
                                color: mainWindow.fontColor
                                font.pointSize: 12
                                verticalAlignment: Text.AlignVCenter

                                Layout.preferredWidth: parent.width * 0.1
                                Layout.fillHeight: true
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
                            id: tournamentNameData
                            text: tournamentName
                            color: mainWindow.fontColor
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter

                            Layout.preferredWidth: parent.width * 0.3
                            Layout.fillHeight: true
                        }

                        Text {
                            id: hostNameData
                            text: hostName
                            color: mainWindow.fontColor
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter

                            Layout.preferredWidth: parent.width * 0.3
                            Layout.fillHeight: true
                        }

                        Text {
                            id: entriesEndTimeData
                            text: entriesEndTime
                            color: mainWindow.fontColor
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter

                            Layout.preferredWidth: parent.width * 0.15
                            Layout.fillHeight: true
                        }

                        Text {
                            id: typersData
                            text: typers
                            color: mainWindow.fontColor
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter

                            Layout.preferredWidth: parent.width * 0.15
                            Layout.fillHeight: true
                        }

                        Text {
                            id: passwordRequiredData
                            text: passwordRequired
                            color: mainWindow.fontColor
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter

                            Layout.preferredWidth: parent.width * 0.1
                            Layout.fillHeight: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: tournamentsView.currentIndex = index
                    }
                }

                highlight: Rectangle {
                    color: mainWindow.colorB
                    radius: 5
                    opacity: 0.8
                }

                Text {
                    text: qsTr("Tournaments not found")
                    color: mainWindow.backgroundColor
                    opacity: 0.5
                    font.bold: true
                    font.pointSize: 40
                    anchors.centerIn: parent
                    visible: visibleTournamentsList.count === 0 ? true : false
                }
            }
        }

        ListModel {
            id: previousTournamentsList
        }

        ListModel {
            id: visibleTournamentsList
        }

        ListModel {
            id: nextTournamentsList
        }

        DefaultButton {
            id: joinButton
            text: qsTr("Join")
            width: 200
            color: mainWindow.backgroundColor
            fontColor: mainWindow.fontColor
            fontSize: 25
            radius: 5
            enabled: visibleTournamentsList.count === 0 ? false : true
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 10

            onClicked: {
                var chosenTournament = visibleTournamentsList.get(tournamentsView.currentIndex)
                console.log(chosenTournament.tournamentName)
            }
        }

        IconButton {
            id: previousButton
            height: joinButton.height + 3
            width: height
            iconSource: "qrc://assets/icons/icons/icons8_Sort_Left.png"
            enabled: previousTournamentsList.count === 0 ? false : true
            anchors.right: joinButton.left
            anchors.verticalCenter: joinButton.verticalCenter

            onClicked: loadPreviousPage()
        }

        IconButton {
            id: nextButton
            height: joinButton.height + 3
            width: height
            iconSource: "qrc://assets/icons/icons/icons8_Sort_Right.png"
            enabled: nextTournamentsList.count === 0 ? false : true
            anchors.left: joinButton.right
            anchors.verticalCenter: joinButton.verticalCenter

            onClicked: {
                loadNextPage()

                if(nextTournamentsList.count < tournamentsView.itemsForPage)
                    pullChunkOfTournamentsList(3)
            }
        }
    }

    Connections {
        target: packetProcessor

        onTournamentsListItemArrived: {
            var item = {}
            item.tournamentName = tournamentData[0]
            item.hostName = tournamentData[1]
            item.entriesEndTime = tournamentData[2]
            item.typers = tournamentData[3]
            item.passwordRequired = tournamentData[4]

            if(visibleTournamentsList.count < tournamentsView.itemsForPage)
                visibleTournamentsList.append(item)
            else
                nextTournamentsList.append(item)
        }
    }
    Component.onCompleted: backend.pullTournaments(currentUser.username, tournamentsView.itemsForPage * 3, "")

    function loadPreviousPage()
    {
        transferItemsFromVisibleToNext()
        transferItemsFromPreviousToVisible()
    }

    function transferItemsFromVisibleToNext()
    {
        for(var i=0; i<visibleTournamentsList.count; i++)
            nextTournamentsList.insert(i, visibleTournamentsList.get(i))

        visibleTournamentsList.clear()
    }

    function transferItemsFromPreviousToVisible()
    {
        var startTransferingFrom = previousTournamentsList.count - tournamentsView.itemsForPage

        for(var i=0; i<tournamentsView.itemsForPage; i++)
            visibleTournamentsList.append(previousTournamentsList.get(startTransferingFrom + i))

        previousTournamentsList.remove(startTransferingFrom, tournamentsView.itemsForPage)
    }

    function loadNextPage()
    {
        transferItemsFromVisibleToPrevious()
        transferItemsFromNextToVisible()
    }

    function transferItemsFromVisibleToPrevious()
    {
        for(var i=0; i<visibleTournamentsList.count; i++)
            previousTournamentsList.append(visibleTournamentsList.get(i))

        visibleTournamentsList.clear()
    }

    function transferItemsFromNextToVisible()
    {
        var itemsToTransfer = tournamentsView.itemsForPage <= nextTournamentsList.count ?
                                 tournamentsView.itemsForPage : nextTournamentsList.count

        for(var i=0; i<itemsToTransfer; i++)
            visibleTournamentsList.append(nextTournamentsList.get(i))

        nextTournamentsList.remove(0, itemsToTransfer)
    }

    function pullChunkOfTournamentsList(numberOfPages)
    {
        var itemsToPull = tournamentsView.itemsForPage * numberOfPages
        var startFromDateString = nextTournamentsList.count === 0 ?
                    visibleTournamentsList.get(visibleTournamentsList.count-1).entriesEndTime :
                    nextTournamentsList.get(nextTournamentsList.count-1).entriesEndTime
        var startFromDate = Date.fromLocaleString(Qt.locale(), startFromDateString, "dd.MM.yyyy hh:mm")

        backend.pullTournaments(currentUser.username, tournamentsView.itemsForPage * 3,
                                searchWidget.lastSearchedPhrase, startFromDate)
    }

    function clear()
    {
        previousTournamentsList.clear()
        visibleTournamentsList.clear()
        nextTournamentsList.clear()
    }

    function refresh()
    {
        clear()
        backend.pullTournaments(currentUser.username, tournamentsView.itemsForPage * 3, searchWidget.lastSearchedPhrase)
    }
}
