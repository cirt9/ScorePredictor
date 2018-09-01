import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../components"

Page {
    id: tournamentCreatorPage

    MouseArea {
        anchors.fill: parent
        onClicked: entriesEndDatePicker.hideCalendar()
    }

    Rectangle {
        id: tournamentCreationArea
        color: mainWindow.colorA
        radius: 5
        anchors.fill: parent
        anchors.margins: 15

        DefaultLineInput {
            id: tournamentNameInput
            width: parent.width * 0.7
            placeholderText: qsTr("Tournament Name")
            fontSize: 25
            selectByMouse: true
            maximumLength: 30
            textColor: mainWindow.fontColor
            selectionColor: mainWindow.accentColor
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 10
        }

        Rectangle {
            id: headerLine
            color: mainWindow.backgroundColor
            height: 3
            width: parent.width * 0.9
            radius: 5
            anchors.top: tournamentNameInput.bottom
            anchors.horizontalCenter: tournamentNameInput.horizontalCenter
        }

        LabeledLineInput {
            id: tournamentPasswordInput
            labelText: qsTr("Password:")
            labelTextColor: mainWindow.fontColor
            labelAreaColor: mainWindow.backgroundColor
            inputAreaColor: mainWindow.colorB
            selectByMouse: true
            maximumLength: 30
            selectedTextColor: mainWindow.fontColor
            selectionColor: mainWindow.accentColor
            labelWidth: 130
            inputWidth: parent.width * 0.15
            anchors.left: headerLine.left
            anchors.top: headerLine.bottom
            anchors.topMargin: 50
        }

        Rectangle {
            id: predictorsLimitArea
            color: mainWindow.backgroundColor
            width: entriesEndTimeArea.width
            height: predictorsLimit.height
            radius: 10
            anchors.left: tournamentPasswordInput.left
            anchors.top: tournamentPasswordInput.bottom
            anchors.topMargin: 10

            Text {
                id: predictorsLimitText
                text: qsTr("Predictors Limit:")
                font.pointSize: 14
                color: mainWindow.fontColor
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10
            }

            Rectangle {
                color: mainWindow.colorB
                radius: 5
                anchors.left: predictorsLimitText.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 5
                anchors.leftMargin: 7

                SpinBox {
                    id: predictorsLimit
                    width: parent.width * 0.95
                    editable: true
                    from: 1
                    value: 16
                    to: 1000
                    anchors.centerIn: parent
                }
            }
        }

        Rectangle {
            id: footerLine
            color: mainWindow.backgroundColor
            height: 3
            width: parent.width * 0.9
            radius: 5
            anchors.bottom: createTournamentButton.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 15
        }

        Rectangle {
            id: replyArea
            color: mainWindow.backgroundColor
            width: createTournamentButton.width
            height: 0
            radius: 10
            anchors.verticalCenter: footerLine.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            property bool hidden: true

            ResponseText {
                id: replyText
                deniedColor: mainWindow.deniedColor
                fontSize: 10
                visibilityTime: replyTimer.interval
                showingDuration: 250
                hidingDuration: 200
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            NumberAnimation {
                id: animateReplyAreaShowing
                target: replyArea
                property: "height"
                from: replyArea.height
                to: 20
                duration: 200
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                id: animateReplyAreaHiding
                target: replyArea
                property: "height"
                from: replyArea.height
                to: 0
                duration: 250
                easing.type: Easing.OutInQuad
            }

            Timer {
                id: replyTimer
                interval: 10000

                onTriggered: {
                    animateReplyAreaHiding.start()
                    replyText.hide()
                    replyArea.hidden = true
                }
            }
        }

        Rectangle {
            id: entriesEndTimeArea
            height: entriesEndTimeTextMetrics.height + entriesEndTimePicker.height + 15
            width: tournamentPasswordInput.width
            color: mainWindow.backgroundColor
            radius: 10
            anchors.left: predictorsLimitArea.left
            anchors.top: predictorsLimitArea.bottom
            anchors.topMargin: 10

            Text {
                id: entriesEndTimeText
                text: qsTr("Entries End Time:")
                color: mainWindow.fontColor
                font.pointSize: 14
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 5
                anchors.leftMargin: 10

                TextMetrics {
                    id: entriesEndTimeTextMetrics
                    font.pointSize: entriesEndTimeText.font.pointSize
                    font.family: entriesEndTimeText.font
                    text: entriesEndTimeText.text
                }
            }

            Rectangle {
                height: entriesEndTimePicker.height
                color: mainWindow.colorB
                radius: 5
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 5

                TimePickerWidget {
                    id: entriesEndTimePicker
                    color: mainWindow.colorB
                    fontSize: 14
                    radius: 10
                    addIcon: "qrc://assets/icons/icons/icons8_Collapse_Arrow.png"
                    substractIcon: "qrc://assets/icons/icons/icons8_Expand_Arrow.png"
                    selectedTextColor: mainWindow.fontColor
                    selectionColor: mainWindow.accentColor
                    hoveredButtonColor: mainWindow.backgroundColor
                    minimumTime: {
                        var now = new Date()
                        now.setMinutes(now.getMinutes() + 1)
                        var currentDate = now.toLocaleDateString(Qt.locale(), "dd.MM.yyyy")

                        if(currentDate === entriesEndDatePicker.simplifiedDate)
                            return now.toLocaleTimeString(Qt.locale(), "hh:mm")
                        else
                            return ""
                    }
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                }

                DatePickerWidget {
                    id: entriesEndDatePicker
                    color: mainWindow.colorB
                    radius: 10
                    fontSize: 14
                    fontColor: mainWindow.fontColor
                    expandCalendarIcon: "qrc://assets/icons/icons/icons8_Expand_Arrow.png"
                    previousIcon: "qrc://assets/icons/icons/icons8_Chevron_Left.png"
                    nextIcon: "qrc://assets/icons/icons/icons8_Chevron_Right.png"
                    hoveredButtonColor: mainWindow.backgroundColor
                    selectByMouse: true
                    selectedTextColor: mainWindow.fontColor
                    selectionColor: mainWindow.accentColor
                    calendarMainColor: mainWindow.colorB
                    calendarSideColor: "#6A352E"
                    calendarInactiveColor: "#766363"
                    minimumDate: new Date()
                    calendarAlignRight: true
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }
            }
        }

        DefaultButton {
            id: createTournamentButton
            text: qsTr("Create Tournament")
            color: mainWindow.backgroundColor
            textColor: mainWindow.fontColor
            fontSize: 25
            radius: 5
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 10

            onClicked: {
                if(!replyArea.hidden)
                    hideReplyArea()

                if(tournamentNameInput.text.length === 0)
                    showReplyArea(qsTr("Tournament name is required"))
                else
                {
                    entriesEndTimePicker.defocus()

                    var dateString = entriesEndDatePicker.simplifiedDate + " " + entriesEndTimePicker.fullTime
                    var date = Date.fromLocaleString(Qt.locale(), dateString, "dd.MM.yyyy hh:mm:ss")
                    var tournament = Qt.createQmlObject('import QtQuick 2.0;import DataStorage 1.0; Tournament {}',
                                                       tournamentCreatorPage);
                    tournament.name = tournamentNameInput.text
                    tournament.hostName = currentUser.username
                    tournament.passwordRequired = tournamentPasswordInput.text === "" ? false : true
                    tournament.entriesEndTime = date
                    tournament.predictorsNumber = 0
                    tournament.predictorsLimit = predictorsLimit.value
                    backend.createTournament(tournament, tournamentPasswordInput.text)
                    tournament.destroy()

                    mainWindow.startLoading(busyTimer, navigationPage)
                }
            }
        }
    }

    Connections {
        target: packetProcessor

        onTournamentCreationReply: {
            mainWindow.stopLoading(busyTimer, navigationPage)

            if(replyState)
            {
                currentTournament.name = tournamentNameInput.text
                currentTournament.hostName = currentUser.username

                userProfilePage.refreshOngoingTournamentsList()
                navigationPage.pushTournament("qrc:/pages/TournamentNavigationPage.qml")
                navigationPage.changePage(1)
            }
            else
                showReplyArea(message)

            refresh()
        }
    }

    Timer {
        id: busyTimer
        interval: mainWindow.serverResponseWaitingTimeMsec

        onTriggered: {
            navigationPage.enabled = true
            mainWindow.stopBusyIndicator()
            refresh()
            backend.disconnectFromServer()
            mainWindow.showErrorPopup(qsTr("Connection lost. Try again later."))
        }
    }

    function showReplyArea(message)
    {
        animateReplyAreaShowing.start()
        replyText.showDeniedResponse(message)
        replyArea.hidden = false
        replyTimer.restart()
    }

    function hideReplyArea()
    {
        animateReplyAreaHiding.start()
        replyText.hide()
        replyArea.hidden = true
        replyTimer.stop()
    }

    function refresh()
    {
        tournamentNameInput.text = ""
        tournamentNameInput.inputFocus = false
        tournamentPasswordInput.text = ""
        tournamentPasswordInput.inputFocus = false
        predictorsLimit.focus = false
        predictorsLimit.value = 16
        entriesEndTimePicker.reset()
        entriesEndDatePicker.reset()
    }
}
