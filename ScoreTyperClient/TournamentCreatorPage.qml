import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import DataStorage 1.0
import "../components"

Page {
    id: tournamentCreatorPage

    MouseArea {
        anchors.fill: parent
        onClicked: entriesEndDatePicker.hideCalendar()
    }

    ColumnLayout {
        id: pageLayout
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        Rectangle {
            id: tournamentCreationArea
            color: mainWindow.colorA
            radius: 5

            Layout.fillWidth: true
            Layout.fillHeight: true

            ClassicLineInput {
                id: tournamentNameInput
                width: parent.width * 0.7
                placeholderText: qsTr("Tournament Name")
                fontSize: 25
                selectByMouse: true
                maximumLength: 30
                textColor: mainWindow.fontColor
                selectionColor: mainWindow.accentColor
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 10
            }

            Rectangle {
                id: titleUnderline
                color: mainWindow.backgroundColor
                height: 3
                width: parent.width * 0.9
                radius: 5
                anchors.top: tournamentNameInput.bottom
                anchors.horizontalCenter: tournamentNameInput.horizontalCenter
            }

            LabeledLineInput {
                id: tournamentPasswordInput
                labelText: qsTr("Password:")
                labelTextColor: mainWindow.fontColor
                labelAreaColor: mainWindow.backgroundColor
                inputAreaColor: mainWindow.colorB
                selectByMouse: true
                maximumLength: 30
                selectedTextColor: mainWindow.fontColor
                selectionColor: mainWindow.accentColor
                labelWidth: 105
                inputWidth: parent.width * 0.15
                anchors.left: titleUnderline.left
                anchors.top: titleUnderline.bottom
                anchors.topMargin: 50
            }

            Rectangle {
                id: typersLimitArea
                color: mainWindow.backgroundColor
                width: entriesEndTimeArea.width
                height: typersLimit.height
                radius: 10
                anchors.left: tournamentPasswordInput.left
                anchors.top: tournamentPasswordInput.bottom
                anchors.topMargin: 10

                Text {
                    id: typersLimitText
                    text: qsTr("Typers Limit:")
                    font.pointSize: 14
                    color: mainWindow.fontColor
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                }

                Rectangle {
                    color: mainWindow.colorB
                    radius: 5
                    anchors.left: typersLimitText.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: 5
                    anchors.leftMargin: 7

                    SpinBox {
                        id: typersLimit
                        width: parent.width * 0.95
                        editable: true
                        from: 1
                        value: 16
                        to: 1000
                        anchors.centerIn: parent
                    }
                }
            }

            Rectangle {
                id: entriesEndTimeArea
                height: entriesEndTimeTextMetrics.height + entriesEndTimePicker.height + 15
                width: tournamentPasswordInput.width
                color: mainWindow.backgroundColor
                radius: 10
                anchors.left: typersLimitArea.left
                anchors.top: typersLimitArea.bottom
                anchors.topMargin: 10

                Text {
                    id: entriesEndTimeText
                    text: qsTr("Entries End Time:")
                    color: mainWindow.fontColor
                    font.pointSize: 14
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 5
                    anchors.leftMargin: 10

                    TextMetrics {
                        id: entriesEndTimeTextMetrics
                        font.pointSize: entriesEndTimeText.font.pointSize
                        font.family: entriesEndTimeText.font
                        text: entriesEndTimeText.text
                    }
                }

                Rectangle {
                    height: entriesEndTimePicker.height
                    color: mainWindow.colorB
                    radius: 5
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 5

                    TimePickerWidget {
                        id: entriesEndTimePicker
                        color: mainWindow.colorB
                        fontSize: 14
                        radius: 10
                        addIcon: "qrc://assets/icons/icons/icons8_Collapse_Arrow.png"
                        substractIcon: "qrc://assets/icons/icons/icons8_Expand_Arrow.png"
                        selectedTextColor: mainWindow.fontColor
                        selectionColor: mainWindow.accentColor
                        hoveredButtonColor: mainWindow.backgroundColor
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                    }

                    DatePickerWidget {
                        id: entriesEndDatePicker
                        color: mainWindow.colorB
                        radius: 10
                        fontSize: 14
                        fontColor: mainWindow.fontColor
                        expandCalendarIcon: "qrc://assets/icons/icons/icons8_Expand_Arrow.png"
                        previousIcon: "qrc://assets/icons/icons/icons8_Chevron_Left.png"
                        nextIcon: "qrc://assets/icons/icons/icons8_Chevron_Right.png"
                        hoveredButtonColor: mainWindow.backgroundColor
                        selectByMouse: true
                        selectedTextColor: mainWindow.fontColor
                        selectionColor: mainWindow.accentColor
                        calendarMainColor: mainWindow.colorB
                        calendarSideColor: "#6A352E"
                        calendarInactiveColor: "#766363"
                        minimumDate: new Date()
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                    }
                }
            }

            Rectangle {
                color: "black"
                width: createButton.width
                height: createButton.height - 12
                radius: 2
                anchors.centerIn: createButton
            }

            Button {
                id: createButton
                text: qsTr("Create Tournament")
                font.pointSize: 28
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    var dateString = entriesEndDatePicker.simplifiedDate + " " + entriesEndTimePicker.fullTime
                    var date = Date.fromLocaleString(Qt.locale(), dateString, "dd.MM.yyyy hh:mm:ss")
                    var tournament = Qt.createQmlObject('import QtQuick 2.0;import DataStorage 1.0; Tournament {}',
                                                       tournamentCreatorPage);
                    tournament.name = tournamentNameInput.text
                    tournament.hostName = currentUser.username
                    tournament.password = tournamentPasswordInput.text
                    tournament.entriesEndTime = date
                    tournament.typersLimit = typersLimit.value
                    backend.createTournament(tournament)
                    tournament.destroy()
                }
            }
        }
    }
}
