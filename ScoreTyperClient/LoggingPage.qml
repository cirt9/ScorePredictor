import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import "../components"

Page {
    id: loggingPage

    FontLoader { id: titleFont; source: "qrc://assets/fonts/fonts/PROMESH-Regular.ttf" }

    Text {
        id: title
        text: "Score Typer"
        color: "#ccc288"
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
            height: 25

            Text {
                id: loggingReplyText
                anchors.right: parent.right
                anchors.top: parent.top

                color: "#A60000"
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

                onClicked: {
                    if(backend.login(nicknameInput.text, passwordInput.text))
                    {
                        console.log(true)
                    }
                    else
                    {
                        console.log(false)
                    }
                }
            }

            Text {
                id: registerButton
                text: "REGISTER"
                color: "#ccc288"
                font.pointSize: 12
                font.bold: true

                anchors.top: loginButton.bottom
                anchors.horizontalCenter: loginButton.horizontalCenter
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
                imageSource: "qrc://assets/icons/icons/icons8_Settings.png"
                onClicked: mainWindow.pushPage("qrc:/pages/SettingsPage.qml")
            }

            IconButton {
                id: aboutButton
                width: 30
                height: 30
                imageSource: "qrc://assets/icons/icons/icons8_About.png"
                onClicked: mainWindow.pushPage("qrc:/pages/AboutPage.qml")
            }

            IconButton {
                id: quitButton
                width: 30
                height: 30
                imageSource: "qrc://assets/icons/icons/icons8_Shutdown.png"
                onClicked: Qt.quit()
            }
        }
    }
}
