import QtQuick 2.9
import QtQuick.Controls 2.2
import "../components"

Page {
    id: root

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

        CustomTabButton {
            text: qsTr("Profile")
        }

        CustomTabButton {
            text: qsTr("Tournaments")
        }

        CustomTabButton {
            text: qsTr("Creator")
        }

        CustomTabButton {
            text: qsTr("Friends")
        }

        CustomTabButton {
            text: qsTr("Logout")
            checkable: false
            onClicked: mainWindow.popPage()
        }
    }
}
