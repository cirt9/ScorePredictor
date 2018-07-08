import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../components"

Page {
    id: tournamentNavigationPage

    Rectangle {
        id: tournamentHeader
        color: mainWindow.colorA
        height: 50
        radius: 5
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 15

        Text {
            id: tournamentName
            text: "World Cup 2018"
            color: mainWindow.fontColor
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
            font.pointSize: 10
            elide: Text.ElideRight
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.bottomMargin: 2
        }

        PopupList {
            id: roundsList
            width: 300
            height: 40
            color: mainWindow.colorB
            radius: 10
            textColor: mainWindow.fontColor
            fontSize: 18
            buttonColor: mainWindow.backgroundColor
            buttonIcon: "qrc://assets/icons/icons/icons8_Expand_Arrow.png"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 10
//
            Component.onCompleted: {
                roundsList.addItem("Item 1")
                roundsList.addItem("Item 2")
                roundsList.addItem("Item 3")
            }
//
        }
    }

    StackView {
       id: tournamentView
       initialItem: Rectangle {color: "black"}
       anchors.left: parent.left
       anchors.right: parent.right
       anchors.top: tournamentHeader.bottom
       anchors.bottom: parent.bottom
       anchors.margins: 15
   }
}
