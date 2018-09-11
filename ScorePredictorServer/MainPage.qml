import QtQuick 2.9
import QtQuick.Controls 2.2
import FileStream 1.0
import "../components"

Page {
    id: mainPage
    readonly property int minPort: 1024
    readonly property int maxPort: 65535

    FontLoader { id: titleFont; source: "qrc://assets/fonts/fonts/PROMESH-Regular.ttf" }

    Rectangle {
        id: headerBar
        width: parent.width
        height: 75
        color: mainWindow.colorA
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
    }

    Text {
        id: title
        text: "Score Predictor Server"
        color: mainWindow.fontColor
        font { family: titleFont.name; pixelSize: 40; bold: true}
        anchors.horizontalCenter: headerBar.horizontalCenter
        anchors.top: headerBar.top
        anchors.topMargin: 8
    }

    Text {
        id: creatorText
        text: qsTr("Created by") + " Bartłomiej Wójtowicz"
        color: mainWindow.fontColor
        font.pointSize: 10
        anchors.horizontalCenter: title.horizontalCenter
        anchors.top: title.bottom
    }

    ToolTipIconButton {
        id: hideButton
        width: 50
        height: 50
        iconSource: "qrc://assets/icons/icons/icons8_Minimize_Window.png"
        text: qsTr("Minimize To Tray")
        anchors.verticalCenter: headerBar.verticalCenter
        anchors.right: headerBar.right
        anchors.rightMargin: 15

        onClicked: mainWindow.hide()
    }

    Rectangle {
        id: logsAreaLeftRadiusDisabler
        width: logsArea.radius
        color: logsArea.color
        anchors.left: logsArea.left
        anchors.top: logsArea.top
        anchors.bottom: logsArea.bottom
    }

    Rectangle {
        id: logsArea
        width: (parent.width / 2) - 10
        color: mainWindow.colorA
        anchors.left: parent.left
        anchors.top: headerBar.bottom
        anchors.bottom: footerBar.top
        anchors.topMargin: 20
        anchors.bottomMargin: 20
        radius: 10

        Text {
            id: logsTitle
            text: qsTr("Logs")
            color: mainWindow.fontColor
            font.pointSize: 25
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
        }

        LogsWidget {
            id: logs
            backgroundColor: mainWindow.colorB
            backgroundRadius: 5
            itemColor: mainWindow.colorB
            fontColor: mainWindow.fontColor
            fontSize: 12
            dateTimeFontSize: 8
            itemRadius: 3
            itemOpacity: 0.5
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 40
            anchors.topMargin: 60

            Component.onCompleted: logs.addLog(qsTr("Welcome! If you want someone from global network to be " +
                                                    "able to connect to this server, remember to set port " +
                                                    "forwarding on the router. However for the local " +
                                                    "network it is not required."))
        }

        ToolTipIconButton {
            id: clearLogsButton
            width: 25
            height: 25
            iconSource: "qrc://assets/icons/icons/icons8_Broom.png"
            text: qsTr("Clear")
            enabled: logs.numberOfLogs > 1 ? true : false
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottomMargin: 5

            onClicked: logs.remove(1, logs.numberOfLogs - 1)
        }
    }

    Rectangle {
        id: startingMessageLeftRadiusDisabler
        width: startingMessageArea.radius
        color: startingMessageArea.color
        anchors.right: startingMessageArea.right
        anchors.top: startingMessageArea.top
        anchors.bottom: startingMessageArea.bottom
    }

    Rectangle {
        id: startingMessageArea
        width: (parent.width / 2) - 10
        color: mainWindow.colorA
        anchors.right: parent.right
        anchors.top: headerBar.bottom
        anchors.bottom: footerBar.top
        anchors.topMargin: 20
        anchors.bottomMargin: 20
        radius: 10

        FileStream {
            id: startingMessageFile
            source: "data/starting_message.txt"

            onReadingError: startingMessageInput.text = qsTr("Couldn't read starting message.")

            onWritingSuccess: {
                startingMessageResponseText.text = qsTr("Starting message has been saved.")
                animateShowingStartingMessageResponseText.start()
                startingMessageResponseTimer.restart()
            }

            onWritingError: {
                startingMessageResponseText.text = qsTr(error)
                animateShowingStartingMessageResponseText.start()
                startingMessageResponseTimer.restart()
            }
        }

        Text {
            id: startingMessageTitle
            text: qsTr("Starting Message")
            color: mainWindow.fontColor
            font.pointSize: 25
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
        }

        TextInputArea {
            id: startingMessageInput
            text: startingMessageFile.read()
            backgroundColor: mainWindow.colorB
            backgroundRadius: 5
            fontSize: 12
            fontColor: mainWindow.fontColor
            counterFontSize: 10
            maximumLength: 2500
            charactersCounterVisible: true
            scrollBarColor: mainWindow.colorB
            scrollBarWidth: 10
            scrollBarRadius: 10
            selectByMouse: true
            selectedTextColor: mainWindow.fontColor
            selectionColor: mainWindow.accentColor
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 40
            anchors.topMargin: 60
        }

        Text {
            id: startingMessageResponseText
            color: mainWindow.fontColor
            font.pointSize: 10
            font.bold: true
            opacity: 0.0
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.bottomMargin: 10

            NumberAnimation {
                id: animateShowingStartingMessageResponseText
                target: startingMessageResponseText
                property: "opacity"
                from: startingMessageResponseText.opacity
                to: 1.0
                duration: 200
                easing.type: Easing.Linear
            }

            NumberAnimation {
                id: animateHidingStartingMessageResponseText
                target: startingMessageResponseText
                property: "opacity"
                from: startingMessageResponseText.opacity
                to: 0.0
                duration: 200
                easing.type: Easing.Linear
            }

            Timer {
                id: startingMessageResponseTimer
                interval: 5000

                onTriggered: animateHidingStartingMessageResponseText.start()
            }
        }

        ToolTipIconButton {
            id: saveStartingMessageButton
            width: 25
            height: 25
            iconSource: "qrc://assets/icons/icons/icons8_Save.png"
            text: qsTr("Save Starting Message")
            enabled: startingMessageInput.text.length > 0 ? true : false
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottomMargin: 5

            onClicked: startingMessageFile.write(startingMessageInput.text)
        }
    }

    Rectangle {
        id: footerBar
        width: parent.width
        height: 75
        color: mainWindow.colorA
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 20
    }

    Rectangle {
        id: startStopServerButtonBackground
        width: 160
        height: 60
        color: mainWindow.backgroundColor
        radius: 15
        anchors.centerIn: footerBar

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
            autoSwitch: false
            anchors.centerIn: parent

            onClicked: {
                if(startStopServerButton.state)
                {
                    server.closeServer()
                    startStopServerButton.state = false
                }
                else
                {
                    portInput.focus = false
                    var chosenPort = parseInt(portInput.text)

                    if(chosenPort < minPort || chosenPort > maxPort || portInput.text.length === 0)
                    {
                        chosenPort = minPort
                        portInput.text = minPort
                    }

                    startStopServerButton.state = server.startServer(chosenPort)

                    if(!startStopServerButton.state)
                        logs.addLog(qsTr("The following error occured: ") + qsTr(server.lastError()))
                }
            }
        }
    }

    Text {
        id: portInputLabel
        text: qsTr("Port") + ":"
        color: mainWindow.fontColor
        font.pointSize: 14
        font.bold: true
        anchors.verticalCenter: footerBar.verticalCenter
        anchors.right: portInputArea.left
        anchors.rightMargin: 5
    }

    Item {
        id: portInputArea
        width: 70
        height: 20
        clip: true
        anchors.bottom: portInputLabel.bottom
        anchors.right: startStopServerButtonBackground.left
        anchors.rightMargin: 70

        MouseArea {
            id: portInputMouseArea
            hoverEnabled: true
            cursorShape: startStopServerButton.state ? Qt.ArrowCursor : Qt.IBeamCursor
            anchors.fill: parent
        }

        Text {
            id: portInputPlaceholder
            text: qsTr("Number")
            color: mainWindow.fontColor
            font.pointSize: 13
            font.bold: true
            opacity: 0.5
            visible: portInput.text.length === 0 && !portInput.activeFocus ? true : false
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
        }

        TextInput {
            id: portInput
            color: mainWindow.fontColor
            font.pointSize: 14
            font.bold: true
            maximumLength: 5
            selectByMouse: true
            selectedTextColor: mainWindow.fontColor
            selectionColor: mainWindow.accentColor
            verticalAlignment: Text.AlignVCenter
            validator : RegExpValidator { regExp: /([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])/ }
            enabled: startStopServerButton.state ? false : true
            activeFocusOnTab: true
            anchors.fill: parent
        }

        ToolTip {
            id: toolTip
            text: qsTr("Range") + ": [" + minPort + "-" + maxPort + "]"
            parent: portInputArea
            visible: portInputMouseArea.containsMouse
        }
    }

    Text {
        id: usersOnlineText
        text: qsTr("Users Online") + ": " + numberOfUsersOnline
        color: mainWindow.fontColor
        font.pointSize: 14
        font.bold: true
        anchors.verticalCenter: footerBar.verticalCenter
        anchors.left: startStopServerButtonBackground.right
        anchors.leftMargin: 70
        property int numberOfUsersOnline: 0
    }

    Rectangle {
        width: 16
        height: 16
        color: startStopServerButton.state ? mainWindow.acceptedColor : mainWindow.deniedColor
        border.width: 4
        border.color: mainWindow.backgroundColor
        radius: width / 2
        anchors.verticalCenter: footerBar.verticalCenter
        anchors.horizontalCenter: hideButton.horizontalCenter
    }

    Connections {
        target: server

        onStarted: logs.addLog(qsTr("Server started on port " + portInput.text + "."))
        onClosed: logs.addLog(qsTr("Server was closed."))

        onClientsIncreased: {
            usersOnlineText.numberOfUsersOnline += 1
            logs.addLog(qsTr("The user has connected to the server."))
        }

        onClientsDecreased: {
            usersOnlineText.numberOfUsersOnline -= 1
            logs.addLog(qsTr("The user has disconnected from the server."))
        }

        onAcceptError: logs.addLog(qsTr("Accepting the connection with the client resulted in an error."))
    }
}
