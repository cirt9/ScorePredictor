import QtQuick 2.9
import QtQuick.Controls 2.2
import "../components"

Page {
    id: navigationPage

    SwipeView {
        id: navigationView

        currentIndex: tabBar.currentIndex
        anchors.fill: parent

        UserProfilePage {
            id: userProfilePage
        }

        TournamentsPage {
            id: tournamentsPage
        }

        TournamentCreatorPage {
            id: tournamentCreatorPage
        }

        FriendsPage {
            id: friendsPage
        }
    }

    header: TabBar {
        id: tabBar
        currentIndex: navigationView.currentIndex
        spacing: 0

        CheckableTabButton {
            text: qsTr("Profile")
        }

        CheckableTabButton {
            text: qsTr("Tournaments")
        }

        CheckableTabButton {
            text: qsTr("Creator")
        }

        CheckableTabButton {
            text: qsTr("Friends")
        }

        ClickableTabButton {
            text: qsTr("Logout")
            onClicked: mainWindow.popPage()
        }
    }
}
