import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../components"

Page {
    id: userProfilePage

    ColumnLayout {
        id: pageLayout
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        Rectangle {
            id: topArea
            color: mainWindow.colorA
            radius: 5

            Layout.fillWidth: true
            Layout.preferredHeight: 160

            RowLayout {
                anchors.fill: parent

                Column {
                    id: avatarArea
                    spacing: 3
                    Layout.preferredWidth: 120
                    Layout.fillHeight: true
                    Layout.margins: 17

                    Rectangle {
                        id: userAvatar
                        color: "white"
                        width: 120
                        height: 120

                        Text {
                            text: ".jpg"
                            color: "black"
                            anchors.centerIn: parent
                        }
                    }

                    TextButton {
                        id: profileEditButton
                        text: qsTr("EDIT PROFILE")
                        textColor: mainWindow.fontColor
                        textColorHovered: mainWindow.accentColor
                        fontSize: 10
                        bold: true
                        anchors.horizontalCenter: userAvatar.horizontalCenter
                    }
                }

                GroupBox {
                    id: userInfoArea
                    anchors.left: avatarArea.right
                    anchors.leftMargin: 30
                    padding: 0

                    Layout.fillHeight: true
                    Layout.preferredWidth: currentTournamentsArea.width - userInfoArea.anchors.leftMargin -
                                           avatarArea.width - avatarArea.Layout.margins
                    Layout.topMargin: 20
                    Layout.bottomMargin: 20

                    background: Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "transparent"
                        border.color: mainWindow.backgroundColor
                        border.width: 2
                        radius: 3
                    }

                    label: Rectangle {
                        anchors.left: parent.left
                        anchors.bottom: parent.top
                        anchors.bottomMargin: -height/2
                        anchors.leftMargin: 10
                        color: mainWindow.colorA
                        width: textMetrics.width * 1.25
                        height: nicknameText.font.pixelSize * 1.25
                        radius: 5

                        Text {
                            id: nicknameText
                            text: "Nickname"
                            color: mainWindow.backgroundColor
                            font.pixelSize: 22
                            font.bold: true
                            anchors.centerIn: parent
                        }

                        TextMetrics {
                            id: textMetrics
                            text: nicknameText.text
                            font.family: nicknameText.font
                            font.pointSize: nicknameText.font.pointSize
                            font.bold: nicknameText.font.bold
                            elide: Text.ElideMiddle
                        }
                    }

                    Text {
                        id: profileDescription
                        text: "Description..."
                        font.pointSize: 12
                        color: mainWindow.fontColor
                        wrapMode: Text.Wrap
                        anchors.fill: parent
                        anchors.margins: 8
                        anchors.topMargin: 15
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: pageLayout.width / 2
                spacing: 10

                Rectangle {
                    id: currentTournamentsArea
                    color: mainWindow.colorA
                    radius: 5

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Rectangle {
                    id: tournamentsHistoryArea
                    color: mainWindow.colorA
                    radius: 5

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            Rectangle {
                id: statsArea
                color: mainWindow.colorA
                radius: 5

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: pageLayout.width / 2
            }
        }
    }

    Connections {
        target: packetProcessor
        onProfileDownloadReply: {
            nicknameText.text = currentUser.username
            profileDescription.text = description
        }
    }
}
