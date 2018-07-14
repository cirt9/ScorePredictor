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

                onClicked: changePage(userProfilePage.index)
            }

            NavigationButton {
                text: qsTr("Tournaments")
                textColor: mainWindow.fontColor
                underlineColor: mainWindow.accentColor
                uncheckedFontSize: 12
                checkedFontSize: 14

                onClicked: changePage(tournamentView.index)
            }

            NavigationButton {
                text: qsTr("Tournament Creator")
                textColor: mainWindow.fontColor
                underlineColor: mainWindow.accentColor
                uncheckedFontSize: 12
                checkedFontSize: 14

                onClicked: changePage(tournamentCreatorPage.index)
            }
        }

        Row {
            spacing: 10
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 30

            IconButtonHover {
                id: refreshButton
                width: 30
                height: 30
                iconSource: "qrc://assets/icons/icons/icons8_Refresh.png"
                color: mainWindow.colorA

                onClicked: {
                    if(navigationView.currentIndex === userProfilePage.index)
                        userProfilePage.refresh()
                    else if(navigationView.currentIndex === tournamentView.index)
                        tournamentView.currentItem.refresh()
                    else if(navigationView.currentIndex === tournamentCreatorPage.index)
                        tournamentCreatorPage.refresh()
                }
            }

            IconButtonHover {
                id: logoutButton
                width: 30
                height: 30
                iconSource: "qrc://assets/icons/icons/icons8_Exit.png"
                color: mainWindow.colorA

                onClicked: logout()
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
            readonly property int index: 0
        }

        StackView {
           id: tournamentView
           initialItem: TournamentsSearchPage {}
           readonly property int index: 1
       }

        TournamentCreatorPage {
            id: tournamentCreatorPage
            readonly property int index: 2
        }
    }

    function logout()
    {
        mainWindow.popPage()
        currentUser.reset()
    }

    function changePage(index)
    {
        navigationBar.previousIndex = navigationBar.currentIndex
        navigationBar.currentIndex = index
        navigationBar.children[navigationBar.previousIndex].checked = false
        navigationBar.children[navigationBar.currentIndex].checked = true
        navigationView.currentIndex = navigationBar.currentIndex
    }

    function pushTournament(page)
    {
        if(tournamentView.depth > 1)
            popTournament()

        tournamentView.push(page)
    }

    function popTournament()
    {
        while(tournamentView.depth > 1)
            tournamentView.pop()
    }
}
