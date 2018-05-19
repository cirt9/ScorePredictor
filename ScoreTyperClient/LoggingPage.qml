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
            anchors.centerIn: parent
            Layout.preferredWidth: 850
            Layout.preferredHeight: 600
            padding: 0

            background: Rectangle {
                width: parent.width
                height: parent.height
                color: mainWindow.colorA
            }

            label: Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.top
                anchors.bottomMargin: -height/2
                color: mainWindow.backgroundColor
                width: parent.width * 0.5
                height: title.font.pixelSize * 1.25
                radius: 5

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

                        TextField {
                            id: nicknameInput
                            placeholderText: qsTr("Nickname")
                            selectByMouse: true
                            maximumLength: 30
                            font.pointSize: 20
                            width: inputArea.width
                        }

                        TextField {
                            id: passwordInput
                            placeholderText: qsTr("Password")
                            echoMode: TextInput.Password
                            selectByMouse: true
                            maximumLength: 30
                            font.pointSize: 20
                            width: inputArea.width
                        }
                    }
                }

                Rectangle {
                    id: loggingReplyArea
                    color: mainWindow.backgroundColor
                    width: parent.width
                    height: loggingReplyText.font.pointSize * 3
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: inputArea.bottom
                    anchors.topMargin: height
                    radius: 3

                    Text {
                        id: loggingReplyText
                        anchors.centerIn: parent
                        color: "#d1474e"
                        font.pointSize: 10
                        opacity: 0
                    }

                    Timer {
                        id: replyTextTimer
                        interval: 10000

                        onTriggered: animationHideLoggingReply.start()
                    }

                    NumberAnimation {
                       id: animationShowLoggingReply
                       target: loggingReplyText
                       properties: "opacity"
                       from: loggingReplyText.opacity
                       to: 1.0
                       duration: 150
                       easing {type: Easing.Linear;}
                    }

                    NumberAnimation {
                       id: animationHideLoggingReply
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
                    anchors.top: loggingReplyArea.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: loggingReplyArea.height / 2
                    width: parent.width / 2
                    font.pointSize: 16
                    font.bold: true

                    onClicked: {
                        if(nicknameInput.text.length === 0 && passwordInput.text.length === 0)
                            loggingReplyText.text = qsTr("Enter a nickname and a password")
                        else if(nicknameInput.text.length === 0)
                            loggingReplyText.text = qsTr("Enter a nickname")
                        else if(passwordInput.text.length === 0)
                            loggingReplyText.text = qsTr("Enter a password")
                        else
                            backend.login(nicknameInput.text, passwordInput.text)

                        if(loggingReplyText.text.length > 0)
                        {
                            animationShowLoggingReply.start()
                            replyTextTimer.restart()
                        }
                    }
                }
            }

            Rectangle {
                id: navigationArea
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height * 0.1
                color: mainWindow.colorB

                TextButton {
                    id: registerButton
                    text: qsTr("REGISTER")
                    textColor: mainWindow.accentColor
                    textColorHovered: mainWindow.colorC
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
                        anchors.centerIn: parent
                        spacing: 10

                        IconButton {
                            id: settingsButton
                            width: 30
                            height: 30
                            iconSource: "qrc://assets/icons/icons/icons8_Settings.png"
                            backgroundColor: mainWindow.colorA

                            onClicked: mainWindow.pushPage("qrc:/pages/SettingsPage.qml")
                        }

                        IconButton {
                            id: aboutButton
                            width: 30
                            height: 30
                            iconSource: "qrc://assets/icons/icons/icons8_About.png"
                            backgroundColor: mainWindow.colorA

                            onClicked: mainWindow.pushPage("qrc:/pages/AboutPage.qml")
                        }

                        IconButton {
                            id: disconnectButton
                            width: 30
                            height: 30
                            iconSource: "qrc://assets/icons/icons/icons8_Disconnected.png"
                            backgroundColor: mainWindow.colorA

                            onClicked: backend.disconnectFromServer()
                        }

                        IconButton {
                            id: quitButton
                            width: 30
                            height: 30
                            iconSource: "qrc://assets/icons/icons/icons8_Shutdown.png"
                            backgroundColor: mainWindow.colorA

                            onClicked: mainWindow.close()
                        }
                    }
                }
            }
        }
    }

    Item {
        anchors.centerIn: parent
        width: registrationPopup.width
        height: registrationPopup.height

        Popup {
            id: registrationPopup
            width: loggingPage.width / 2
            height: loggingPage.height - 50
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            RegistrationPage {
                id: test
                anchors.fill: parent
            }
        }
    }

    Connections {
        target: packetProcessor
        onLoggingReply: {
            if(replyState)
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
                animationShowLoggingReply.start()
                replyTextTimer.restart()
            }
        }
    }
}
