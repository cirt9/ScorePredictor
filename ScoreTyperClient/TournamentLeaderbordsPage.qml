import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    id: tournamentLeaderbordsPage

    RowLayout {
        id: pageLayout
        anchors.fill: parent
        spacing: 10

        Rectangle {
            id: chatArea
            color: mainWindow.colorA
            radius: 5

            Layout.fillHeight: true
            Layout.preferredWidth: 550
        }

        Rectangle {
            id: leaderboardsArea
            color: mainWindow.colorA
            radius: 5

            Layout.fillHeight: true
            Layout.fillWidth: true

            Item {
                clip: true
                anchors.fill: parent
                anchors.margins: 5

                ListView {
                    id: leaderboardsView
                    model: leaderboardsModel
                    spacing: 2
                    headerPositioning: ListView.OverlayHeader
                    anchors.fill: parent

                    header: Item {
                        width: parent.width
                        height: 45
                        z: 2

                        Rectangle {
                            id: headerComponent
                            width: parent.width
                            height: 40
                            color: mainWindow.colorB
                            radius: 5
                            anchors.top: parent.top
                            anchors.left: parent.left

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 2
                                anchors.leftMargin: 5
                                anchors.rightMargin: 5

                                Item {
                                    id: positionHeader

                                    Layout.preferredWidth: 40
                                    Layout.fillHeight: true
                                }

                                Text {
                                    id: nameHeader
                                    text: qsTr("Name")
                                    color: mainWindow.fontColor
                                    font.pointSize: 12
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                }

                                Text {
                                    id: exactScoresHeader
                                    text: qsTr("Exact Scores")
                                    color: mainWindow.fontColor
                                    font.pointSize: 12
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 120
                                }

                                Text {
                                    id: winnerOnlyHeader
                                    text: qsTr("Winner only")
                                    color: mainWindow.fontColor
                                    font.pointSize: 12
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 120
                                }

                                Text {
                                    id: pointsHeader
                                    text: qsTr("Points")
                                    color: mainWindow.fontColor
                                    font.pointSize: 12
                                    verticalAlignment: Text.AlignVCenter

                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 70
                                }
                            }
                        }
                    }

                    delegate: Item {
                        id: delegateComponent
                        width: parent.width
                        height: 30

                        Rectangle {
                            id: delegateBackground
                            color: mainWindow.colorB
                            radius: 5
                            opacity: 0.4
                            anchors.fill: parent
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 2
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5

                            Text {
                                id: positionData
                                text: position
                                color: mainWindow.fontColor
                                font.pointSize: 10
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight

                                Layout.preferredWidth: 40
                                Layout.fillHeight: true
                            }

                            Text {
                                id: nameData
                                text: name
                                color: mainWindow.fontColor
                                font.pointSize: 10
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight

                                Layout.fillHeight: true
                                Layout.fillWidth: true
                            }

                            Text {
                                id: exactScoresData
                                text: exactScores
                                color: mainWindow.fontColor
                                font.pointSize: 10
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight

                                Layout.fillHeight: true
                                Layout.preferredWidth: 120
                            }

                            Text {
                                id: winnerOnlyData
                                text: winnerOnly
                                color: mainWindow.fontColor
                                font.pointSize: 10
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight

                                Layout.fillHeight: true
                                Layout.preferredWidth: 120
                            }

                            Text {
                                id: pointsData
                                text: points
                                color: mainWindow.fontColor
                                font.pointSize: 10
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight

                                Layout.fillHeight: true
                                Layout.preferredWidth: 70
                            }
                        }
                    }
                }
            }

            ListModel {
                id: leaderboardsModel

                ListElement {
                    position: "1"
                    name: "IAmTheBest"
                    exactScores: "4"
                    winnerOnly: "15"
                    points: "27"
                }

                ListElement {
                    position: "2"
                    name: "SecondToNone"
                    exactScores: "3"
                    winnerOnly: "14"
                    points: "23"
                }

                ListElement {
                    position: "3"
                    name: "ThirdBird"
                    exactScores: "1"
                    winnerOnly: "17"
                    points: "20"
                }
            }
        }
    }
}
