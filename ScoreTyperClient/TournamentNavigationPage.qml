import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../components"

Page {
    id: tournamentNavigationPage

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
            Layout.preferredHeight: 50

            Text {
                id: tournamentName
                text: "World Cup 2018"
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
                text: "by WorldCupCreator"
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

            PopupList {
                id: roundsList
                width: 250
                height: 40
                color: mainWindow.colorB
                radius: 10
                textColor: mainWindow.fontColor
                fontSize: 18
                buttonColor: mainWindow.backgroundColor
                buttonIcon: "qrc://assets/icons/icons/icons8_Expand_Arrow.png"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5

                Component.onCompleted: {
                    roundsList.addItem(qsTr("Leaderboards"))
                    roundsList.addItem("Round 1")
                    roundsList.addItem("Round 2")
                }
            }
        }

        StackView {
           id: tournamentView
           initialItem: TournamentLeaderbordsPage {}

           Layout.fillHeight: true
           Layout.fillWidth: true
        }
    }

    Component {
        id: addRoundButtonItem

        IconButton {
            width: height
            iconSource: "qrc://assets/icons/icons/icons8_Add_New.png"
            margins: 1
            marginsOnPressed: 5
        }
    }

    Component {
        id: closeButtonItem

        DefaultButton {
            width: 150
            color: mainWindow.colorB
            text: "Close"
            fontSize: 20
            textColor: mainWindow.fontColor
            radius: 10
            anchors.right: tournamentHeader.right
            anchors.top: tournamentHeader.top
            anchors.bottom: tournamentHeader.bottom
            anchors.margins: 5
        }
    }

    Component.onCompleted: {
        if(currentUser.username === "John")
            createHostTools()
    }

    function createHostTools()
    {
        var closeButton = closeButtonItem.createObject(tournamentHeader)

        var addRoundButton = addRoundButtonItem.createObject(tournamentHeader)
        addRoundButton.anchors.right = closeButton.left
        addRoundButton.anchors.top = tournamentHeader.top
        addRoundButton.anchors.bottom = tournamentHeader.bottom
        addRoundButton.anchors.rightMargin = 3

        roundsList.anchors.right = addRoundButton.left
        roundsList.anchors.rightMargin = 0
    }
}
