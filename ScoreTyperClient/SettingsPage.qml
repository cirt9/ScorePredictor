import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: settingsPage

    header: Label {
        text: qsTr("Settings")
        horizontalAlignment: Text.AlignHCenter
    }

    Button {
        text: "Back"
        anchors.centerIn: parent

        onClicked: mainWindow.popPage()
    }
}
