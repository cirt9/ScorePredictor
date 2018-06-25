import QtQuick 2.9
import QtQuick.Controls 2.2
import "../components"

Page {
    id: tournamentsSearchPage

    Rectangle {
        id: tournamentsSearchArea
        color: mainWindow.colorA
        radius: 5
        anchors.fill: parent
        anchors.margins: 15

        SearchInput {
            id: searchInput
            width: parent.width * 0.3
            height: 30
            placeholderText: "Search Tournament"
            color: mainWindow.backgroundColor
            border.color: "black"
            textColor: mainWindow.fontColor
            radius: 10
            maximumLength: 30
            selectionColor: mainWindow.accentColor
            selectByMouse: true
            searchIcon: "qrc://assets/icons/icons/icons8_Search.png"
            clearIcon: "qrc://assets/icons/icons/icons8_Delete.png"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 35
        }
    }
}
