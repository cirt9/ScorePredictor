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
            labelWidth: 105
            inputWidth: parent.width * 0.15
            anchors.left: headerLine.left
            anchors.top: headerLine.bottom
            anchors.topMargin: 50
        }

        Rectangle {
            id: typersLimitArea
            color: mainWindow.backgroundColor
            width: entriesEndTimeArea.width
            height: typersLimit.height
            radius: 10
            anchors.left: tournamentPasswordInput.left
            anchors.top: tournamentPasswordInput.bottom
            anchors.topMargin: 10

            Text {
                id: typersLimitText
                text: qsTr("Typers Limit:")
                font.pointSize: 14
                color: mainWindow.fontColor
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10
            }

            Rectangle {
                color: mainWindow.colorB
                radius: 5
                anchors.left: typersLimitText.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 5
                anchors.leftMargin: 7

                SpinBox {
                    id: typersLimit
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

            Text {
                id: replyText
                color: mainWindow.deniedColor
                font.pointSize: 10
                opacity: 0
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            NumberAnimation {
                id: animateReplyAreaShowing
                target: replyArea
                property: "height"
                from: replyArea.height
                to: 20
                duration: 150
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                id: animateReplyTextShowing
                target: replyText
                property: "opacity"
                from: replyText.opacity
                to: 1
                duration: 100
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                id: animateReplyAreaHiding
                target: replyText
                property: "opacity"
                from: replyText.opacity
                to: 0
                duration: 100
                easing.type: Easing.OutInQuad
            }
            NumberAnimation {
                id: animateReplyTextHiding
                target: replyArea
                property: "height"
                from: replyArea.height
                to: 0
                duration: 150
                easing.type: Easing.OutInQuad
            }

            Timer {
                id: replyTimer
                interval: 10000

                onTriggered: hideReplyArea()
            }
        }

        Rectangle {
            id: entriesEndTimeArea
            height: entriesEndTimeTextMetrics.height + entriesEndTimePicker.height + 15
            width: tournamentPasswordInput.width
            color: mainWindow.backgroundColor
            radius: 10
            anchors.left: typersLimitArea.left
            anchors.top: typersLimitArea.bottom
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
                {
                    replyText.text = qsTr("Tournament name is required")
                    showReplyArea()
                }
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
                    tournament.typersNumber = 0
                    tournament.typersLimit = typersLimit.value
                    backend.createTournament(tournament, tournamentPasswordInput.text)
                    tournament.destroy()

                    navigationPage.enabled = false
                    mainWindow.startBusyIndicator()
                    busyTimer.restart()
                }
            }
        }
    }

    Connections {
        target: packetProcessor

        onTournamentCreationReply: {
            busyTimer.stop()
            navigationPage.enabled = true
            mainWindow.stopBusyIndicator()

            if(replyState)
            {
                currentTournament.name = tournamentNameInput.text
                currentTournament.hostName = currentUser.username

                userProfilePage.refreshOngoingTournamentsList()
                navigationPage.pushTournament("qrc:/pages/TournamentNavigationPage.qml")
                navigationPage.changePage(1)
            }
            else
            {
                replyText.text = message
                showReplyArea()
            }
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

    function showReplyArea()
    {
        animateReplyAreaShowing.start()
        animateReplyTextShowing.start()
        replyArea.hidden = false
        replyTimer.restart()
    }

    function hideReplyArea()
    {
        animateReplyAreaHiding.start()
        animateReplyTextHiding.start()
        replyArea.hidden = true
        replyTimer.stop()
    }

    function refresh()
    {
        tournamentNameInput.text = ""
        tournamentNameInput.inputFocus = false
        tournamentPasswordInput.text = ""
        tournamentPasswordInput.inputFocus = false
        typersLimit.focus = false
        typersLimit.value = 16
        entriesEndTimePicker.reset()
        entriesEndDatePicker.reset()
    }
}
