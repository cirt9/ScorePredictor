import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../reusableWidgets"

Page {
    id: tournamentLeaderboardPage

    RowLayout {
        id: pageLayout
        anchors.fill: parent
        spacing: 10

        Rectangle {
            id: chatArea
            color: mainWindow.colorA
            radius: 5

            Layout.fillHeight: true
            Layout.preferredWidth: 550
        }

        Rectangle {
            id: leaderboardArea
            color: mainWindow.colorA
            radius: 5

            Layout.fillHeight: true
            Layout.fillWidth: true

            TournamentLeaderboard {
                id: tournamentLeaderboard
                anchors.fill: parent
                anchors.margins: 5
            }
        }
    }

    Component.onCompleted: backend.downloadTournamentLeaderboard(currentTournament.name, currentTournament.hostName)
}
