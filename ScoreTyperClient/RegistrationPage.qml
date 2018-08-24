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
                    color: mainWindow.deniedColor
                    font.pointSize: 8
                    anchors.right: parent.right
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
                    color: mainWindow.deniedColor
                    font.pointSize: 8
                    anchors.right: parent.right
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
                    color: mainWindow.deniedColor
                    font.pointSize: 8
                    anchors.right: parent.right
                }
            }
        }

        ResponseText {
            id: registeringResponseText
            acceptedColor: mainWindow.acceptedColor
            deniedColor: mainWindow.deniedColor
            fontSize: 8
            bold: true
            visibilityTime: 7000
            showingDuration: 150
            hidingDuration: 500
            anchors.horizontalCenter: parent.horizontalCenter

            Layout.preferredWidth: 300
            Layout.preferredHeight: 30
        }

        Button {
            id: registerButton
            text: qsTr("REGISTER")
            font.pointSize: 16
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter

            Layout.maximumWidth: 400
            Layout.minimumWidth: 250
            Layout.preferredWidth: 300

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
                clear()
                registeringResponseText.showAcceptedResponse(message)
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

    function clear()
    {
        nicknameInput.text = ""
        passwordInput.text = ""
        passwordConfirmationInput.text = ""
    }
}
