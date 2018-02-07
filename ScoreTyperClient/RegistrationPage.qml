import QtQuick 2.9
import QtQuick.Controls 2.2
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
                id: loggingReplyText
                anchors.right: parent.right
                anchors.top: parent.top

                color: "#D1474E"
                font.pointSize: 10
            }
        }

        Item {
            height: 50
            width: 350

            Button {
                id: loginButton
                text: qsTr("REGISTER")

                width: 150
                font.pointSize: 16
                font.bold: true
                anchors.centerIn: parent
            }

            TextButton {
                id: registerButton
                text: qsTr("LOGIN")
                textColor: "#ccc288"
                textColorHovered: "#E6AF33"
                fontSize: 10
                bold: true

                anchors.top: loginButton.bottom
                anchors.horizontalCenter: loginButton.horizontalCenter

                onClicked: mainWindow.popPage()
            }
        }
    }
}

