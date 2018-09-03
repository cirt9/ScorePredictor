import QtQuick 2.9
import QtQuick.Controls 2.2
import "../components"

Page {
    id: mainPage

    FontLoader { id: titleFont; source: "qrc://assets/fonts/fonts/PROMESH-Regular.ttf" }

    Text {
        id: title
        text: "Score Predictor Server"
        color: mainWindow.fontColor
        font { family: titleFont.name; pixelSize: 50; bold: true}
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: mainPage.height * 0.1
    }

    SwitchButton {
        id: startStopServerButton
        width: 150
        height: 50
        color: mainWindow.colorA
        falseStateText: qsTr("START")
        trueStateText: qsTr("STOP")
        textColor: mainWindow.fontColor
        fontSize: 18
        fontBold: true
        radius: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5

        onClicked: {
            if(startStopServerButton.state)
            {
                server.closeServer()
                startStopServerButton.state = false
            }
            else
                startStopServerButton.state = server.startServer(5000)
        }
    }
}
