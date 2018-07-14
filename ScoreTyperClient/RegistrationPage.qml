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
            color: mainWindow.fontColor
            font.bold: true
            font.pointSize: 25
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 15
        }

        ColumnLayout {
            anchors.centerIn: parent

            ColumnLayout {

                TextLineField {
                    id: nicknameInput
                    placeholderText: qsTr("Nickname")
                    fontSize: 20
                    selectByMouse: true
                    maximumLength: 30
                    textColor: mainWindow.fontColor
                    selectedTextColor: mainWindow.fontColor
                    selectionColor: mainWindow.accentColor
                    underlineColorOnFocus: mainWindow.accentColor

                    Layout.maximumWidth: 700
                    Layout.minimumWidth: 350
                    Layout.preferredWidth: registrationPage.width * 0.5

                    onFocused: nicknameInputReplyText.text = ""
                }

                Text {
                    id: nicknameInputReplyText
                    anchors.right: parent.right
                    color: mainWindow.deniedColor
                    font.pointSize: 8
                }
            }

            ColumnLayout {

                TextLineField {
                    id: passwordInput
                    placeholderText: qsTr("Password")
                    fontSize: 20
                    selectByMouse: true
                    maximumLength: 30
                    echoMode: TextInput.Password
                    textColor: mainWindow.fontColor
                    selectedTextColor: mainWindow.fontColor
                    selectionColor: mainWindow.accentColor
                    underlineColorOnFocus: mainWindow.accentColor

                    Layout.maximumWidth: 700
                    Layout.minimumWidth: 350
                    Layout.preferredWidth: registrationPage.width * 0.5

                    onFocused: passwordInputReplyText.text = ""
                }

                Text {
                    id: passwordInputReplyText
                    anchors.right: parent.right
                    color: mainWindow.deniedColor
                    font.pointSize: 8
                }
            }

            ColumnLayout {

                TextLineField {
                    id: passwordConfirmationInput
                    placeholderText: qsTr("Confirm Password")
                    fontSize: 20
                    selectByMouse: true
                    maximumLength: 30
                    echoMode: TextInput.Password
                    textColor: mainWindow.fontColor
                    selectedTextColor: mainWindow.fontColor
                    selectionColor: mainWindow.accentColor
                    underlineColorOnFocus: mainWindow.accentColor

                    Layout.maximumWidth: 700
                    Layout.minimumWidth: 350
                    Layout.preferredWidth: registrationPage.width * 0.5

                    onFocused: passwordConfirmationInputReplyText.text = ""
                }

                Text {
                    id: passwordConfirmationInputReplyText
                    anchors.right: parent.right
                    color: mainWindow.deniedColor
                    font.pointSize: 8
                }
            }
        }

        Text {
            id: registeringResponseText
            color: mainWindow.acceptedColor
            font.pointSize: 8
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0
        }

        Timer {
            id: registeringResponseTextTimer
            interval: 5000

            onTriggered: animateHidingRegisteringResponseText.start()
        }

        NumberAnimation {
           id: animateShowingRegisteringResponseText
           target: registeringResponseText
           properties: "opacity"
           from: registeringResponseText.opacity
           to: 1.0
           duration: 150
           easing {type: Easing.Linear;}
        }

        NumberAnimation {
           id: animateHidingRegisteringResponseText
           target: registeringResponseText
           properties: "opacity"
           from: registeringResponseText.opacity
           to: 0.0
           duration: 500
           easing {type: Easing.Linear;}
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
                var formFilledCorrectly = true

                if(nicknameInput.text.length === 0)
                {
                    nicknameInput.markBadData()
                    nicknameInputReplyText.text = qsTr("Enter a nickname")
                    formFilledCorrectly = false
                }
                if(passwordInput.text.length === 0)
                {
                    passwordInput.markBadData()
                    passwordInputReplyText.text = qsTr("Enter a password")
                    formFilledCorrectly = false
                }
                if(passwordConfirmationInput.text.length === 0)
                {
                    passwordConfirmationInput.markBadData()
                    passwordConfirmationInputReplyText.text = qsTr("Confirm a password")
                    formFilledCorrectly = false
                }
                else if(passwordInput.text !== passwordConfirmationInput.text)
                {
                    passwordConfirmationInputReplyText.text = qsTr("Those passwords didn't match")
                    passwordConfirmationInput.markBadData()
                    formFilledCorrectly = false
                }
                if(formFilledCorrectly)
                {
                    busyTimer.restart()
                    mainWindow.startBusyIndicator()
                    loggingPage.blockRegistrationPopup()
                    backend.registerAccount(nicknameInput.text, passwordInput.text)
                }
            }
        }
    }

    Connections {
        target: packetProcessor
        onRegistrationReply: {
            busyTimer.stop()
            loggingPage.unblockRegistrationPopup()
            mainWindow.stopBusyIndicator()

            if(replyState)
            {
                registeringResponseText.text = message
                animateShowingRegisteringResponseText.start()
                registeringResponseTextTimer.restart()
            }
            else
            {
                nicknameInput.markBadData()
                nicknameInputReplyText.text = message
            }
        }
    }

    Timer {
        id: busyTimer
        interval: mainWindow.serverResponseWaitingTimeMsec

        onTriggered: {
            loggingPage.unblockRegistrationPopup()
            mainWindow.stopBusyIndicator()
            backend.disconnectFromServer()
            mainWindow.showErrorPopup(qsTr("Connection lost. Try again later."))
        }
    }
}
