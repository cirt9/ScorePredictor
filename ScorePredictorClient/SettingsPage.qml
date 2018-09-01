import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: settingsPage

    Text {
        text: qsTr("Settings")
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        text: "Back"
        anchors.centerIn: parent

        onClicked: mainWindow.popPage()
    }
}
