import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: connectingPage

    Text {
        text: qsTr("Connecting...")
        font.pointSize: 30
        color: "white"
        anchors.centerIn: parent
    }

    Column {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 30

        Button {
            id: connectButton
            text: "Connect"
            width: 210
            enabled: false

            onClicked: {
                disableButtons()
                backend.connectToServer()
            }
        }

        Row {
            spacing: 10

            Button {
                id: settingsButton
                text: "Settings"
                width: 100
                enabled: false

                onClicked: {
                    mainWindow.pushPage("qrc:/pages/SettingsPage.qml")
                }
            }

            Button {
                id: quitButton
                text: "Quit"
                width: 100

                onClicked: mainWindow.closeApp()
            }
        }
    }

    Connections {
        target: clientWrapper
        onConnected: mainWindow.pushPage("qrc:/pages/LoggingPage.qml")
        onServerClosed: mainWindow.popToInitialPage()
        onServerNotFound: enableButtons()
        onConnectionRefused: enableButtons()
        onNetworkError: {
            mainWindow.popToInitialPage()
            enableButtons()
        }
        onUnidentifiedError: {
            mainWindow.popToInitialPage()
            enableButtons()
        }
    }

    function enableButtons() {
        connectButton.enabled = true
        settingsButton.enabled = true
    }

    function disableButtons() {
        connectButton.enabled = false
        settingsButton.enabled = false
    }
}
