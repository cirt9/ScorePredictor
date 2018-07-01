import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import "../components"

Page {
    id: tournamentsSearchPage

    Rectangle {
        id: tournamentsSearchArea
        color: mainWindow.colorA
        radius: 5
        anchors.fill: parent
        anchors.margins: 15

        SearchWidget {
            id: searchWidget
            width: parent.width * 0.3
            height: 30
            placeholderText: "Search Tournament"
            color: mainWindow.backgroundColor
            border.color: "black"
            textColor: mainWindow.fontColor
            radius: 10
            maximumLength: 30
            selectionColor: mainWindow.accentColor
            selectByMouse: true
            searchIcon: "qrc://assets/icons/icons/icons8_Search.png"
            clearIcon: "qrc://assets/icons/icons/icons8_Delete.png"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 35
        }

        Item {
            clip: true
            width: parent.width * 0.85
            anchors.top: searchWidget.bottom
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 40
            anchors.bottomMargin: 70

            Rectangle {
                id: tournamentsViewBackground
                color: mainWindow.backgroundColor
                radius: 5
                opacity: 0.35
                anchors.fill: parent
            }

            ListModel {
                id: tournamentModel
            }

            ListView {
                id: tournamentsView
                model: tournamentModel
                spacing: 2
                headerPositioning: ListView.PullBackHeader
                highlightMoveDuration: 250
                anchors.fill: parent
                anchors.margins: 5

                header: Item {
                    width: parent.width
                    height: 50

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

                            Text {
                                id: tournamentNameHeader
                                text: qsTr("Tournament Name")
                                color: mainWindow.fontColor
                                font.pointSize: 12
                                verticalAlignment: Text.AlignVCenter

                                Layout.preferredWidth: parent.width * 0.3
                                Layout.fillHeight: true
                            }

                            Text {
                                id: hostNameHeader
                                text: qsTr("Host Name")
                                color: mainWindow.fontColor
                                font.pointSize: 12
                                verticalAlignment: Text.AlignVCenter

                                Layout.preferredWidth: parent.width * 0.3
                                Layout.fillHeight: true
                            }

                            Text {
                                id: entriesEndTimeHeader
                                text: qsTr("Entries End Time")
                                color: mainWindow.fontColor
                                font.pointSize: 12
                                verticalAlignment: Text.AlignVCenter

                                Layout.preferredWidth: parent.width * 0.15
                                Layout.fillHeight: true
                            }

                            Text {
                                id: typersHeader
                                text: qsTr("Typers")
                                color: mainWindow.fontColor
                                font.pointSize: 12
                                verticalAlignment: Text.AlignVCenter

                                Layout.preferredWidth: parent.width * 0.15
                                Layout.fillHeight: true
                            }

                            Text {
                                id: passwordHeader
                                text: qsTr("Password")
                                color: mainWindow.fontColor
                                font.pointSize: 12
                                verticalAlignment: Text.AlignVCenter

                                Layout.preferredWidth: parent.width * 0.1
                                Layout.fillHeight: true
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
                            id: tournamentNameData
                            text: tournamentName
                            color: mainWindow.fontColor
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter

                            Layout.preferredWidth: parent.width * 0.3
                            Layout.fillHeight: true
                        }

                        Text {
                            id: hostNameData
                            text: hostName
                            color: mainWindow.fontColor
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter

                            Layout.preferredWidth: parent.width * 0.3
                            Layout.fillHeight: true
                        }

                        Text {
                            id: entriesEndTimeData
                            text: entriesEndTime
                            color: mainWindow.fontColor
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter

                            Layout.preferredWidth: parent.width * 0.15
                            Layout.fillHeight: true
                        }

                        Text {
                            id: typersData
                            text: typers
                            color: mainWindow.fontColor
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter

                            Layout.preferredWidth: parent.width * 0.15
                            Layout.fillHeight: true
                        }

                        Text {
                            id: passwordData
                            text: password
                            color: mainWindow.fontColor
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter

                            Layout.preferredWidth: parent.width * 0.1
                            Layout.fillHeight: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: tournamentsView.currentIndex = index
                    }
                }

                highlight: Rectangle {
                    color: mainWindow.colorB
                    radius: 5
                    opacity: 0.8
                }

                Text {
                    text: qsTr("Tournaments not found")
                    color: mainWindow.backgroundColor
                    opacity: 0.5
                    font.bold: true
                    font.pointSize: 40
                    anchors.centerIn: parent
                    visible: tournamentModel.count === 0 ? true : false
                }
            }
        }

        DefaultButton {
            id: joinButton
            text: qsTr("Join")
            width: 200
            color: mainWindow.backgroundColor
            fontColor: mainWindow.fontColor
            fontSize: 25
            radius: 5
            enabled: tournamentModel.count === 0 ? false : true
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 10

            onClicked: {
                var chosenTournament = tournamentModel.get(tournamentsView.currentIndex)
                console.log(chosenTournament.tournamentName)
            }
        }

        IconButton {
            id: leftButton
            height: joinButton.height + 3
            width: height
            iconSource: "qrc://assets/icons/icons/icons8_Sort_Left.png"
            anchors.right: joinButton.left
            anchors.verticalCenter: joinButton.verticalCenter
        }

        IconButton {
            id: rightButton
            height: joinButton.height + 3
            width: height
            iconSource: "qrc://assets/icons/icons/icons8_Sort_Right.png"
            anchors.left: joinButton.right
            anchors.verticalCenter: joinButton.verticalCenter
        }
    }

    Component.onCompleted: backend.pullTournamentsList(currentUser.username)

    Connections {
        target: packetProcessor

        onTournamentsListElementArrived: {
            tournamentModel.append({"tournamentName": tournamentData[0], "hostName": tournamentData[1],
                                   "entriesEndTime": tournamentData[2], "typers": tournamentData[3],
                                   "password": tournamentData[4]})
        }
    }
}
