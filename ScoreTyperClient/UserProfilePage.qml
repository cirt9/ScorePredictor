import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
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
                        id: userAvatar
                        color: "white"
                        width: 120
                        height: 120

                        Text {
                            text: ".jpg"
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }

                    TextButton {
                        id: profileEditButton
                        text: qsTr("EDIT PROFILE")
                        textColor: mainWindow.fontColor
                        textColorHovered: mainWindow.accentColor
                        fontSize: 10
                        bold: true
                        anchors.horizontalCenter: userAvatar.horizontalCenter
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

                    onItemDoubleClicked: console.log(tournamentName, hostName)
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

                    onItemDoubleClicked: console.log(tournamentName, hostName)
                }
            }
        }
    }

    Component.onCompleted: {
        downloadProfile()
        finishedTournamentsList.startLoading()
        ongoingTournamentsList.startLoading()
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
                qsTr("You weren't participating in any tournaments yet")
            }
            finishedTournamentsList.stopLoading()
        }

        onOngoingTournamentsListArrived: {
            if(numberOfItems === 0)
            {
                ongoingTournamentsList.notLoadedResponseText =
                qsTr("There aren't any ongoing tournaments that you participate in")
            }
            ongoingTournamentsList.stopLoading()
        }

        onFinishedTournamentsListItemArrived: finishedTournamentsList.addItem(tournamentName, hostName)
        onOngoingTournamentsListItemArrived: ongoingTournamentsList.addItem(tournamentName, hostName)
    }

    function downloadProfile()
    {
        backend.downloadUserInfo(currentUser.username)
        backend.pullFinishedTournaments(currentUser.username)
        backend.pullOngoingTournaments(currentUser.username)
    }

    function refresh()
    {
        finishedTournamentsList.clear()
        ongoingTournamentsList.clear()
        downloadProfile()
        finishedTournamentsList.startLoading()
        ongoingTournamentsList.startLoading()
    }
}
