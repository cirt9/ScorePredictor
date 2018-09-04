import QtQuick 2.9
import QtQuick.Controls 2.2
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
    }

    Rectangle {
        id: messageForUsersLeftRadiusDisabler
        width: messageForUsersArea.radius
        color: messageForUsersArea.color
        anchors.right: messageForUsersArea.right
        anchors.top: messageForUsersArea.top
        anchors.bottom: messageForUsersArea.bottom
    }

    Rectangle {
        id: messageForUsersArea
        width: (parent.width / 2) - 10
        color: mainWindow.colorA
        anchors.right: parent.right
        anchors.top: headerBar.bottom
        anchors.bottom: footerBar.top
        anchors.topMargin: 20
        anchors.bottomMargin: 20
        radius: 10
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
            cursorShape: Qt.IBeamCursor
            anchors.fill: parent
        }

        Text {
            id: portInputPlaceholder
            text: "00000"
            color: mainWindow.fontColor
            font.pointSize: 14
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
        property int numberOfUsersOnline: 50
    }

    Rectangle {
        width: 16
        height: 16
        color: mainWindow.deniedColor
        border.width: 4
        border.color: mainWindow.backgroundColor
        radius: width / 2
        anchors.verticalCenter: footerBar.verticalCenter
        anchors.horizontalCenter: hideButton.horizontalCenter
    }
}
