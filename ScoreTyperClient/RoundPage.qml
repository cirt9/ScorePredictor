import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../reusableWidgets"

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
                hostMode: true//currentTournament.hostName === currentUser.username ? true : false
                anchors.fill: parent
                anchors.margins: 5
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

    Component.onCompleted: console.log(tournamentNavigationPage.currentPage)
}
