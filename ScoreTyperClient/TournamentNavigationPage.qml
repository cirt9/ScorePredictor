import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../components"

Page {
    id: tournamentNavigationPage
    readonly property alias currentPage: pagesList.currentItemText
    readonly property int headerHeight: 50
    property bool tournamentOpened: true

    ColumnLayout {
        id: pageLayout
        spacing: 10
        anchors.fill: parent
        anchors.margins: 15

        Rectangle {
            id: tournamentHeader
            color: mainWindow.colorA
            radius: 5

            Layout.fillWidth: true
            Layout.preferredHeight: headerHeight

            Text {
                id: tournamentName
                text: currentTournament.name
                color: mainWindow.fontColor
                width: parent.width * 0.5
                font.pointSize: 23
                font.bold: true
                elide: Text.ElideRight
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 5
            }

            Text {
                id: hostName
                text: qsTr("by ") + currentTournament.hostName
                color: mainWindow.fontColor
                opacity: 0.5
                width: parent.width * 0.5
                font.pointSize: 10
                elide: Text.ElideRight
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.bottomMargin: 2
            }

            ToolTipIcon {
                id: tournamentClosedToolTip
                width: height
                iconSource: "qrc://assets/icons/icons/icons8_Lock.png"
                text: "This tournament has come to an end."
                margins: 3
                marginsOnHovered: 6
                visible: false
                anchors.right: pagesList.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 5
                anchors.topMargin: 5
                anchors.bottomMargin: 5
            }

            IconButton {
                id: finishTournamentButton
                width: height
                iconSource: "qrc://assets/icons/icons/icons8_Padlock.png"
                margins: 3
                marginsOnPressed: 6
                visible: false
                anchors.right: pagesList.left
                anchors.top: tournamentHeader.top
                anchors.bottom: tournamentHeader.bottom
                anchors.rightMargin: 5
                anchors.topMargin: 5
                anchors.bottomMargin: 5

                onClicked: finishTournamentPopup.open()
            }

            PopupList {
                id: pagesList
                width: 250
                color: mainWindow.colorB
                radius: 10
                textColor: mainWindow.fontColor
                fontSize: 18
                buttonColor: mainWindow.backgroundColor
                buttonIcon: "qrc://assets/icons/icons/icons8_Expand_Arrow.png"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: tournamentInfoToolTip.left
                anchors.topMargin: 5
                anchors.bottomMargin: 5
                anchors.rightMargin: 2

                readonly property string mainPageName: qsTr("Leaderboard")

                onItemChanged: {
                    if(currentItemText === mainPageName && tournamentView.depth > 1)
                        tournamentView.showLeaderboard()
                    else if(currentItemText !== mainPageName)
                        tournamentView.showRound()
                }

                Component.onCompleted: pagesList.addItem(mainPageName)
            }

            ToolTipIcon {
                id: tournamentInfoToolTip
                width: height
                iconSource: "qrc://assets/icons/icons/icons8_Question_Mark.png"
                text: "Password Required: ...\n" +
                      "Entries End Time: ...\n" +
                      "Typers: ..."
                margins: 3
                marginsOnHovered: 6
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: closeTournamentPageButton.left
                anchors.topMargin: 5
                anchors.bottomMargin: 5
                anchors.rightMargin: 2
            }

            IconButton {
                id: closeTournamentPageButton
                width: height
                iconSource: "qrc://assets/icons/icons/icons8_Close_Window.png"
                margins: 3
                marginsOnPressed: 6
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 5

                onClicked: navigationPage.popTournament()
            }
        }

        StackView {
           id: tournamentView
           initialItem: TournamentLeaderboardPage {}
           popExit: Transition {}

           Layout.fillHeight: true
           Layout.fillWidth: true

           function showLeaderboard()
           {
               pop()
           }

           function showRound()
           {
               if(depth > 1)
                   pop()

               push("qrc:/pages/RoundPage.qml")
           }
        }
    }

    Component {
        id: showAddRoundPopupButtonItem

        IconButton {
            width: height
            iconSource: "qrc://assets/icons/icons/icons8_Add_New.png"
            margins: 3
            marginsOnPressed: 6

            onClicked: addRoundPopup.open()
        }
    }

    Item {
        width: finishTournamentPopup.width
        height: finishTournamentPopup.height
        anchors.centerIn: parent

        PopupBox {
            id: finishTournamentPopup
            width: 500
            height: 300

            Text {
                text: qsTr("Finishing Tournament")
                color: mainWindow.fontColor
                font.bold: true
                font.pointSize: 25
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 15
            }

            TextEdit {
                text: qsTr("You will not be able to reopen this tournament! Do you really want to finish it?")
                font.pointSize: 13
                color: mainWindow.fontColor
                readOnly: true
                wrapMode: TextEdit.Wrap
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 70
                anchors.rightMargin: 70
            }

            Row {
                spacing: 5
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    id: tournamentFinishingConfirmButton
                    text: qsTr("Yes")
                    width: 150
                    font.pointSize: 20
                    font.bold: true

                    onClicked: {
                        finishTournamentPopup.close()

                        if(currentUser.username === currentTournament.hostName)
                        {
                            backend.finishTournament(currentTournament.name, currentTournament.hostName)
                            navigationPage.enabled = false
                            mainWindow.startBusyIndicator()
                            busyTimer.restart()
                        }
                        else
                            navigationPage.showDeniedResponse(qsTr("You are not the host of this tournament!"))
                    }
                }

                Button {
                    id: tournamentFinishingDenyButton
                    text: qsTr("No")
                    width: 150
                    font.pointSize: 20
                    font.bold: true

                    onClicked: finishTournamentPopup.close()
                }
            }
        }
    }

    Item {
        width: addRoundPopup.width
        height: addRoundPopup.height
        anchors.centerIn: parent

        PopupBox {
            id: addRoundPopup
            width: 500
            height: 300

            Text {
                text: qsTr("Adding New Round")
                color: mainWindow.fontColor
                font.bold: true
                font.pointSize: 25
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 15
            }

            InputWithBorder {
                id: newRoundNameInput
                width: 300
                height: 35
                color: mainWindow.fontColor
                placeholderText: qsTr("New Round Name")
                fontSize: 16
                radius: 3
                maxLength: 30
                selectByMouse: true
                selectedTextColor: mainWindow.fontColor
                selectionColor: mainWindow.accentColor
                trimText: true
                anchors.centerIn: parent
            }

            Button {
                id: addNewRoundButton
                text: qsTr("Add Round")
                width: 300
                enabled: newRoundNameInput.lengthWithoutWhitespaces === 0 ? false : true
                font.pointSize: 20
                font.bold: true
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: newRoundNameInput.horizontalCenter

                onClicked: {
                    addRoundPopup.close()

                    if(currentUser.username === currentTournament.hostName)
                    {
                        backend.addNewRound(currentTournament.name, currentTournament.hostName, newRoundNameInput.text.trim())
                        newRoundNameInput.reset()
                        navigationPage.enabled = false
                        mainWindow.startBusyIndicator()
                        busyTimer.restart()
                    }
                    else
                        navigationPage.showDeniedResponse(qsTr("You are not the host of this tournament!"))
                }
            }
        }
    }

    Connections {
        target: packetProcessor

        onTournamentInfoDownloadReply: manageTournamentInfoReply(tournamentInfo, opened)
        onTournamentRoundNameArrived: pagesList.addItem(name)
        onFinishingTournamentReply: {
            busyTimer.stop()
            navigationPage.enabled = true
            mainWindow.stopBusyIndicator()

            if(replyState)
            {
                userProfilePage.refreshFinishedTournamentsList()
                userProfilePage.refreshOngoingTournamentsList()
                finishTournamentButton.visible = false
                tournamentClosedToolTip.visible = true
            }
            else
                navigationPage.showDeniedResponse(message)
        }
        onAddingNewRoundReply: {
            busyTimer.stop()
            navigationPage.enabled = true
            mainWindow.stopBusyIndicator()

            if(replyState)
                pagesList.addItem(message)
            else
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

    Component.onCompleted: backend.downloadTournamentInfo(currentTournament.name, currentTournament.hostName)

    function manageTournamentInfoReply(tournamentInfo, opened)
    {
        tournamentNavigationPage.tournamentOpened = opened

        tournamentInfoToolTip.text = "Password Required: " + tournamentInfo[0] + "\n" +
                                     "Entries End Time: " + tournamentInfo[1] + "\n" +
                                     "Typers: " + tournamentInfo[2] + "/" + tournamentInfo[3]

        currentTournament.passwordRequired = tournamentInfo[0] === "Yes" ? true : false
        currentTournament.entriesEndTime = Date.fromLocaleString(Qt.locale(), tournamentInfo[1], "dd.MM.yyyy hh:mm")
        currentTournament.typersNumber = parseInt(tournamentInfo[2])
        currentTournament.typersLimit = parseInt(tournamentInfo[3])

        if(currentTournament.hostName === currentUser.username)
            enableHostTools(opened)
        if(!opened)
            tournamentClosedToolTip.visible = true
    }

    function enableHostTools(opened)
    {
        createShowAddRoundPopupButton()

        if(opened)
            finishTournamentButton.visible = true
    }

    function createShowAddRoundPopupButton()
    {
        var showAddRoundPopupButton = showAddRoundPopupButtonItem.createObject(tournamentHeader)
        showAddRoundPopupButton.anchors.right = tournamentInfoToolTip.left
        showAddRoundPopupButton.anchors.top = tournamentHeader.top
        showAddRoundPopupButton.anchors.bottom = tournamentHeader.bottom
        showAddRoundPopupButton.anchors.rightMargin = -6

        pagesList.anchors.right = showAddRoundPopupButton.left
        pagesList.anchors.rightMargin = 0
    }
}
