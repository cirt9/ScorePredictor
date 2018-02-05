import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: aboutPage

    Text {
        text: qsTr("About")
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Column {

        Text {
            text: "<a href='https://icons8.com/windows-icons'>Windows icons by Icons8</a>"
            onLinkActivated: Qt.openUrlExternally(link)
            font.pointSize: 20
        }

        Text {
            text: "Application created by <b> Bartłomiej Wójtowicz </b"
            font.pointSize: 20
        }

    }

    Button {
        text: "Back"
        anchors.centerIn: parent

        onClicked: mainWindow.popPage()
    }
}
