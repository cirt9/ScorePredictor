import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../components"

Page {
    id: tournamentCreatorPage

    ColumnLayout {
        id: pageLayout
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        Rectangle {
            id: tournamentsOptionsArea
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

            DescriptionLineInput {
                id: tournamentPasswordInput
                description: qsTr("Password:")
                descriptionTextColor: mainWindow.fontColor
                descriptionAreaColor: mainWindow.backgroundColor
                inputAreaColor: mainWindow.colorB
                selectByMouse: true
                maximumLength: 30
                selectedTextColor: mainWindow.fontColor
                selectionColor: mainWindow.accentColor
                descriptionWidth: 100
                inputWidth: parent.width * 0.15
                anchors.left: titleUnderline.left
                anchors.top: titleUnderline.bottom
                anchors.topMargin: 50
            }

            TimePickerWidget {
                color: mainWindow.colorB
                fontSize: 14
                radius: 10
                addIcon: "qrc://assets/icons/icons/icons8_Collapse_Arrow.png"
                substractIcon: "qrc://assets/icons/icons/icons8_Expand_Arrow.png"
                selectedTextColor: mainWindow.fontColor
                selectionColor: mainWindow.accentColor
                hoveredButtonColor: mainWindow.backgroundColor
                anchors.right: tournamentPasswordInput.right
                anchors.top: tournamentPasswordInput.bottom
                anchors.topMargin: 10
            }

            Rectangle {
                id: spinBoxArea
                color: mainWindow.colorB
                width: typersLimit.width + 20
                height: typersLimit.height + numberOfRounds.height + typersLimitText.height + numberOfRoundsText.height + 50
                border.width: 5
                border.color: mainWindow.backgroundColor
                radius: 10
                anchors.right: titleUnderline.right
                anchors.top: titleUnderline.bottom
                anchors.topMargin: 50

                SpinBox {
                    id: typersLimit
                    editable: true
                    from: 1
                    value: 16
                    to: 1000
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 10
                }

                Text {
                    id: typersLimitText
                    text: qsTr("Typers Limit")
                    font.pointSize: 14
                    color: mainWindow.fontColor
                    anchors.top: typersLimit.bottom
                    anchors.horizontalCenter: typersLimit.horizontalCenter
                }

                SpinBox {
                    id: numberOfRounds
                    editable: true
                    from: 1
                    value: 1
                    to: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: numberOfRoundsText.top
                }

                Text {
                    id: numberOfRoundsText
                    text: qsTr("Number Of Rounds")
                    font.pointSize: 14
                    color: mainWindow.fontColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                }
            }
        }
    }

    DatePickerWidget {
        color: mainWindow.colorB
        radius: 10
        fontSize: 14
        fontColor: mainWindow.fontColor
        expandCalendarIcon: "qrc://assets/icons/icons/icons8_Expand_Arrow.png"
        hoveredButtonColor: mainWindow.backgroundColor
        selectByMouse: true
        selectedTextColor: mainWindow.fontColor
        selectionColor: mainWindow.accentColor

        anchors.centerIn: parent
    }
}
