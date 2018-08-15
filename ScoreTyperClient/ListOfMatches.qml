import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../components"

Item {
    id: root
    clip: true

    readonly property bool hostMode: currentTournament.hostName === currentUser.username ? true : false
    property bool openedMode: true
    readonly property int viewHeaderHeight: 45
    readonly property int viewFooterHeight: 45
    readonly property int matchHeaderHeight: 40
    readonly property int predictionDelegateHeight: 30
    readonly property int matchesSpacing: 2
    property string matchesNotFoundText
    property string errorText
    property bool loadingState: false
    signal creatingNewMatch()
    signal removingMatch(var firstCompetitor, var secondCompetitor)
    signal updatingMatchScore(var firstCompetitor, var secondCompetitor, var firstScore, var secondScore)
    signal deniedRequest(var message)
    signal makingPrediction(var predictionData)
    signal updatingMatchPrediction(var updatedPrediction)

    ListView {
        id: matchesView
        model: matchesModel
        delegate: matchesDelegate
        header: headerDelegate
        headerPositioning: ListView.OverlayHeader
        anchors.fill: parent
        anchors.bottomMargin: footer.visible ? viewFooterHeight : 0

        TextEdit {
            id: infoText
            text: matchesNotFoundText
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

    Item {
        id: footer
        width: parent.width
        height: viewFooterHeight
        visible: hostMode && openedMode ? true : false
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
                else if(!currentUserMadePrediction && acceptingPredictions)
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
                height: makePredictionArea.visible ? matchHeaderHeight + predictionDelegateHeight + matchesSpacing :
                                                     matchHeaderHeight
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
                    id: matchHeaderMouseArea
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
                        visible: hostMode ? (openedMode ? false : true) : true

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
                        selectByMouse: true
                        selectedTextColor: mainWindow.fontColor
                        selectionColor: mainWindow.accentColor
                        visible: hostMode && openedMode ? true : false

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
                    visible: collapsed || !openedMode ? false :
                             (currentUserMadePrediction ? false : (acceptingPredictions ? true : false))
                    anchors.top: matchHeaderBackground.bottom
                    anchors.left: matchHeaderBackground.left
                    anchors.topMargin: matchesSpacing
                }

                RowLayout {
                    id: makePredictionLayout
                    visible: collapsed || !openedMode ? false :
                             (currentUserMadePrediction ? false : (acceptingPredictions ? true : false))
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

                            onClicked: {
                                if(initialPredictionScoreInput.enteredLeftScore.length > 0 &&
                                   initialPredictionScoreInput.enteredRightScore.length > 0)
                                {
                                    var predictionData = {}
                                    predictionData.firstCompetitor = firstCompetitor
                                    predictionData.secondCompetitor = secondCompetitor
                                    predictionData.firstCompetitorPredictedScore =
                                            parseInt(initialPredictionScoreInput.enteredLeftScore)
                                    predictionData.secondCompetitorPredictedScore =
                                            parseInt(initialPredictionScoreInput.enteredRightScore)

                                    initialPredictionScoreInput.reset()
                                    root.makingPrediction(predictionData)
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: matchInformationArea
                    width: parent.width
                    height: predictionDelegateHeight
                    color: mainWindow.colorB
                    opacity: 0.4
                    radius: 5
                    visible: !collapsed && !openedMode && predictions.count === 0 ? true : false
                    anchors.top: matchHeaderBackground.bottom
                    anchors.left: matchHeaderBackground.left
                    anchors.topMargin: matchesSpacing
                }

                Text {
                    id: matchInformationText
                    text: qsTr("Nobody tried to predict the result of this match.")
                    color: mainWindow.fontColor
                    font.pointSize: 12
                    visible: !collapsed && !openedMode && predictions.count === 0 ? true : false
                    anchors.centerIn: matchInformationArea
                }

                IconButton {
                    id: saveMatchScoreButton
                    width: height
                    iconSource: "qrc://assets/icons/icons/icons8_Save.png"
                    margins: 10
                    marginsOnPressed: 11
                    visible: hostMode && openedMode ? true : false
                    anchors.top: matchHeaderBackground.top
                    anchors.bottom: matchHeaderBackground.bottom
                    anchors.right: deleteMatchButton.left
                    anchors.rightMargin: -15

                    onClicked: {
                        if(scoreInput.enteredLeftScore.length > 0 || scoreInput.enteredRightScore.length > 0)
                        {
                            if(scoreInput.leftScore !== scoreInput.enteredLeftScore ||
                               scoreInput.rightScore !== scoreInput.enteredRightScore)
                            {
                                var now = new Date()
                                var predictionsEndDateTime = Date.fromLocaleString(locale, predictionsEndTime,
                                                                                   "dd.MM.yyyy hh:mm")
                                if(now < predictionsEndDateTime)
                                    root.deniedRequest(qsTr("You can't set match score before the match starts."))
                                else
                                {
                                    var updatedLeftScore = scoreInput.enteredLeftScore.length === 0 ?
                                                           parseInt(scoreInput.leftScore) :
                                                           parseInt(scoreInput.enteredLeftScore)
                                    var updatedRightScore = scoreInput.enteredRightScore.length === 0 ?
                                                            parseInt(scoreInput.rightScore) :
                                                            parseInt(scoreInput.enteredRightScore)

                                    updatingMatchScore(firstCompetitor, secondCompetitor,
                                                       updatedLeftScore, updatedRightScore)
                                }
                            }

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
                    visible: hostMode && openedMode ? true : false
                    anchors.top: matchHeaderBackground.top
                    anchors.bottom: matchHeaderBackground.bottom
                    anchors.right: matchHeaderBackground.right
                    anchors.rightMargin: -5

                    onClicked: {
                        matchHeaderLayout.visible = false
                        matchHeaderMouseArea.enabled = false
                        saveMatchScoreButton.visible = false
                        deleteMatchButton.visible = false
                        collapsed = true
                        matchDeletingConfirmArea.visible = true
                    }
                }

                Row {
                    id: matchDeletingConfirmArea
                    spacing: 15
                    visible: false
                    anchors.centerIn: matchHeaderBackground

                    Text {
                        color: mainWindow.fontColor
                        text: qsTr("Are you sure you want to delete this match?")
                        font.pointSize: 12
                    }

                    TextButton {
                        id: confirmDeletingMatchButton
                        text: qsTr("Yes")
                        textColor: mainWindow.fontColor
                        fontSize: 12
                        bold: true

                        onClicked: {
                            matchDeletingConfirmArea.visible = false
                            matchHeaderLayout.visible = true
                            matchHeaderMouseArea.enabled = true
                            saveMatchScoreButton.visible = true
                            deleteMatchButton.visible = true
                            removingMatch(firstCompetitor, secondCompetitor)
                        }
                    }

                    TextButton {
                        id: cancelDeletingMatchButton
                        text: qsTr("No")
                        textColor: mainWindow.fontColor
                        fontSize: 12
                        bold: true

                        onClicked: {
                            matchDeletingConfirmArea.visible = false
                            matchHeaderLayout.visible = true
                            matchHeaderMouseArea.enabled = true
                            saveMatchScoreButton.visible = true
                            deleteMatchButton.visible = true
                        }
                    }
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
                        visible: nickname === currentUser.username && acceptingPredictions && openedMode ? false : true

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
                        selectByMouse: true
                        selectedTextColor: mainWindow.fontColor
                        selectionColor: mainWindow.accentColor
                        visible: nickname === currentUser.username && acceptingPredictions && openedMode ? true : false

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
                    visible: nickname === currentUser.username && acceptingPredictions && openedMode ? true : false
                    anchors.top: predictionDelegateBackground.top
                    anchors.bottom: predictionDelegateBackground.bottom
                    anchors.right: earnedPointsData.left

                    onClicked: {
                        if(predictedScoreInput.enteredLeftScore.length > 0 ||
                           predictedScoreInput.enteredRightScore.length > 0)
                        {
                            if(predictedScoreInput.leftScore !== predictedScoreInput.enteredLeftScore ||
                               predictedScoreInput.rightScore !== predictedScoreInput.enteredRightScore)
                            {
                                var updatedPrediction = {}
                                updatedPrediction.firstCompetitor = firstCompetitor
                                updatedPrediction.secondCompetitor = secondCompetitor

                                updatedPrediction.firstCompetitorPredictedScore =
                                                  predictedScoreInput.enteredLeftScore.length === 0 ?
                                                  parseInt(predictedScoreInput.leftScore) :
                                                  parseInt(predictedScoreInput.enteredLeftScore)

                                updatedPrediction.secondCompetitorPredictedScore =
                                                  predictedScoreInput.enteredRightScore.length === 0 ?
                                                  parseInt(predictedScoreInput.rightScore) :
                                                  parseInt(predictedScoreInput.enteredRightScore)

                                updatingMatchPrediction(updatedPrediction)
                            }

                            predictedScoreInput.reset()
                        }
                    }
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

        onCountChanged: {
            if(loadingState && count > 0)
                stopLoading()
        }
    }

    Timer {
        id: timeoutTimer
        interval: mainWindow.serverResponseWaitingTimeMsec

        onTriggered: {
            loadingState = false
            infoText.text = errorText
        }
    }

    function addMatch(match)
    {
        var predictionsEndDateTime = Date.fromLocaleString(locale, match.predictionsEndTime, "dd.MM.yyyy hh:mm")
        var now = new Date()

        match.acceptingPredictions = now < predictionsEndDateTime ? true : false
        match.collapsed = true

        matchesModel.append(match)
    }

    function deleteMatch(firstCompetitor, secondCompetitor)
    {
        for(var i=0; i<matchesModel.count; i++)
        {
            var match = matchesModel.get(i)

            if(match.firstCompetitor === firstCompetitor && match.secondCompetitor === secondCompetitor)
            {
                matchesModel.remove(i)
                break
            }
        }
    }

    function updateMatchScore(firstCompetitor, secondCompetitor, firstCompetitorScore, secondCompetitorScore)
    {
        for(var i=0; i<matchesModel.count; i++)
        {
            var match = matchesModel.get(i)

            if(match.firstCompetitor === firstCompetitor && match.secondCompetitor === secondCompetitor)
            {
                match.firstCompetitorScore = firstCompetitorScore
                match.secondCompetitorScore = secondCompetitorScore
                break
            }
        }
    }

    function addPrediction(prediction, firstCompetitor, secondCompetitor)
    {
        for(var i=0; i<matchesModel.count; i++)
        {
            var match = matchesModel.get(i)

            if(match.firstCompetitor === firstCompetitor && match.secondCompetitor === secondCompetitor)
            {
                var predictions = match.predictions

                if(prediction.nickname === currentUser.username)
                    predictions.insert(0, prediction)
                else
                    predictions.append(prediction)

                match.currentUserMadePrediction = true
                break
            }
        }
    }

    function updatePrediction(updatedPrediction, firstCompetitor, secondCompetitor)
    {
        for(var i=0; i<matchesModel.count; i++)
        {
            var match = matchesModel.get(i)

            if(match.firstCompetitor === firstCompetitor && match.secondCompetitor === secondCompetitor)
            {
                var predictions = match.predictions

                for(var j=0; j<predictions.count; j++)
                {
                    var prediction = predictions.get(j)

                    if(prediction.nickname === updatedPrediction.nickname)
                    {
                        prediction.firstCompetitorPredictedScore = updatedPrediction.firstCompetitorPredictedScore
                        prediction.secondCompetitorPredictedScore = updatedPrediction.secondCompetitorPredictedScore
                        break
                    }
                }

                break
            }
        }
    }

    function assignPredictingCapabilities()
    {
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
