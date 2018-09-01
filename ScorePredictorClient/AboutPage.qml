import QtQuick 2.9
import QtQuick.Controls 2.2
import FileStream 1.0

Page {
    id: aboutPage

    FileStream {
        id: aboutFile
        source: ":/txt/about.txt"
    }

    Text {
        id: title
        text: qsTr("About")
        color: mainWindow.fontColor
        font.pointSize: 30
        font.bold: true
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
    }

    TextEdit {
        id: aboutText
        text: aboutFile.read()
        color: mainWindow.fontColor
        width: 800
        height: 450
        font.pointSize: 14
        readOnly: true
        wrapMode: TextEdit.Wrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        anchors.centerIn: parent
    }

    MouseArea {
        id: icons8LinkPointingHand
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        anchors.fill: icons8Link
    }

    Text {
        id: icons8Link
        text: "<a href='https://icons8.com/'>" + qsTr("Gorgeous icons by Icons8") + "</a>"
        linkColor: mainWindow.fontColor
        font.pointSize: 20
        anchors.bottom: backButton.top
        anchors.horizontalCenter: backButton.horizontalCenter
        anchors.bottomMargin: 10

        onLinkActivated: Qt.openUrlExternally(link)
    }

    Button {
        id: backButton
        text: qsTr("Back")
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10

        onClicked: mainWindow.popPage()
    }
}
