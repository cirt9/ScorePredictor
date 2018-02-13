import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    id: userProfilePage

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 10

        GroupBox {
            id: topRowBox
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            RowLayout {
                id: topRowLayout
                anchors.fill: parent
                spacing: 25

                ColumnLayout {
                    id: avatarLayout
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100

                    Rectangle {
                        id: userAvatarImage
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 100

                        Text {
                            text: ".jpg"
                            anchors.centerIn: parent
                        }
                    }

                    Button {
                        id: changeAvatarButton
                        text: "Change"
                        Layout.fillHeight: true
                        Layout.preferredHeight: 25
                        Layout.preferredWidth: 100
                    }
                }

                TextArea {
                    id: userDescription

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: 500

                    placeholderText: qsTr("Description...")
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

                ColumnLayout {
                    id: leftColumnLayout
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: 600

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
                    Layout.preferredWidth: 500

                    Text {
                        text: "Stats"
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
}
