import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import "../components"
import "../reusableWidgets"

Page {
    id: userProfilePage

    ColumnLayout {
        id: pageLayout
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        Rectangle {
            id: topArea
            color: mainWindow.colorA
            radius: 5

            Layout.fillWidth: true
            Layout.preferredHeight: 160

            RowLayout {
                anchors.fill: parent

                Column {
                    id: avatarArea
                    spacing: 3
                    Layout.preferredWidth: 120
                    Layout.fillHeight: true
                    Layout.margins: 17

                    Rectangle {
                        id: userAvatarBackground
                        color: mainWindow.backgroundColor
                        width: 120
                        height: 120
                        radius: 20

                        /*Image {
                            id: userAvatar
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
                        }*/
                    }

                    TextButton {
                        id: profileEditButton
                        text: qsTr("EDIT PROFILE")
                        textColor: mainWindow.fontColor
                        textColorHovered: mainWindow.accentColor
                        fontSize: 10
                        bold: true
                        anchors.horizontalCenter: userAvatarBackground.horizontalCenter

                        onClicked: editProfilePopup.open()
                    }
                }

                GroupBox {
                    id: userInfoArea
                    anchors.left: avatarArea.right
                    anchors.leftMargin: 30
                    padding: 0

                    Layout.fillHeight: true
                    Layout.preferredWidth: finishedTournamentsArea.width - userInfoArea.anchors.leftMargin -
                                           avatarArea.width - avatarArea.Layout.margins
                    Layout.topMargin: 20
                    Layout.bottomMargin: 20

                    background: Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "transparent"
                        border.color: mainWindow.backgroundColor
                        border.width: 2
                        radius: 3
                    }

                    label: Rectangle {
                        anchors.left: parent.left
                        anchors.bottom: parent.top
                        anchors.bottomMargin: -height/2
                        anchors.leftMargin: 10
                        color: mainWindow.colorA
                        width: textMetrics.width * 1.25
                        height: nicknameText.font.pixelSize * 1.25
                        radius: 5

                        Text {
                            id: nicknameText
                            text: "Nickname"
                            color: mainWindow.backgroundColor
                            font.pixelSize: 22
                            font.bold: true
                            anchors.centerIn: parent
                        }

                        TextMetrics {
                            id: textMetrics
                            text: nicknameText.text
                            font.family: nicknameText.font
                            font.pointSize: nicknameText.font.pointSize
                            font.bold: nicknameText.font.bold
                            elide: Text.ElideMiddle
                        }
                    }

                    Text {
                        id: profileDescription
                        text: "Description..."
                        font.pointSize: 12
                        color: mainWindow.fontColor
                        wrapMode: Text.Wrap
                        anchors.fill: parent
                        anchors.margins: 8
                        anchors.topMargin: 15
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            Rectangle {
                id: finishedTournamentsArea
                color: mainWindow.colorA
                radius: 5

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: pageLayout.width / 2

                Text {
                    id: finishedTournamentsTitle
                    text: qsTr("Finished Tournaments")
                    color: mainWindow.fontColor
                    font.pointSize: 25
                    font.bold: true
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 10
                }

                UserTournamentsList {
                    id: finishedTournamentsList
                    notLoadedResponseText: qsTr("Couldn't load your finished tournaments list")
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: finishedTournamentsTitle.bottom
                    anchors.bottom: parent.bottom
                    anchors.margins: 5
                    anchors.topMargin: 15

                    onTournamentChosen: showTournament(tournamentName, hostName)
                }
            }

            Rectangle {
                id: ongoingTournamentsArea
                color: mainWindow.colorA
                radius: 5

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: pageLayout.width / 2

                Text {
                    id: ongoingTournamentsTitle
                    text: qsTr("Ongoing Tournaments")
                    color: mainWindow.fontColor
                    font.pointSize: 25
                    font.bold: true
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 10
                }

                UserTournamentsList {
                    id: ongoingTournamentsList
                    notLoadedResponseText: qsTr("Couldn't load your ongoing tournaments list")
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: ongoingTournamentsTitle.bottom
                    anchors.bottom: parent.bottom
                    anchors.margins: 5
                    anchors.topMargin: 15

                    onTournamentChosen: showTournament(tournamentName, hostName)
                }
            }
        }
    }

    Item {
        width: editProfilePopup.width
        height: editProfilePopup.height
        anchors.centerIn: parent

        PopupBox {
            id: editProfilePopup
            width: 700
            height: 500

            Text {
                id: editProfilePopupTitle
                text: qsTr("Editing Profile")
                color: mainWindow.fontColor
                font.bold: true
                font.pointSize: 25
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 15
            }

            Text {
                id: descriptionTitle
                text: qsTr("Description")
                color: mainWindow.fontColor
                font.pointSize: 18
                anchors.left: parent.left
                anchors.top: editProfilePopupTitle.bottom
                anchors.leftMargin: 15
                anchors.topMargin: 15
            }

            Rectangle {
                id: descriptionTitleUnderline
                width: parent.width
                height: 2
                color: mainWindow.fontColor
                radius: 5
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: descriptionTitle.bottom
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                anchors.topMargin: 5
            }

            TextInputArea {
                id: newDescription
                width: 650
                height: 150
                placeholderText: qsTr("New Description...")
                backgroundColor: "black"
                fontColor: mainWindow.fontColor
                fontSize: 12
                counterFontSize: 10
                backgroundRadius: 5
                maximumLength: 250
                selectByMouse: true
                selectedTextColor: mainWindow.fontColor
                selectionColor: mainWindow.accentColor
                charactersCounterVisible: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: descriptionTitleUnderline.bottom
                anchors.topMargin: 15
            }

            Button {
                id: updateDescriptionButton
                text: qsTr("Update Description")
                height: 35
                font.pointSize: 10
                enabled: newDescription.text ? true : false
                anchors.top: newDescription.bottom
                anchors.right: newDescription.right

                onClicked: {
                    backend.updateUserProfileDescription(currentUser.username, newDescription.text)

                    editProfilePopup.enabled = false
                    navigationPage.enabled = false
                    mainWindow.startBusyIndicator()
                    busyTimer.restart()
                }
            }

            Text {
                id: updatingDescriptionResponseText
                color: mainWindow.acceptedColor
                font.pointSize: 8
                font.bold: true
                opacity: 0
                anchors.top: newDescription.bottom
                anchors.left: newDescription.left
                anchors.margins: 2
            }

            Timer {
                id: updatingDescriptionResponseTimer
                interval: 5000

                onTriggered: animateHidingUpdatingDescriptionResponseText.start()
            }

            NumberAnimation {
               id: animateShowingUpdatingDescriptionResponseText
               target: updatingDescriptionResponseText
               properties: "opacity"
               from: updatingDescriptionResponseText.opacity
               to: 1.0
               duration: 150
               easing {type: Easing.Linear}
            }

            NumberAnimation {
               id: animateHidingUpdatingDescriptionResponseText
               target: updatingDescriptionResponseText
               properties: "opacity"
               from: updatingDescriptionResponseText.opacity
               to: 0.0
               duration: 500
               easing {type: Easing.Linear}
            }

            /*Button {
                text: "FileDialog"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: dialog.open()
            }

            FileDialog {
                id: dialog
                title: qsTr("Choose Your Avatar")
                folder: shortcuts.desktop
                nameFilters: ["Image files (*.jpg *.png)"]
            }*/
        }
    }

    Connections {
        target: packetProcessor

        onUserInfoDownloadReply: {
            nicknameText.text = currentUser.username
            profileDescription.text = description
        }

        onFinishedTournamentsListArrived: {
            if(numberOfItems === 0)
            {
                finishedTournamentsList.notLoadedResponseText =
                qsTr("You weren't participating in any finished tournaments yet")
            }
            finishedTournamentsList.hideLoadingText()
        }

        onOngoingTournamentsListArrived: {
            if(numberOfItems === 0)
            {
                ongoingTournamentsList.notLoadedResponseText =
                qsTr("There aren't any ongoing tournaments that you participate in")
            }
            ongoingTournamentsList.hideLoadingText()
        }

        onFinishedTournamentsListItemArrived: finishedTournamentsList.addItem(tournamentName, hostName)
        onOngoingTournamentsListItemArrived: ongoingTournamentsList.addItem(tournamentName, hostName)

        onUserProfileDescriptionUpdated: {
            editProfilePopup.enabled = true
            busyTimer.stop()
            navigationPage.enabled = true
            mainWindow.stopBusyIndicator()

            updatingDescriptionResponseText.text = message
            updatingDescriptionResponseText.color = mainWindow.acceptedColor
            animateShowingUpdatingDescriptionResponseText.start()
            updatingDescriptionResponseTimer.restart()
            newDescription.text = ""
        }

        onUserProfileDescriptionUpdatingError: {
            editProfilePopup.enabled = true
            busyTimer.stop()
            navigationPage.enabled = true
            mainWindow.stopBusyIndicator()

            updatingDescriptionResponseText.text = message
            updatingDescriptionResponseText.color = mainWindow.deniedColor
            animateShowingUpdatingDescriptionResponseText.start()
            updatingDescriptionResponseTimer.restart()
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
        downloadProfile()
        finishedTournamentsList.showLoadingText()
        ongoingTournamentsList.showLoadingText()
    }

    function downloadProfile()
    {
        backend.downloadUserProfileInfo(currentUser.username)
        backend.pullFinishedTournaments(currentUser.username)
        backend.pullOngoingTournaments(currentUser.username)
    }

    function refreshFinishedTournamentsList()
    {
        finishedTournamentsList.clear()
        backend.pullFinishedTournaments(currentUser.username)
        finishedTournamentsList.showLoadingText()
    }

    function refreshOngoingTournamentsList()
    {
        ongoingTournamentsList.clear()
        backend.pullOngoingTournaments(currentUser.username)
        ongoingTournamentsList.showLoadingText()
    }

    function showTournament(tournamentName, hostName)
    {
        currentTournament.name = tournamentName
        currentTournament.hostName = hostName

        navigationPage.pushTournament("qrc:/pages/TournamentNavigationPage.qml")
        navigationPage.changePage(1)
    }

    function refresh()
    {
        finishedTournamentsList.clear()
        ongoingTournamentsList.clear()
        downloadProfile()
        finishedTournamentsList.showLoadingText()
        ongoingTournamentsList.showLoadingText()
    }
}
