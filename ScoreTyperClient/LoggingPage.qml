import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

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

        Row {
            TextField {
                id: nicknameInput
                placeholderText: "Nickname"
                selectByMouse: true
                maximumLength: 20

                font.pointSize: 15
                width: 350
            }
        }

        Row {
            TextField {
                id: passwordInput
                placeholderText: "Password"
                echoMode: TextInput.Password
                selectByMouse: true

                width: 350
                maximumLength: 25
                font.pointSize: 15
            }
        }

        Row {
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
        }

        Row {
            Item {
                height: 50
                width: 350

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    Button {
                        id: loginButton
                        text: qsTr("LOGIN")

                        width: 150
                        font.pointSize: 20

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

                    Button {
                        id: registerButton
                        text: qsTr("REGISTER")

                        width: 150
                        font.pointSize: 20
                    }
                }
            }
        }

        Row {

            Item {
                height: 50
                width: 350

                Row {
                    anchors.centerIn: parent
                    spacing: 5

                    Button {
                        id: settingsButton
                        text: qsTr("Settings")

                        width: 100

                        onClicked: mainWindow.pushPage("qrc:/pages/SettingsPage.qml")
                    }

                    Button {
                        id: aboutButton
                        text: qsTr("About")

                        width: 100

                        onClicked: mainWindow.pushPage("qrc:/pages/AboutPage.qml")
                    }

                    Button {
                        id: quitButton
                        text: qsTr("Quit")

                        width: 100

                        onClicked: Qt.quit()
                    }
                }
            }
        }
    }
}
