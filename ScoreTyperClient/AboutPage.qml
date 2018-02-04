import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: aboutPage

    Text {
        text: qsTr("About")
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        text: "Back"
        anchors.centerIn: parent

        onClicked: mainWindow.popPage()
    }
}
