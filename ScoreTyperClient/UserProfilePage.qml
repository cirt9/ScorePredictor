import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

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
            Layout.minimumHeight: 140
            Layout.preferredHeight: pageLayout.height * 0.2

            RowLayout {
                anchors.fill: parent

                Rectangle {
                    id: userAvatar
                    color: "white"

                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 100
                    Layout.margins: 20

                    Text {
                        text: ".jpg"
                        color: "black"
                        anchors.centerIn: parent
                    }
                }

                Rectangle {
                    color: "transparent"
                    border.width: 1
                    border.color: mainWindow.accentColor
                    radius: 3

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.margins: 5

                    ColumnLayout {
                        anchors.fill: parent

                        Text {
                            text: "Nickname"
                            color: mainWindow.fontColor
                            font.pixelSize: 28
                            font.bold: true

                            Rectangle {
                                width: parent.width * 1.5
                                height: 2
                                color: mainWindow.accentColor
                                radius: 2
                                anchors.left: parent.left
                                anchors.top: parent.bottom
                            }
                        }
                    }
                }

                /*ColumnLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Text {
                        text: "Nickname"
                        color: mainWindow.fontColor
                        font.pixelSize: 28
                        font.bold: true

                        Rectangle {
                            width: parent.width * 1.5
                            height: 2
                            color: mainWindow.accentColor
                            radius: 2
                            anchors.left: parent.left
                            anchors.top: parent.bottom
                        }
                    }
                }*/

                Rectangle {
                    id: descriptionArea
                    color: "transparent"
                    border.width: 1
                    border.color: mainWindow.accentColor
                    radius: 3

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.margins: 5
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

    /*
    Connections {
        target: packetProcessor
        onProfileDownloadReply: profileDescription.text = description
    }*/

    /*ColumnLayout {
        id: mainLayout
        anchors.fill: parent

        GroupBox {
            id: topRowBox
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            RowLayout {
                id: topRowLayout
                anchors.fill: parent
                spacing: 15

                ColumnLayout {
                    id: avatarLayout
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100

                    Rectangle {
                        id: userAvatar
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 100

                        Text {
                            anchors.centerIn: parent
                            text: ".jpg"
                        }
                    }

                    Button {
                        id: profileEditButton
                        Layout.fillHeight: true
                        Layout.preferredHeight: 25
                        Layout.preferredWidth: 100
                        text: "Edit"
                    }
                }

                TextArea {
                    id: profileDescription
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: 500

                    placeholderText: qsTr("Description...")
                    readOnly: true
                    selectByMouse: true
                    wrapMode: TextEdit.Wrap
                }

                Rectangle {
                    id: prizes
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: 500

                    Text {
                        text: "prizes"
                        anchors.centerIn: parent
                    }
                }
            }
        }

        GroupBox {
            id: bottomRowBox
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                id: bottomRowLayout
                anchors.fill: parent
                spacing: 15

                ColumnLayout {
                    id: leftColumnLayout
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: avatarLayout.width + profileDescription.width + topRowLayout.spacing

                    Rectangle {
                        id: currentTournamentsContainer
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: 400

                        Text {
                            text: "Current tournaments"
                            anchors.centerIn: parent
                        }
                    }

                    Rectangle {
                        id: recentTournamentsContainer
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: 400

                        Text {
                            text: "Recent tournaments"
                            anchors.centerIn: parent
                        }
                    }
                }

                Rectangle {
                    id: statsContainer
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: prizes.width

                    Text {
                        text: "Stats"
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }

    Connections {
        target: packetProcessor
        onProfileDownloadReply: profileDescription.text = description
    }
    */
}
