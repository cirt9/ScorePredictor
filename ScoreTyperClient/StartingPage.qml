import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

Page {
    id: startingPage

    Text {
        id: title
        text: "Score Typer"
        font.pointSize: 60

        anchors.horizontalCenter: inputContainer.horizontalCenter
        anchors.bottom: inputContainer.top
    }

    Item {
        id: inputContainer

        width: parent.width / 2
        height: parent.height / 2
        anchors.centerIn: parent

        Column {
            anchors.centerIn: parent
            spacing: 5

            Row {
                TextField {
                    id: nicknameInput
                    placeholderText: "Nickname"
                    selectByMouse: true
                    maximumLength: 20

                    font.pointSize: 20
                    width: 300
                }
            }

            Row {
                TextField {
                    id: passwordInput
                    placeholderText: "Password"
                    echoMode: TextInput.Password
                    selectByMouse: true

                    width: 300
                    maximumLength: 20
                    font.pointSize: 20
                }
            }

            Row {
                Item {
                    height: 50
                    width: 300

                    Row {
                        anchors.centerIn: parent
                        spacing: 10

                        Button {
                            id: loginButton
                            text: qsTr("LOGIN")

                            width: 100
                        }

                        Button {
                            id: registerButton
                            text: qsTr("REGISTER")

                            width: 100
                        }
                    }
                }
            }
        }
    }

    Column {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 2

            Button {
                id: settingsButton
                text: qsTr("Settings")

                width: 100

                onClicked: mainWindow.pushPage("qrc:/SettingsPage.qml")
            }

            Button {
                id: aboutButton
                text: qsTr("About")

                width: 100

                onClicked: mainWindow.pushPage("qrc:/AboutPage.qml")
            }
    }

}
