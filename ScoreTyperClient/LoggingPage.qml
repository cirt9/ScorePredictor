import QtQuick 2.9
import QtQuick.Controls 2.2
import "../components"

Page {
    id: loggingPage

    FontLoader { id: titleFont; source: "qrc://assets/fonts/fonts/PROMESH-Regular.ttf" }

    Text {
        id: title
        text: "Score Typer"
        color: mainWindow.colorA
        font { family: titleFont.name; pixelSize: 90; bold: true}

        y: parent.height / 30
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: inputContainer
        color: "white"
        opacity: 0.1
        radius: 10

        width: 500
        height: 325
        anchors.centerIn: parent
    }

    Column {
        anchors.centerIn: inputContainer
        spacing: 5

        TextField {
            id: nicknameInput
            placeholderText: qsTr("Nickname")
            selectByMouse: true
            maximumLength: 20

            font.pointSize: 15
            width: 350
        }

        TextField {
            id: passwordInput
            placeholderText: qsTr("Password")
            echoMode: TextInput.Password
            selectByMouse: true

            width: 350
            maximumLength: 30
            font.pointSize: 15
        }

        Item {
            width: 350
            height: 15

            Text {
                id: loggingReplyText
                anchors.centerIn: parent

                color: mainWindow.colorB
                font.pointSize: 10
            }
        }

        Item {
            height: 50
            width: 350

            Button {
                id: loginButton
                text: qsTr("LOGIN")

                width: 150
                font.pointSize: 16
                font.bold: true
                anchors.centerIn: parent

                onClicked: backend.login(nicknameInput.text, passwordInput.text)
            }

            TextButton {
                id: registerButton
                text: qsTr("REGISTER")
                textColor: mainWindow.colorA
                textColorHovered: mainWindow.colorC
                fontSize: 10
                bold: true

                anchors.top: loginButton.bottom
                anchors.horizontalCenter: loginButton.horizontalCenter

                onClicked: mainWindow.pushPage("qrc:/pages/RegistrationPage.qml")
            }
        }
    }

    Item {
        id: navigationIconsContainer
        width: 110
        height: 50
        anchors.top: inputContainer.bottom
        anchors.right: inputContainer.right

        Row {
            anchors.centerIn: parent
            spacing: 10

            IconButton {
                id: settingsButton
                width: 30
                height: 30
                iconSource: "qrc://assets/icons/icons/icons8_Settings.png"

                onClicked: mainWindow.pushPage("qrc:/pages/SettingsPage.qml")
            }

            IconButton {
                id: aboutButton
                width: 30
                height: 30
                iconSource: "qrc://assets/icons/icons/icons8_About.png"

                onClicked: mainWindow.pushPage("qrc:/pages/AboutPage.qml")
            }

            IconButton {
                id: quitButton
                width: 30
                height: 30
                iconSource: "qrc://assets/icons/icons/icons8_Shutdown.png"

                onClicked: mainWindow.close()
            }
        }
    }

    Connections {
        target: packetProcessor
        onLoggingReply: {
            if(replyState)
            {
                currentUser.username = message;
                mainWindow.pushPage("qrc:/pages/NavigationPage.qml")
            }
            else
                loggingReplyText.text = message;
        }
    }
}
