import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../components"

Item {
    id: root
    clip: true

    readonly property bool hostMode: currentTournament.hostName === currentUser.username ? true : false
    readonly property int viewHeaderHeight: 45
    readonly property int viewFooterHeight: 45
    readonly property int matchHeaderHeight: 40
    readonly property int predictionDelegateHeight: 30
    readonly property int matchesSpacing: 2
    property string matchesNotFoundText
    property string errorText
    property bool loadingState: false
    signal creatingNewMatch()

    ListView {
        id: matchesView
        model: matchesModel
        delegate: matchesDelegate
        header: headerDelegate
        headerPositioning: ListView.OverlayHeader
        anchors.fill: parent

        Item {
            id: footer
            width: parent.width
            height: viewFooterHeight
            visible: hostMode ? true : false
            z: 3
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: footerBackground
                width: parent.width
                height: viewFooterHeight - 5
                color: mainWindow.colorB
                radius: 5
                anchors.bottom: parent.bottom
                anchors.left: parent.left
            }

            TextButton {
                id: createNewMatchButton
                text: qsTr("Create New Match")
                textColor: mainWindow.fontColor
                fontSize: 18
                bold: true
                anchors.top: footerBackground.top
                anchors.bottom: footerBackground.bottom
                anchors.horizontalCenter: footerBackground.horizontalCenter

                onClicked: root.creatingNewMatch()
            }
        }

        TextEdit {
            id: infoText
            font.pointSize: 22
            font.bold: true
            color: mainWindow.fontColor
            readOnly: true
            wrapMode: TextEdit.WordWrap
            visible: !loadingState && matchesModel.count === 0 ? true : false
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
            fontSize: 22
            running: loadingState && matchesModel.count === 0 ? true : false
            anchors.centerIn: parent
        }
    }

    Component {
        id: headerDelegate

        Item {
            width: matchesView.width
            height: viewHeaderHeight
            z: 3

            Rectangle {
                id: headerBackground
                width: parent.width
                height: viewHeaderHeight - 5
                color: mainWindow.colorB
                radius: 5
                anchors.top: parent.top
                anchors.left: parent.left
            }

            RowLayout {
                id: viewHeaderLayout
                anchors.fill: headerBackground
                anchors.margins: 2
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Text {
                    id: competitorsHeader
                    text: qsTr("Match")
                    color: mainWindow.fontColor
                    font.pointSize: 14
                    verticalAlignment: Text.AlignVCenter

                    Layout.fillHeight: true
                    Layout.preferredWidth: viewHeaderLayout.width * 0.50
                }

                Text {
                    id: scoreHeader
                    text: qsTr("Score")
                    color: mainWindow.fontColor
                    font.pointSize: 14
                    verticalAlignment: Text.AlignVCenter

                    Layout.fillHeight: true
                    Layout.preferredWidth: viewHeaderLayout.width * 0.15
                }

                Text {
                    id: predictionsEndTimeHeader
                    text: qsTr("Predictions End Time")
                    color: mainWindow.fontColor
                    font.pointSize: 14
                    verticalAlignment: Text.AlignVCenter

                    Layout.fillHeight: true
                    Layout.preferredWidth: viewHeaderLayout.width * 0.35
                }
            }
        }
    }

    Component {
        id: matchesDelegate

        ListView {
            id: predictionsView
            width: matchesView.width
            height: {
                if(collapsed)
                    return matchHeaderHeight
                else if(!currentUserMadePrediction)
                    return matchHeaderHeight + predictions.count * predictionDelegateHeight +
                           (predictions.count - 1) * spacing + matchesSpacing + predictionDelegateHeight + matchesSpacing
                else
                    return matchHeaderHeight + predictions.count * predictionDelegateHeight +
                           (predictions.count - 1) * spacing + matchesSpacing
            }
            model: predictions
            headerPositioning: ListView.OverlayHeader
            spacing: 2
            clip: true

            header: Item {
                id: matchHeader
                width: matchesView.width
                height: currentUserMadePrediction ? matchHeaderHeight : matchHeaderHeight + predictionDelegateHeight +
                                                    matchesSpacing
                z: 2

                Rectangle {
                    id: matchHeaderBackground
                    width: parent.width
                    height: matchHeaderHeight - matchesSpacing
                    color: mainWindow.colorB
                    radius: 5
                    opacity: 0.7
                    anchors.left: parent.left
                    anchors.top: parent.top
                }

                MouseArea {
                    anchors.fill: matchHeaderBackground
                    onClicked: collapsed = !collapsed
                }

                RowLayout {
                    id: matchHeaderLayout
                    anchors.fill: matchHeaderBackground
                    anchors.margins: 2
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5

                    Text {
                        id: competitorsData
                        text: firstCompetitor + " vs " + secondCompetitor
                        color: mainWindow.fontColor
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                        Layout.fillHeight: true
                        Layout.preferredWidth: matchHeaderLayout.width * 0.5
                    }

                    Text {
                        id: scoreData
                        text: firstCompetitorScore + ":" + secondCompetitorScore
                        color: mainWindow.fontColor
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        visible: hostMode ? false : true

                        Layout.fillHeight: true
                        Layout.preferredWidth: matchHeaderLayout.width * 0.15
                    }

                    ScoreInput {
                        id: scoreInput
                        color: mainWindow.fontColor
                        maxLength: 3
                        inputWidth: 30
                        inputHeight: 30
                        leftScore: firstCompetitorScore
                        rightScore: secondCompetitorScore
                        visible: hostMode ? true : false

                        Layout.fillHeight: true
                        Layout.preferredWidth: matchHeaderLayout.width * 0.15
                    }

                    Text {
                        id: predictionsEndTimeData
                        text: predictionsEndTime
                        color: mainWindow.fontColor
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                        Layout.fillHeight: true
                        Layout.preferredWidth: matchHeaderLayout.width * 0.35
                    }
                }

                Rectangle {
                    id: makePredictionArea
                    width: parent.width
                    height: predictionDelegateHeight
                    color: mainWindow.colorB
                    opacity: 0.4
                    radius: 5
                    visible: collapsed ? false : (currentUserMadePrediction ? false : true)
                    anchors.top: matchHeaderBackground.bottom
                    anchors.left: matchHeaderBackground.left
                    anchors.topMargin: matchesSpacing
                }

                RowLayout {
                    id: makePredictionLayout
                    visible: collapsed ? false : (currentUserMadePrediction ? false : true)
                    anchors.fill: makePredictionArea
                    anchors.margins: 2
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5

                    Text {
                        id: yourPredictionText
                        text: qsTr("Make Your Prediction")
                        color: mainWindow.fontColor
                        font.pointSize: 10
                        font.bold: true
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                        Layout.fillHeight: true
                        Layout.preferredWidth: makePredictionLayout.width * 0.5
                    }

                    ScoreInput {
                        id: initialPredictionScoreInput
                        color: mainWindow.fontColor
                        maxLength: 3
                        inputWidth: 30
                        inputHeight: 25

                        Layout.fillHeight: true
                        Layout.preferredWidth: makePredictionLayout.width * 0.15
                    }

                    Item {
                        id: makePredictionButtonContainer

                        Layout.fillHeight: true
                        Layout.preferredWidth: makePredictionLayout.width * 0.35

                        TextButton {
                            id: makePredictionButton
                            text: qsTr("READY")
                            textColor: mainWindow.fontColor
                            fontSize: 10
                            bold: true
                            anchors.centerIn: parent
                        }
                    }
                }

                IconButton {
                    id: saveMatchScoreButton
                    width: height
                    iconSource: "qrc://assets/icons/icons/icons8_Save.png"
                    margins: 10
                    marginsOnPressed: 11
                    visible: hostMode ? true : false
                    anchors.top: matchHeaderBackground.top
                    anchors.bottom: matchHeaderBackground.bottom
                    anchors.right: deleteMatchButton.left
                    anchors.rightMargin: -15

                    onClicked: {
                        if(scoreInput.enteredLeftScore.length > 0 && scoreInput.enteredRightScore.length > 0)
                        {
                            firstCompetitorScore = parseInt(scoreInput.enteredLeftScore)
                            secondCompetitorScore = parseInt(scoreInput.enteredRightScore)
                            scoreInput.reset()
                        }
                    }
                }

                IconButton {
                    id: deleteMatchButton
                    width: height
                    iconSource: "qrc://assets/icons/icons/icons8_Delete_Accent.png"
                    margins: 7
                    marginsOnPressed: 8
                    visible: hostMode ? true : false
                    anchors.top: matchHeaderBackground.top
                    anchors.bottom: matchHeaderBackground.bottom
                    anchors.right: matchHeaderBackground.right
                    anchors.rightMargin: -5

                    onClicked: matchesModel.remove(index)
                }
            }

            delegate: Item {
                id: predictionDelegate
                width: parent.width
                height: predictionDelegateHeight
                visible: collapsed ? false : true

                Rectangle {
                    id: predictionDelegateBackground
                    height: parent.height
                    width: parent.width
                    color: mainWindow.colorB
                    radius: 5
                    opacity: 0.4
                    anchors.right: parent.right
                    anchors.top: parent.top
                }

                RowLayout {
                    id: predictionDelegateLayout
                    anchors.fill: predictionDelegateBackground
                    anchors.margins: 2
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5

                    Text {
                        id: predictorsNicknameData
                        text: nickname
                        color: mainWindow.fontColor
                        font.pointSize: 10
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                        Layout.fillHeight: true
                        Layout.preferredWidth: predictionDelegateLayout.width * 0.5
                    }

                    Text {
                        id: predictedScoreData
                        text: firstCompetitorPredictedScore + ":" + secondCompetitorPredictedScore
                        color: mainWindow.fontColor
                        font.pointSize: 10
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        visible: nickname === currentUser.username && acceptingPredictions ? false : true

                        Layout.fillHeight: true
                        Layout.preferredWidth: predictionDelegateLayout.width * 0.5
                    }

                    ScoreInput {
                        id: predictedScoreInput
                        color: mainWindow.fontColor
                        maxLength: 3
                        inputWidth: 30
                        inputHeight: 25
                        leftScore: firstCompetitorPredictedScore
                        rightScore: secondCompetitorPredictedScore
                        visible: nickname === currentUser.username && acceptingPredictions ? true : false

                        Layout.fillHeight: true
                        Layout.preferredWidth: predictionDelegateLayout.width * 0.5
                    }
                }

                IconButton {
                    id: savePredictionScoreButton
                    width: height
                    iconSource: "qrc://assets/icons/icons/icons8_Save.png"
                    margins: 6
                    marginsOnPressed: 7
                    visible: nickname === currentUser.username && acceptingPredictions ? true : false
                    anchors.top: predictionDelegateBackground.top
                    anchors.bottom: predictionDelegateBackground.bottom
                    anchors.right: earnedPointsData.left

                    onClicked: console.log(firstCompetitor, predictedScoreInput.enteredLeftScore, secondCompetitor, predictedScoreInput.enteredRightScore)
                }

                Text {
                    id: earnedPointsData
                    text: earnedPoints + " " + qsTr("Points")
                    color: mainWindow.fontColor
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    anchors.top: predictionDelegateBackground.top
                    anchors.bottom: predictionDelegateBackground.bottom
                    anchors.right: predictionDelegateBackground.right
                    anchors.rightMargin: 5

                    property int earnedPoints: {
                        if(firstCompetitorScore === firstCompetitorPredictedScore &&
                           secondCompetitorScore === secondCompetitorPredictedScore)
                            return 3
                        else if(firstCompetitorScore === secondCompetitorScore)
                        {
                            if(firstCompetitorPredictedScore === secondCompetitorPredictedScore)
                                return 1
                            else
                                return 0
                        }
                        else if(firstCompetitorPredictedScore === secondCompetitorPredictedScore)
                            return 0
                        else
                        {
                            var actualWinner = firstCompetitorScore > secondCompetitorScore ?
                                               firstCompetitor : secondCompetitor
                            var predictedWinner = firstCompetitorPredictedScore > secondCompetitorPredictedScore ?
                                                  firstCompetitor : secondCompetitor

                            if(actualWinner === predictedWinner)
                                return 1
                            else
                                return 0
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: matchesModel
/*
        ListElement {
            firstCompetitor: "Croatia"
            secondCompetitor: "France"
            firstCompetitorScore: 2
            secondCompetitorScore: 4
            predictionsEndTime: "15-07-2018 17:00"
            acceptingPredictions: true
            predictions: [
                ListElement {
                    nickname: "John"
                    firstCompetitorPredictedScore: 2
                    secondCompetitorPredictedScore: 4
                },

                ListElement {
                    nickname: "TournamentTester1"
                    firstCompetitorPredictedScore: 2
                    secondCompetitorPredictedScore: 1
                },

                ListElement {
                    nickname: "TestUser"
                    firstCompetitorPredictedScore: 1
                    secondCompetitorPredictedScore: 1
                }
            ]
            currentUserMadePrediction: true
            collapsed: true
        }

        ListElement {
            firstCompetitor: "Belgium"
            secondCompetitor: "France"
            firstCompetitorScore: 0
            secondCompetitorScore: 1
            predictionsEndTime: "11-07-2018 19:00"
            acceptingPredictions: true
            predictions: [
                ListElement {
                    nickname: "John"
                    firstCompetitorPredictedScore: 2
                    secondCompetitorPredictedScore: 2
                },

                ListElement {
                    nickname: "TestUser"
                    firstCompetitorPredictedScore: 1
                    secondCompetitorPredictedScore: 0
                }
            ]
            currentUserMadePrediction: true
            collapsed: true
        }

        ListElement {
            firstCompetitor: "Croatia"
            secondCompetitor: "England"
            firstCompetitorScore: 2
            secondCompetitorScore: 2
            predictionsEndTime: "12-07-2018 19:00"
            acceptingPredictions: true
            predictions: [
                ListElement {
                    nickname: "John"
                    firstCompetitorPredictedScore: 2
                    secondCompetitorPredictedScore: 2
                },
                ListElement {
                    nickname: "TestUser"
                    firstCompetitorPredictedScore: 0
                    secondCompetitorPredictedScore: 0
                }
            ]
            currentUserMadePrediction: true
            collapsed: true
        }

        ListElement {
            firstCompetitor: "Belgium"
            secondCompetitor: "England"
            firstCompetitorScore: 2
            secondCompetitorScore: 0
            predictionsEndTime: "14-07-2018 19:00"
            acceptingPredictions: true
            predictions: []
            currentUserMadePrediction: true
            collapsed: true
        }*/
    }

    Timer {
        id: timeoutTimer
        interval: mainWindow.serverResponseWaitingTimeMsec

        onTriggered: {
            loadingState = false
            infoText.text = errorText
        }
    }

    Component.onCompleted: {
        //this has to be done after downloading list of matches from server

        for(var i=0; i<matchesModel.count; i++)
        {
            var match = matchesModel.get(i)
            var currentUserMadePrediction = false

            for(var j=0; j<match.predictions.count; j++)
            {
                var prediction = match.predictions.get(j)

                if(prediction.nickname === currentUser.username)
                {
                    currentUserMadePrediction = true
                    break
                }
            }
            match.currentUserMadePrediction = currentUserMadePrediction
        }
    }

    function addMatch(match)
    {
        var predictionsEndDateTime = Date.fromLocaleString(locale, match.predictionsEndTime, "dd.MM.yyyy hh:mm")
        var now = Date()

        match.acceptingPredictions = now < predictionsEndDateTime ? true : false
        match.collapsed = true

        matchesModel.append(match)
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
        infoText.text = matchesNotFoundText
    }

    function clear()
    {
        tournamentsList.clear()
    }
}

/*
adding predictions

var test2 = matchesModel.get(0)
var testPreds = test2.predictions

var pred = {}
pred.nickname = "JDJASJ"
pred.firstCompetitorPredictedScore = 1
pred.secondCompetitorPredictedScore = 2

testPreds.append(pred)*/

/*
modifying predictions

var test2 = matchesModel.get(0)
var testPreds = test2.predictions
var testPred = testPreds.get(0)

testPred.nickname = "TEST"*/
