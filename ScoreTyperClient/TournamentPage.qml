import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: tournamentPage

    Text {
        text: qsTr("Tournament Page")
        anchors.centerIn: parent
    }

    Button {
        text: "test"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: navigationPage.popTournament()
    }
}
