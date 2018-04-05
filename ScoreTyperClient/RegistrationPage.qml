import QtQuick 2.9
import QtQuick.Controls 2.2
import "../components"

Page {
    id: registrationPage

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

        TextField {
            id: passwordConfirmationInput
            placeholderText: qsTr("Confirm password")
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
                id: registeringReplyText
                anchors.right: parent.right
                anchors.top: parent.top

                color: mainWindow.colorB
                font.pointSize: 10
            }
        }

        Item {
            height: 50
            width: 350

            Button {
                id: registerButton
                text: qsTr("REGISTER")

                width: 150
                font.pointSize: 16
                font.bold: true
                anchors.centerIn: parent

                onClicked: {
                    if(passwordInput.text === passwordConfirmationInput.text)
                        backend.registerAccount(nicknameInput.text, passwordInput.text)
                    else
                        registeringReplyText.text = qsTr("These passwords do not match.")
                }
            }

            TextButton {
                id: loginButton
                text: qsTr("LOGIN")
                textColor: mainWindow.colorA
                textColorHovered: mainWindow.colorC
                fontSize: 10
                bold: true

                anchors.top: registerButton.bottom
                anchors.horizontalCenter: registerButton.horizontalCenter

                onClicked: mainWindow.popPage()
            }
        }
    }
}

