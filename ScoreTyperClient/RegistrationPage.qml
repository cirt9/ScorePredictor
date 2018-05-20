import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../components"

Page {
    id: registrationPage

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Text {
            id: title
            text: qsTr("Create your account")
            color: mainWindow.accentColor
            font.bold: true
            font.pointSize: 25
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 15
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            TextLineField {
                id: nicknameInput
                placeholderText: qsTr("Nickname")
                fontSize: 20
                selectByMouse: true
                maximumLength: 30
                textColor: "white"
                selectedTextColor: "white"
                selectionColor: mainWindow.accentColor
                underlineColorOnFocus: mainWindow.accentColor

                Layout.maximumWidth: 700
                Layout.minimumWidth: 350
                Layout.preferredWidth: registrationPage.width * 0.5
            }

            TextLineField {
                id: passwordInput
                placeholderText: qsTr("Password")
                fontSize: 20
                selectByMouse: true
                maximumLength: 30
                echoMode: TextInput.Password
                textColor: "white"
                selectedTextColor: "white"
                selectionColor: mainWindow.accentColor
                underlineColorOnFocus: mainWindow.accentColor

                Layout.maximumWidth: 700
                Layout.minimumWidth: 350
                Layout.preferredWidth: registrationPage.width * 0.5
            }

            TextLineField {
                id: passwordConfirmationInput
                placeholderText: qsTr("Confirm Password")
                fontSize: 20
                selectByMouse: true
                maximumLength: 30
                echoMode: TextInput.Password
                textColor: "white"
                selectedTextColor: "white"
                selectionColor: mainWindow.accentColor
                underlineColorOnFocus: mainWindow.accentColor

                Layout.maximumWidth: 700
                Layout.minimumWidth: 350
                Layout.preferredWidth: registrationPage.width * 0.5
            }
        }

        Text {
            id: registeringReplyText
            anchors.horizontalCenter: parent.horizontalCenter

            color: "red"
            font.pointSize: 10
        }

        Button {
            id: registerButton
            text: qsTr("REGISTER")

            Layout.maximumWidth: 400
            Layout.minimumWidth: 250
            Layout.preferredWidth: 300
            font.pointSize: 16
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                if(passwordInput.text === passwordConfirmationInput.text)
                    backend.registerAccount(nicknameInput.text, passwordInput.text)
                else
                    registeringReplyText.text = qsTr("These passwords do not match.")
            }
        }
    }

    Connections {
        target: packetProcessor
        onRegistrationReply: {
            if(replyState)
                registeringReplyText.color = "green"
            else
                registeringReplyText.color = "red"
            registeringReplyText.text = message
        }
    }
}

