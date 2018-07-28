import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    id: root
    clip: true

    property bool hostMode: false
    readonly property int viewHeaderHeight: 45
    readonly property int matchHeaderHeight: 40
    readonly property int predictionDelegateHeight: 30
    readonly property int matchesSpacing: 2

    ListView {
        id: matchesView
        model: matchesModel
        delegate: matchesDelegate
        header: headerDelegate
        headerPositioning: ListView.OverlayHeader
        anchors.fill: parent
    }

    Component {
        id: headerDelegate

        Item {
            width: matchesView.width
            height: viewHeaderHeight
            z: 3

            Rectangle {
                id: headerBackground
                width: parent.width
                height: 40
                color: mainWindow.colorB
                radius: 5
                anchors.top: parent.top
                anchors.left: parent.left
            }

            RowLayout {
                id: viewHeaderLayout
                anchors.fill: headerBackground
                anchors.margins: 2
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                Text {
                    id: competitorsHeader
                    text: qsTr("Match")
                    color: mainWindow.fontColor
                    font.pointSize: 14
                    verticalAlignment: Text.AlignVCenter

                    Layout.fillHeight: true
                    Layout.preferredWidth: viewHeaderLayout.width * 0.50
                }

                Text {
                    id: scoreHeader
                    text: qsTr("Score")
                    color: mainWindow.fontColor
                    font.pointSize: 14
                    verticalAlignment: Text.AlignVCenter

                    Layout.fillHeight: true
                    Layout.preferredWidth: viewHeaderLayout.width * 0.15
                }

                Text {
                    id: predictionsEndTimeHeader
                    text: qsTr("Predictions End Time")
                    color: mainWindow.fontColor
                    font.pointSize: 14
                    verticalAlignment: Text.AlignVCenter

                    Layout.fillHeight: true
                    Layout.preferredWidth: viewHeaderLayout.width * 0.35
                }
            }
        }
    }

    Component {
        id: matchesDelegate

        ListView {
            id: predictionsView
            width: matchesView.width
            height: collapsed ? matchHeaderHeight : matchHeaderHeight + predictions.count * predictionDelegateHeight +
                                                    (predictions.count - 1) * spacing + matchesSpacing
            model: predictions
            headerPositioning: ListView.OverlayHeader
            spacing: 2
            clip: true

            header: Item {
                id: matchHeader
                width: matchesView.width
                height: matchHeaderHeight
                z: 2

                Rectangle {
                    id: matchHeaderBackground
                    width: parent.width
                    height: parent.height - matchesSpacing
                    color: mainWindow.colorB
                    radius: 5
                    opacity: 0.7
                    anchors.left: parent.left
                    anchors.top: parent.top
                }

                MouseArea {
                    anchors.fill: matchHeaderBackground
                    onClicked: predictions.count > 0 ? collapsed = !collapsed : collapsed = collapsed
                }

                RowLayout {
                    id: matchHeaderLayout
                    anchors.fill: matchHeaderBackground
                    anchors.margins: 2
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5

                    Text {
                        id: competitorsData
                        text: firstCompetitor + " vs " + secondCompetitor
                        color: mainWindow.fontColor
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                        Layout.fillHeight: true
                        Layout.preferredWidth: matchHeaderLayout.width * 0.5
                    }

                    Text {
                        id: scoreData
                        text: firstCompetitorScore + ":" + secondCompetitorScore
                        color: mainWindow.fontColor
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter

                        Layout.fillHeight: true
                        Layout.preferredWidth: matchHeaderLayout.width * 0.15
                    }

                    Text {
                        id: predictionsEndTimeData
                        text: predictionsEndTime
                        color: mainWindow.fontColor
                        font.pointSize: 12
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                        Layout.fillHeight: true
                        Layout.preferredWidth: matchHeaderLayout.width * 0.35
                    }
                }
            }

            delegate: Item {
                id: predictionDelegate
                width: parent.width
                height: predictionDelegateHeight
                visible: collapsed ? false : true

                Rectangle {
                    id: predictionDelegateBackground
                    height: parent.height
                    width: parent.width
                    color: mainWindow.colorB
                    radius: 5
                    opacity: 0.4
                    anchors.right: parent.right
                    anchors.top: parent.top
                }

                RowLayout {
                    id: predictionDelegateLayout
                    anchors.fill: predictionDelegateBackground
                    anchors.margins: 2
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5

                    Text {
                        id: predictorsNicknameData
                        text: nickname
                        color: mainWindow.fontColor
                        font.pointSize: 10
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                        Layout.fillHeight: true
                        Layout.preferredWidth: predictionDelegateLayout.width * 0.5
                    }

                    Text {
                        id: predictedScoreData
                        text: firstCompetitorPredictedScore + ":" + secondCompetitorPredictedScore
                        color: mainWindow.fontColor
                        font.pointSize: 10
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                        Layout.fillHeight: true
                        Layout.preferredWidth: predictionDelegateLayout.width * 0.5
                    }
                }
            }
        }
    }

    ListModel {
        id: matchesModel

        ListElement {
            firstCompetitor: "Croatia"
            secondCompetitor: "France"
            firstCompetitorScore: 2
            secondCompetitorScore: 4
            predictionsEndTime: "15-07-2018 17:00"
            predictions: [
                ListElement {
                    nickname: "John"
                    firstCompetitorPredictedScore: 2
                    secondCompetitorPredictedScore: 4
                },

                ListElement {
                    nickname: "TournamentTester1"
                    firstCompetitorPredictedScore: 2
                    secondCompetitorPredictedScore: 1
                },

                ListElement {
                    nickname: "TestUser"
                    firstCompetitorPredictedScore: 1
                    secondCompetitorPredictedScore: 1
                }
            ]
            collapsed: true
        }

        ListElement {
            firstCompetitor: "Belgium"
            secondCompetitor: "France"
            firstCompetitorScore: 0
            secondCompetitorScore: 1
            predictionsEndTime: "11-07-2018 19:00"
            predictions: [
                ListElement {
                    nickname: "John"
                    firstCompetitorPredictedScore: 2
                    secondCompetitorPredictedScore: 2
                },

                ListElement {
                    nickname: "TestUser"
                    firstCompetitorPredictedScore: 1
                    secondCompetitorPredictedScore: 0
                }
            ]
            collapsed: true
        }

        ListElement {
            firstCompetitor: "Croatia"
            secondCompetitor: "England"
            firstCompetitorScore: 2
            secondCompetitorScore: 2
            predictionsEndTime: "12-07-2018 19:00"
            predictions: [
                ListElement {
                    nickname: "John"
                    firstCompetitorPredictedScore: 2
                    secondCompetitorPredictedScore: 2
                }
            ]
            collapsed: true
        }
    }
}
