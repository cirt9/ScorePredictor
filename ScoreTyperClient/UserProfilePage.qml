import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    id: userProfilePage

    ColumnLayout {
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
}
