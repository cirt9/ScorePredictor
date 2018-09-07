import QtQuick 2.9
import QtQuick.Controls 2.2
import "../components"

Page {
    id: connectingPage

    LoadingIndicator {
        id: connectingIndicator
        text: qsTr("Connecting")
        color: mainWindow.fontColor
        fontBold: true
        fontSize: 25
        running: true
        anchors.centerIn: parent
    }

    Text {
        id: stateMessage
        font.pointSize: 25
        font.bold: true
        anchors.centerIn: parent
        opacity: 0.0
        property bool hidden: true

        states: [
            State {
                name: "hidden"
                when: stateMessage.hidden

                PropertyChanges {
                    target: stateMessage
                    opacity: 0.0
                }
            },
            State {
                name: "visible"
                when: !stateMessage.hidden

                PropertyChanges {
                    target: stateMessage
                    opacity: 1.0
                }
            }
        ]

        transitions: [
            Transition {
                from: "hidden"; to: "visible"; reversible: true
                NumberAnimation {
                    properties: "opacity"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        ]
    }

    Column {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10

        Button {
            id: connectButton
            text: qsTr("Connect")
            width: 260
            enabled: false

            onClicked: {
                disableButtons()
                stateMessage.hidden = true
                connectingIndicator.running = true
                backend.connectToServer()
            }
        }

        Row {
            spacing: 10

            Button {
                id: settingsButton
                text: qsTr("Settings")
                width: 80
                enabled: false

                onClicked: mainWindow.pushPage("qrc:/pages/SettingsPage.qml")
            }

            Button {
                id: aboutButton
                text: qsTr("About")
                width: 80
                enabled: false

                onClicked: mainWindow.pushPage("qrc:/pages/AboutPage.qml")
            }

            Button {
                id: quitButton
                text: qsTr("Quit")
                width: 80

                onClicked: mainWindow.closeApp()
            }
        }
    }

    Connections {
        target: serverConnection

        onConnected: {
            connectingIndicator.running = false
            mainWindow.pushPage("qrc:/pages/LoggingPage.qml")
            backend.downloadStartingMessage()
        }

        onServerClosed: {
            mainWindow.popToInitialPage()
            enableButtons()
            displayStateMessage(qsTr("Server Closed"), mainWindow.deniedColor)
        }

        onServerNotFound: {
            enableButtons()
            connectingIndicator.running = false
            displayStateMessage(qsTr("Server Not Found"), mainWindow.deniedColor)
        }

        onConnectionRefused: {
            enableButtons()
            connectingIndicator.running = false
            displayStateMessage(qsTr("Could Not Connect To The Server"), mainWindow.deniedColor)
        }

        onNetworkError: {
            mainWindow.popToInitialPage()
            enableButtons()
            displayStateMessage(qsTr("Network Error"), mainWindow.deniedColor)
        }

        onUnidentifiedError: {
            mainWindow.popToInitialPage()
            enableButtons()
            connectingIndicator.running = false
            displayStateMessage(qsTr("An Error Occured"), mainWindow.deniedColor)
        }

        onDisconnected: {
            mainWindow.popToInitialPage()
            enableButtons()

            if(stateMessage.hidden)
                displayStateMessage(qsTr("Disconnected"), mainWindow.fontColor)
        }
    }

    function enableButtons()
    {
        connectButton.enabled = true
        settingsButton.enabled = true
        aboutButton.enabled = true
    }

    function disableButtons()
    {
        connectButton.enabled = false
        settingsButton.enabled = false
        aboutButton.enabled = false
    }

    function displayStateMessage(text, color)
    {
        stateMessage.color = color
        stateMessage.text = text
        stateMessage.hidden = false
    }
}
