import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../components"

Page {
    id: tournamentsSearchPage

    property bool searchingState: false
    property int itemsForPage: 23
    property int pagesInAdvance: 3

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
            searchingEnabled: searchingState ? false : true
            clearingEnabled: searchingState ? false : true
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 30

            onSearchClicked: {
                clear()
                pullTournamentsList(pagesInAdvance, searchWidget.lastSearchedPhrase)
            }
            onClearClicked: {
                if(lastSearchedPhrase.length > 0)
                {
                    clear()
                    pullTournamentsList(pagesInAdvance)
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
                            elide: Text.ElideRight

                            Layout.preferredWidth: parent.width * 0.3
                            Layout.fillHeight: true
                        }

                        Text {
                            id: hostNameData
                            text: hostName
                            color: mainWindow.fontColor
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight

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
                    color: mainWindow.fontColor
                    opacity: 0.5
                    font.bold: true
                    font.pointSize: 40
                    visible: !searchingState && visibleTournamentsList.count === 0 ? true : false
                    anchors.centerIn: parent
                }

                SearchIndicator {
                    text: qsTr("Searching")
                    color: mainWindow.fontColor
                    opacityOnRunning: 0.5
                    fontBold: true
                    fontSize: 40
                    running: searchingState && visibleTournamentsList.count === 0 ? true : false
                    anchors.centerIn: parent
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
            textColor: mainWindow.fontColor
            fontSize: 25
            radius: 5
            enabled: visibleTournamentsList.count === 0 ? false : true
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 10

            onClicked: {
                navigationPage.hideResponse()
                var chosenTournament = visibleTournamentsList.get(tournamentsView.currentIndex)

                if(chosenTournament.passwordRequired === "Yes")
                    passwordRequiredPopup.open()
                else
                {
                    backend.joinTournament(currentUser.username, chosenTournament.tournamentName, chosenTournament.hostName)
                    navigationPage.enabled = false
                    mainWindow.startBusyIndicator()
                    busyTimer.restart()
                }
            }
        }

        IconButton {
            id: previousButton
            height: joinButton.height + 3
            width: height
            iconSource: "qrc://assets/icons/icons/icons8_Sort_Left.png"
            marginsOnPressed: 5
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
            marginsOnPressed: 5
            enabled: nextTournamentsList.count === 0 ? false : true
            anchors.left: joinButton.right
            anchors.verticalCenter: joinButton.verticalCenter

            onClicked: {
                loadNextPage()

                if(nextTournamentsList.count < itemsForPage)
                    pullChunkOfTournamentsList(pagesInAdvance, searchWidget.lastSearchedPhrase)
            }
        }
    }

    Item {
        id: passwordRequiredPopupArea
        width: passwordRequiredPopup.width
        height: passwordRequiredPopup.height
        anchors.centerIn: parent

        PopupBox {
            id: passwordRequiredPopup
            width: 450
            height: 300

            Text {
                id: passwordRequiredTitle
                text: qsTr("Password Required")
                color: mainWindow.fontColor
                font.bold: true
                font.pointSize: 25
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 15
            }

            TextLineField {
                id: passwordRequiredInput
                placeholderText: qsTr("Password")
                width: 300
                fontSize: 16
                selectByMouse: true
                maximumLength: 30
                textColor: mainWindow.fontColor
                selectedTextColor: mainWindow.fontColor
                selectionColor: mainWindow.accentColor
                underlineColorOnFocus: mainWindow.accentColor
                anchors.centerIn: parent
            }

            Button {
                id: passwordRequiredButton
                text: qsTr("Join")
                width: 300
                enabled: passwordRequiredInput.text.length === 0 ? false : true
                font.pointSize: 20
                font.bold: true
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: passwordRequiredInput.horizontalCenter

                onClicked: {
                    var chosenTournament = visibleTournamentsList.get(tournamentsView.currentIndex)

                    backend.joinTournament(currentUser.username, chosenTournament.tournamentName,
                                           chosenTournament.hostName, passwordRequiredInput.text)
                    navigationPage.enabled = false
                    passwordRequiredInput.text = ""
                    passwordRequiredPopup.close()
                    mainWindow.startBusyIndicator()
                    busyTimer.restart()
                }
            }
        }
    }

    Connections {
        target: packetProcessor

        onTournamentsListArrived: {
            searchingState = false
            searchingTimeoutTimer.stop()
        }

        onTournamentsListItemArrived: {
            var item = {}
            item.tournamentName = tournamentData[0]
            item.hostName = tournamentData[1]
            item.entriesEndTime = tournamentData[2]
            item.typers = tournamentData[3]
            item.passwordRequired = tournamentData[4]

            if(visibleTournamentsList.count < itemsForPage)
                visibleTournamentsList.append(item)
            else
                nextTournamentsList.append(item)
        }

        onTournamentJoiningReply: {
            busyTimer.stop()
            navigationPage.enabled = true
            mainWindow.stopBusyIndicator()

            if(replyState)
            {
                var chosenTournament = visibleTournamentsList.get(tournamentsView.currentIndex)
                currentTournament.name = chosenTournament.tournamentName
                currentTournament.hostName = chosenTournament.hostName

                navigationPage.pushTournament("qrc:/pages/TournamentNavigationPage.qml")
                navigationPage.changePage(1)
                refresh();
                userProfilePage.refreshOngoingTournamentsList()
            }
            else
                navigationPage.showDeniedResponse(message)
        }
    }

    Timer {
        id: searchingTimeoutTimer
        interval: mainWindow.serverResponseWaitingTimeMsec

        onTriggered: searchingState = false
    }

    Timer {
        id: busyTimer
        interval: mainWindow.serverResponseWaitingTimeMsec

        onTriggered: {
            navigationPage.enabled = true
            mainWindow.stopBusyIndicator()
            backend.disconnectFromServer()
            mainWindow.showErrorPopup(qsTr("Connection lost. Try again later."))
        }
    }

    Component.onCompleted: pullTournamentsList(pagesInAdvance)

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
        var startTransferingFrom = previousTournamentsList.count - itemsForPage

        for(var i=0; i<itemsForPage; i++)
            visibleTournamentsList.append(previousTournamentsList.get(startTransferingFrom + i))

        previousTournamentsList.remove(startTransferingFrom, itemsForPage)
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
        var itemsToTransfer = itemsForPage <= nextTournamentsList.count ? itemsForPage : nextTournamentsList.count

        for(var i=0; i<itemsToTransfer; i++)
            visibleTournamentsList.append(nextTournamentsList.get(i))

        nextTournamentsList.remove(0, itemsToTransfer)
    }

    function pullTournamentsList(numberOfPages, tournamentPhrase)
    {
        if(tournamentPhrase === undefined)
            tournamentPhrase = ""

        if(!searchingState)
        {
            var itemsToPull = itemsForPage * numberOfPages
            backend.pullTournaments(currentUser.username, itemsToPull, tournamentPhrase)
            searchingState = true
            searchingTimeoutTimer.restart()
        }
    }

    function pullChunkOfTournamentsList(numberOfPages, tournamentPhrase)
    {
        if(tournamentPhrase === undefined)
            tournamentPhrase = ""

        if(!searchingState)
        {
            var itemsToPull = itemsForPage * numberOfPages
            var startFromDateString = nextTournamentsList.count === 0 ?
                        visibleTournamentsList.get(visibleTournamentsList.count-1).entriesEndTime :
                        nextTournamentsList.get(nextTournamentsList.count-1).entriesEndTime
            var startFromDate = Date.fromLocaleString(Qt.locale(), startFromDateString, "dd.MM.yyyy hh:mm")

            backend.pullTournaments(currentUser.username, itemsToPull, tournamentPhrase, startFromDate)
            searchingState = true
            searchingTimeoutTimer.restart()
        }
    }

    function clear()
    {
        previousTournamentsList.clear()
        visibleTournamentsList.clear()
        nextTournamentsList.clear()
    }

    function refresh()
    {
        if(!searchingState)
        {
            clear()
            pullTournamentsList(pagesInAdvance, searchWidget.lastSearchedPhrase)
        }
    }
}
