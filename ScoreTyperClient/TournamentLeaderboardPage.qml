import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../reusableWidgets"

Page {
    id: tournamentLeaderboardPage

    Rectangle {
        id: leaderboardArea
        color: mainWindow.colorA
        radius: 5
        anchors.fill: parent

        TournamentLeaderboard {
            id: tournamentLeaderboard
            anchors.fill: parent
            anchors.margins: 5
        }
    }

    Connections {
        target: packetProcessor

        onTournamentParticipantArrived: tournamentLeaderboard.addParticipant(tournamentParticipant)
    }

    Component.onCompleted: {
        backend.downloadTournamentLeaderboard(currentTournament.name, currentTournament.hostName)
        tournamentLeaderboard.startLoading()
    }
}
