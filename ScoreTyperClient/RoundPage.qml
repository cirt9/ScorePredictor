import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../reusableWidgets"
import "../components"

Page {
    id: roundPage

    RowLayout {
        id: pageLayout
        anchors.fill: parent
        spacing: 10

        Rectangle {
            id: matchesArea
            color: mainWindow.colorA
            radius: 5

            Layout.fillHeight: true
            Layout.preferredWidth: (roundPage.width * 0.6) - 10

            ListOfMatches {
                id: listOfMatches
                anchors.fill: parent
                anchors.margins: 5

                onCreatingNewMatch: createNewMatchPopup.open()
            }
        }

        Rectangle {
            id: roundLeaderboardArea
            color: mainWindow.colorA
            radius: 5

            Layout.fillHeight: true
            Layout.preferredWidth: roundPage.width * 0.4

            TournamentLeaderboard {
                id: roundLeaderboard
                anchors.fill: parent
                anchors.margins: 5
            }
        }
    }

    Item {
        width: createNewMatchPopup.width
        height: createNewMatchPopup.height
        anchors.centerIn: parent

        PopupBox {
            id: createNewMatchPopup
            width: 500
            height: 575

            onClosed: predictionsEndDatePicker.hideCalendar()

            MouseArea {
                anchors.fill: parent
                onClicked: predictionsEndDatePicker.hideCalendar()
            }

            Text {
                id: newMatchPopupTitle
                text: qsTr("Creating New Match")
                color: mainWindow.fontColor
                font.bold: true
                font.pointSize: 25
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 15
            }

            Column {
                spacing: 5
                anchors.top: newMatchPopupTitle.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 50

                InputWithBorder {
                    id: firstCompetitorInput
                    height: 35
                    width: 275
                    color: mainWindow.fontColor
                    fontSize: 14
                    radius: 3
                    maxLength: 30
                    placeholderText: qsTr("First Competitor")
                    selectByMouse: true
                    selectedTextColor: mainWindow.fontColor
                    selectionColor: mainWindow.accentColor
                    trimText: true
                }

                Text {
                    id: newMatchVersusText
                    width: 275
                    text: qsTr("VERSUS")
                    color: mainWindow.fontColor
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                InputWithBorder {
                    id: secondCompetitorInput
                    color: mainWindow.fontColor
                    height: 35
                    width: 275
                    fontSize: 14
                    radius: 3
                    maxLength: 30
                    placeholderText: qsTr("Second Competitor")
                    selectByMouse: true
                    selectedTextColor: mainWindow.fontColor
                    selectionColor: mainWindow.accentColor
                    trimText: true
                }

                Item {
                    id: newMatchPredictionsEndTimeArea
                    width: 275
                    height: newMatchPredictionsEndTimeText.height + newMatchPredictionsEndTimeText.anchors.topMargin +
                            predictionsEndTimePicker.height + predictionsEndTimePicker.anchors.topMargin

                    Text {
                        id: newMatchPredictionsEndTimeText
                        text: qsTr("Predictions End Time")
                        color: mainWindow.fontColor
                        font.pointSize: 16
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 15
                    }

                    TimePickerWidget {
                        id: predictionsEndTimePicker
                        color: mainWindow.backgroundColor
                        fontSize: 14
                        radius: 5
                        addIcon: "qrc://assets/icons/icons/icons8_Collapse_Arrow.png"
                        substractIcon: "qrc://assets/icons/icons/icons8_Expand_Arrow.png"
                        selectedTextColor: mainWindow.fontColor
                        selectionColor: mainWindow.accentColor
                        hoveredButtonColor: mainWindow.accentColor
                        anchors.left: parent.left
                        anchors.top: newMatchPredictionsEndTimeText.bottom
                        anchors.topMargin: 10
                    }

                    DatePickerWidget {
                        id: predictionsEndDatePicker
                        color: mainWindow.backgroundColor
                        radius: 5
                        fontSize: 14
                        fontColor: mainWindow.fontColor
                        expandCalendarIcon: "qrc://assets/icons/icons/icons8_Expand_Arrow.png"
                        previousIcon: "qrc://assets/icons/icons/icons8_Chevron_Left.png"
                        nextIcon: "qrc://assets/icons/icons/icons8_Chevron_Right.png"
                        hoveredButtonColor: mainWindow.accentColor
                        selectByMouse: true
                        selectedTextColor: mainWindow.fontColor
                        selectionColor: mainWindow.accentColor
                        calendarMainColor: "#626167"
                        calendarSideColor: mainWindow.backgroundColor
                        calendarInactiveColor: "#766363"
                        minimumDate: new Date()
                        calendarAlignRight: true
                        anchors.left: predictionsEndTimePicker.right
                        anchors.top: predictionsEndTimePicker.top
                    }
                }
            }
        }
    }

    Component.onCompleted: console.log(tournamentNavigationPage.currentPage)
}
