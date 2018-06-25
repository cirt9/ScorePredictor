import QtQuick 2.9
import QtQuick.Controls 2.2
import "../components"

Page {
    id: navigationPage

    Item {
        id: headerBar
        height: 40
        width: parent.width
        anchors.left: parent.left
        anchors.top: parent.top

        Row {
            id: navigationBar
            spacing: 10
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 30
            property int previousIndex: 0
            property int currentIndex: 0

            NavigationButton {
                text: qsTr("Profile")
                textColor: mainWindow.fontColor
                underlineColor: mainWindow.accentColor
                uncheckedFontSize: 12
                checkedFontSize: 14
                checked: true

                onClicked: changePage(0)
            }

            NavigationButton {
                text: qsTr("Tournaments")
                textColor: mainWindow.fontColor
                underlineColor: mainWindow.accentColor
                uncheckedFontSize: 12
                checkedFontSize: 14

                onClicked: changePage(1)
            }

            NavigationButton {
                text: qsTr("Tournament Creator")
                textColor: mainWindow.fontColor
                underlineColor: mainWindow.accentColor
                uncheckedFontSize: 12
                checkedFontSize: 14

                onClicked: changePage(2)
            }
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 30

            IconButton {
                id: logoutButton
                width: 30
                height: 30
                iconSource: "qrc://assets/icons/icons/icons8_Exit.png"
                color: mainWindow.colorA

                onClicked: mainWindow.popPage()
            }
        }
    }

    SwipeView {
        id: navigationView
        width: parent.width
        height: parent.height - headerBar.height
        anchors.left: parent.left
        anchors.top: headerBar.bottom

        onCurrentIndexChanged: changePage(currentIndex)

        UserProfilePage {
            id: userProfilePage

            Component.onCompleted: backend.downloadUserProfile(currentUser.username)
        }

        StackView {
           id: tournamentView
           initialItem: TournamentsSearchPage {}
       }

        TournamentCreatorPage {
            id: tournamentCreatorPage
        }
    }

    function changePage(index)
    {
        navigationBar.previousIndex = navigationBar.currentIndex
        navigationBar.currentIndex = index
        navigationBar.children[navigationBar.previousIndex].checked = false
        navigationBar.children[navigationBar.currentIndex].checked = true
        navigationView.currentIndex = navigationBar.currentIndex
    }

    function pushTournament(page) {
        tournamentView.push(page)
    }

    function popTournament() {
        tournamentView.pop()
    }
}
