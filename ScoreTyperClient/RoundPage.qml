import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../reusableWidgets"
import "../components"

Page {
    id: roundPage

    RowLayout {
        id: pageLayout
        anchors.fill: parent
        spacing: 10

        Rectangle {
            id: matchesArea
            color: mainWindow.colorA
            radius: 5

            Layout.fillHeight: true
            Layout.preferredWidth: (roundPage.width * 0.6) - 10

            ListOfMatches {
                id: listOfMatches
                errorText: qsTr("Couldn't load matches list")
                matchesNotFoundText: qsTr("There are no matches yet")
                anchors.fill: parent
                anchors.margins: 5

                onCreatingNewMatch: createNewMatchPopup.open()
                onRemovingMatch: {
                    var match = Qt.createQmlObject('import QtQuick 2.0;import DataStorage 1.0; Match {}', roundPage);
                    match.firstCompetitor = firstCompetitor
                    match.secondCompetitor = secondCompetitor
                    match.tournamentName = currentTournament.name
                    match.tournamentHostName = currentTournament.hostName
                    match.roundName = tournamentNavigationPage.currentPage

                    backend.deleteMatch(match)
                    match.destroy()

                    startLoading()
                }

                onUpdatingMatchScore: {
                    var match = Qt.createQmlObject('import QtQuick 2.0;import DataStorage 1.0; Match {}', roundPage);
                    match.firstCompetitor = firstCompetitor
                    match.secondCompetitor = secondCompetitor
                    match.firstCompetitorScore = firstScore
                    match.secondCompetitorScore = secondScore
                    match.tournamentName = currentTournament.name
                    match.tournamentHostName = currentTournament.hostName
                    match.roundName = tournamentNavigationPage.currentPage

                    backend.updateMatchScore(match)
                    match.destroy()

                    startLoading()
                }
            }
        }

        Rectangle {
            id: roundLeaderboardArea
            color: mainWindow.colorA
            radius: 5

            Layout.fillHeight: true
            Layout.preferredWidth: roundPage.width * 0.4

            TournamentLeaderboard {
                id: roundLeaderboard
                anchors.fill: parent
                anchors.margins: 5
            }
        }
    }

    Item {
        width: createNewMatchPopup.width
        height: createNewMatchPopup.height
        y: parent.height / 2 - height / 2 - tournamentNavigationPage.headerHeight
        anchors.horizontalCenter: parent.horizontalCenter

        PopupBox {
            id: createNewMatchPopup
            width: 500
            height: 600

            Text {
                id: newMatchPopupTitle
                text: qsTr("Creating New Match")
                color: mainWindow.fontColor
                font.bold: true
                font.pointSize: 25
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 15
            }

            Column {
                spacing: 5
                anchors.top: newMatchPopupTitle.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 30

                InputWithBorder {
                    id: firstCompetitorInput
                    height: 35
                    width: 275
                    color: mainWindow.fontColor
                    fontSize: 14
                    radius: 3
                    maxLength: 30
                    placeholderText: qsTr("First Competitor")
                    selectByMouse: true
                    selectedTextColor: mainWindow.fontColor
                    selectionColor: mainWindow.accentColor
                    trimText: true
                }

                Text {
                    id: newMatchVersusText
                    width: 275
                    text: qsTr("VERSUS")
                    color: mainWindow.fontColor
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                InputWithBorder {
                    id: secondCompetitorInput
                    color: mainWindow.fontColor
                    height: 35
                    width: 275
                    fontSize: 14
                    radius: 3
                    maxLength: 30
                    placeholderText: qsTr("Second Competitor")
                    selectByMouse: true
                    selectedTextColor: mainWindow.fontColor
                    selectionColor: mainWindow.accentColor
                    trimText: true
                }

                Item {
                    id: newMatchPredictionsEndTimeArea
                    width: predictionsEndTimePicker.width + predictionsEndDateText.width + predictionsEndDateText.anchors.leftMargin
                    height: newMatchPredictionsEndTimeText.height + newMatchPredictionsEndTimeText.anchors.topMargin +
                            predictionsEndTimePicker.height + predictionsEndTimePicker.anchors.topMargin
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: newMatchPredictionsEndTimeText
                        text: qsTr("Predictions End Time")
                        color: mainWindow.fontColor
                        font.pointSize: 16
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 15
                    }

                    TimePickerWidget {
                        id: predictionsEndTimePicker
                        color: mainWindow.backgroundColor
                        fontSize: 14
                        radius: 5
                        addIcon: "qrc://assets/icons/icons/icons8_Collapse_Arrow.png"
                        substractIcon: "qrc://assets/icons/icons/icons8_Expand_Arrow.png"
                        selectedTextColor: mainWindow.fontColor
                        selectionColor: mainWindow.accentColor
                        hoveredButtonColor: mainWindow.accentColor
                        minimumTime: {
                            var now = new Date()
                            now.setMinutes(now.getMinutes() + 1)
                            var currentDate = now.toLocaleDateString(Qt.locale(), "dd.MM.yyyy")
                            var selectedDate = calendar.selectedDate.toLocaleDateString(Qt.locale(), "dd.MM.yyyy")

                            if(currentDate === selectedDate)
                                return now.toLocaleTimeString(Qt.locale(), "hh:mm")
                            else
                                return ""
                        }
                        anchors.left: parent.left
                        anchors.top: newMatchPredictionsEndTimeText.bottom
                        anchors.topMargin: 5
                    }

                    MouseArea {
                        cursorShape: Qt.IBeamCursor
                        anchors.fill: predictionsEndDateText
                    }

                    TextEdit {
                        id: predictionsEndDateText
                        text: calendar.selectedDate.toLocaleDateString(Qt.locale(), "dd.MM.yyyy")
                        color: mainWindow.fontColor
                        font.pointSize: 14
                        readOnly: true
                        selectByMouse: true
                        selectByKeyboard: true
                        selectedTextColor: mainWindow.fontColor
                        selectionColor: mainWindow.accentColor
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: predictionsEndTimePicker.right
                        anchors.top: predictionsEndTimePicker.top
                        anchors.bottom: predictionsEndTimePicker.bottom
                        anchors.leftMargin: 15
                    }
                }

                CustomCalendar {
                    id: calendar
                    minimumDate: new Date()
                    mainColor: "#626167"
                    sideColor: mainWindow.backgroundColor
                    fontColor: fontColor
                    inactiveColor: "#626167"
                    previousIcon: "qrc://assets/icons/icons/icons8_Chevron_Left.png"
                    nextIcon: "qrc://assets/icons/icons/icons8_Chevron_Right.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: createNewMatchButton
                    text: qsTr("Create Match")
                    font.pointSize: 16
                    font.bold: true
                    enabled: firstCompetitorInput.lengthWithoutWhitespaces > 0 &&
                             secondCompetitorInput.lengthWithoutWhitespaces > 0 &&
                             firstCompetitorInput.text !== secondCompetitorInput.text ? true : false
                    anchors.horizontalCenter: parent.horizontalCenter

                    onClicked: {
                        predictionsEndTimePicker.defocus()

                        var dateString = predictionsEndDateText.text + " " + predictionsEndTimePicker.fullTime
                        var predictionsEndDate = Date.fromLocaleString(Qt.locale(), dateString, "dd.MM.yyyy hh:mm:ss")
                        var match = Qt.createQmlObject('import QtQuick 2.0;import DataStorage 1.0; Match {}', roundPage);
                        match.firstCompetitor = firstCompetitorInput.text
                        match.secondCompetitor = secondCompetitorInput.text
                        match.predictionsEndTime = predictionsEndDate
                        match.tournamentName = currentTournament.name
                        match.tournamentHostName = currentTournament.hostName
                        match.roundName = tournamentNavigationPage.currentPage

                        backend.createNewMatch(match)
                        match.destroy()

                        createNewMatchPopup.close()
                        startLoading()
                    }
                }
            }

            function reset()
            {
                firstCompetitorInput.reset()
                secondCompetitorInput.reset()
                predictionsEndTimePicker.reset()
                calendar.reset()
            }
        }
    }

    Connections {
        target: packetProcessor

        onZeroMatchesToPull: listOfMatches.stopLoading()
        onAllMatchesPulled: console.log("PULL PREDICTIONS")
        onMatchItemArrived: {
            var match = {}
            match.firstCompetitor = matchItem[0]
            match.secondCompetitor = matchItem[1]
            match.firstCompetitorScore = parseInt(matchItem[2])
            match.secondCompetitorScore = parseInt(matchItem[3])
            match.predictionsEndTime = matchItem[4]
            match.predictions = []
            match.currentUserMadePrediction = true

            listOfMatches.addMatch(match)
        }

        onCreatingNewMatchReply: {
            stopLoading()

            if(replyState)
            {
                var match = {}
                match.firstCompetitor = firstCompetitorInput.text
                match.secondCompetitor = secondCompetitorInput.text
                match.firstCompetitorScore = 0
                match.secondCompetitorScore = 0
                match.predictionsEndTime = predictionsEndDateText.text + " " + predictionsEndTimePicker.time
                match.predictions = []
                match.currentUserMadePrediction = false

                listOfMatches.addMatch(match)
            }
            else
                navigationPage.showDeniedResponse(message)

            createNewMatchPopup.reset()
        }

        onMatchDeleted: {
            stopLoading()
            listOfMatches.deleteMatch(firstCompetitor, secondCompetitor)
        }

        onMatchDeletingError: {
            stopLoading()
            navigationPage.showDeniedResponse(message)
        }

        onMatchScoreUpdated: {
            stopLoading()
            listOfMatches.updateMatchScore(updatedMatch[0], updatedMatch[1], parseInt(updatedMatch[2]), parseInt(updatedMatch[3]))
        }

        onMatchScoreUpdatingError: {
            stopLoading()
            navigationPage.showDeniedResponse(message)
        }
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

    Component.onCompleted: {
        backend.pullMatches(currentTournament.name, currentTournament.hostName, tournamentNavigationPage.currentPage)
        listOfMatches.startLoading()
    }

    function startLoading()
    {
        navigationPage.enabled = false
        mainWindow.startBusyIndicator()
        busyTimer.restart()
    }

    function stopLoading()
    {
        busyTimer.stop()
        navigationPage.enabled = true
        mainWindow.stopBusyIndicator()
    }
}
