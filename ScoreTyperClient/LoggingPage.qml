import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../components"

Page {
    id: loggingPage

    FontLoader { id: titleFont; source: "qrc://assets/fonts/fonts/PROMESH-Regular.ttf" }

    ColumnLayout {
        anchors.fill: parent

        GroupBox {
            id: mainBox
            Layout.preferredWidth: 850
            Layout.preferredHeight: 600
            padding: 0
            anchors.centerIn: parent

            background: Rectangle {
                width: parent.width
                height: parent.height
                color: mainWindow.colorA
            }

            label: Rectangle {
                color: mainWindow.backgroundColor
                width: parent.width * 0.5
                height: title.font.pixelSize * 1.25
                radius: 5
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.top
                anchors.bottomMargin: -height/2

                Text {
                    id: title
                    text: "Score Typer"
                    color: mainWindow.colorA
                    font { family: titleFont.name; pixelSize: 50; bold: true}
                    anchors.centerIn: parent
                }
            }

            Item {
                id: loginBox
                width: parent.width / 2
                height: parent.height / 2
                anchors.centerIn: parent

                Item {
                    id: inputArea
                    width: parent.width
                    height: nicknameInput.height + passwordInput.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: height * 0.1

                    Column {
                        spacing: 2

                        TextLineField {
                            id: nicknameInput
                            placeholderText: qsTr("Nickname")
                            fontSize: 20
                            selectByMouse: true
                            maximumLength: 30
                            width: inputArea.width
                            textColor: mainWindow.fontColor
                            selectedTextColor: mainWindow.fontColor
                            selectionColor: mainWindow.accentColor
                            underlineColorOnFocus: mainWindow.accentColor
                            underlineColorBadData: mainWindow.deniedColor
                        }

                        TextLineField {
                            id: passwordInput
                            placeholderText: qsTr("Password")
                            fontSize: 20
                            echoMode: TextInput.Password
                            selectByMouse: true
                            maximumLength: 30
                            width: inputArea.width
                            textColor: mainWindow.fontColor
                            selectedTextColor: mainWindow.fontColor
                            selectionColor: mainWindow.accentColor
                            underlineColorOnFocus: mainWindow.accentColor
                            underlineColorBadData: mainWindow.deniedColor
                        }
                    }
                }

                Rectangle {
                    id: loggingReplyArea
                    color: mainWindow.backgroundColor
                    width: parent.width
                    height: loggingReplyText.font.pointSize * 3
                    radius: 3
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: inputArea.bottom
                    anchors.topMargin: height

                    Text {
                        id: loggingReplyText
                        color: mainWindow.deniedColor
                        font.pointSize: 10
                        opacity: 0
                        anchors.centerIn: parent
                    }

                    Timer {
                        id: replyTextTimer
                        interval: 10000

                        onTriggered: animateHidingLoggingReply.start()
                    }

                    NumberAnimation {
                       id: animateShowingLoggingReply
                       target: loggingReplyText
                       properties: "opacity"
                       from: loggingReplyText.opacity
                       to: 1.0
                       duration: 150
                       easing {type: Easing.Linear;}
                    }

                    NumberAnimation {
                       id: animateHidingLoggingReply
                       target: loggingReplyText
                       properties: "opacity"
                       from: loggingReplyText.opacity
                       to: 0.0
                       duration: 500
                       easing {type: Easing.Linear;}
                    }
                }

                Button {
                    id: loginButton
                    text: qsTr("LOGIN")
                    width: parent.width / 2
                    font.pointSize: 16
                    font.bold: true
                    anchors.top: loggingReplyArea.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: loggingReplyArea.height / 2

                    onClicked: {
                        if(nicknameInput.text.length === 0 && passwordInput.text.length === 0)
                        {
                            loggingReplyText.text = qsTr("Enter a nickname and a password")
                            nicknameInput.markBadData()
                            passwordInput.markBadData()
                            animateShowingLoggingReply.start()
                            replyTextTimer.restart()
                        }
                        else if(nicknameInput.text.length === 0)
                        {
                            loggingReplyText.text = qsTr("Enter a nickname")
                            nicknameInput.markBadData()
                            animateShowingLoggingReply.start()
                            replyTextTimer.restart()
                        }
                        else if(passwordInput.text.length === 0)
                        {
                            loggingReplyText.text = qsTr("Enter a password")
                            passwordInput.markBadData()
                            animateShowingLoggingReply.start()
                            replyTextTimer.restart()
                        }
                        else
                        {
                            loggingReplyText.opacity = 0
                            busyTimer.restart()
                            blockLoggingPage()
                            mainWindow.startBusyIndicator()
                            backend.login(nicknameInput.text, passwordInput.text)
                        }
                    }
                }
            }

            Rectangle {
                id: navigationArea
                width: parent.width
                height: parent.height * 0.1
                color: mainWindow.colorB
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                TextButton {
                    id: registerButton
                    text: qsTr("REGISTER")
                    textColor: mainWindow.accentColor
                    fontSize: 15
                    bold: true
                    anchors.centerIn: parent

                    onClicked: registrationPopup.open()
                }

                Item {
                    id: navigationIconsContainer
                    width: parent.width * 0.20
                    height: parent.height
                    anchors.verticalCenter: navigationArea.verticalCenter
                    anchors.right: navigationArea.right
                    anchors.rightMargin: 10

                    Row {
                        spacing: 10
                        anchors.centerIn: parent

                        IconButtonHover {
                            id: settingsButton
                            width: 30
                            height: 30
                            iconSource: "qrc://assets/icons/icons/icons8_Settings.png"
                            color: mainWindow.colorA

                            onClicked: mainWindow.pushPage("qrc:/pages/SettingsPage.qml")
                        }

                        IconButtonHover {
                            id: aboutButton
                            width: 30
                            height: 30
                            iconSource: "qrc://assets/icons/icons/icons8_About.png"
                            color: mainWindow.colorA

                            onClicked: mainWindow.pushPage("qrc:/pages/AboutPage.qml")
                        }

                        IconButtonHover {
                            id: disconnectButton
                            width: 30
                            height: 30
                            iconSource: "qrc://assets/icons/icons/icons8_Disconnected.png"
                            color: mainWindow.colorA

                            onClicked: backend.disconnectFromServer()
                        }

                        IconButtonHover {
                            id: quitButton
                            width: 30
                            height: 30
                            iconSource: "qrc://assets/icons/icons/icons8_Shutdown.png"
                            color: mainWindow.colorA

                            onClicked: mainWindow.close()
                        }
                    }
                }
            }
        }
    }

    Item {
        width: registrationPopup.width
        height: registrationPopup.height
        anchors.centerIn: parent

        PopupBox {
            id: registrationPopup
            width: loggingPage.width / 2
            height: loggingPage.height - 50

            RegistrationPage {
                id: test
                anchors.fill: parent
            }
        }
    }

    Connections {
        target: packetProcessor
        onLoggingReply: {
            busyTimer.stop()
            unblockLoggingPage()
            mainWindow.stopBusyIndicator()

            if(nicknameState && passwordState)
            {
                nicknameInput.text = ""
                passwordInput.text = ""
                currentUser.username = message;
                mainWindow.pushPage("qrc:/pages/NavigationPage.qml")
            }
            else
            {
                passwordInput.text = ""
                loggingReplyText.text = message;
                animateShowingLoggingReply.start()
                replyTextTimer.restart()

                if(!nicknameState)
                    nicknameInput.markBadData()
                if(!passwordState)
                    passwordInput.markBadData()
            }
        }
    }

    Timer {
        id: busyTimer
        interval: mainWindow.serverResponseWaitingTimeMsec

        onTriggered: {
            unblockLoggingPage()
            mainWindow.stopBusyIndicator()
            backend.disconnectFromServer()
            mainWindow.showErrorPopup(qsTr("Connection lost. Try again later."))
        }
    }

    function blockLoggingPage()
    {
        loggingPage.enabled = false
    }

    function unblockLoggingPage()
    {
        loggingPage.enabled = true
    }

    function blockRegistrationPopup()
    {
        registrationPopup.enabled = false
        registrationPopup.closePolicy = Popup.NoAutoClose
    }

    function unblockRegistrationPopup()
    {
        registrationPopup.enabled = true
        registrationPopup.closePolicy = Popup.CloseOnEscape | Popup.CloseOnPressOutside
    }
}
