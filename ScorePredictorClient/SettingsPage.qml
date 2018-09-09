import QtQuick 2.9
import QtQuick.Controls 2.2
import FileStream 1.0
import "../components"

Page {
    id: settingsPage

    Text {
        id: title
        text: qsTr("Settings")
        color: mainWindow.fontColor
        font.pointSize: 30
        font.bold: true
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
    }

    Column {
        spacing: 30
        anchors.centerIn: parent

        Row {
            spacing: 5

            TextLineField {
                id: ipInput
                text: mainWindow.config.ip
                placeholderText: qsTr("IP")
                fontSize: 20
                selectByMouse: true
                maximumLength: 30
                width: 250
                textColor: mainWindow.fontColor
                selectedTextColor: mainWindow.fontColor
                selectionColor: mainWindow.accentColor
                underlineColorOnFocus: mainWindow.accentColor
                underlineColorBadData: mainWindow.deniedColor
                validator: RegExpValidator { regExp: /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/ }
            }

            TextLineField {
                id: portInput
                text: mainWindow.config.port
                placeholderText: qsTr("Port")
                fontSize: 20
                selectByMouse: true
                maximumLength: 30
                width: 118
                textColor: mainWindow.fontColor
                selectedTextColor: mainWindow.fontColor
                selectionColor: mainWindow.accentColor
                underlineColorOnFocus: mainWindow.accentColor
                underlineColorBadData: mainWindow.deniedColor
                validator : RegExpValidator { regExp: /([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])/ }
            }
        }

        Row {
            spacing: 5

            SwitchDelegate {
                id: fullScreenState
                text: qsTr("Full Screen")
                checked: mainWindow.config.fullScreenState
            }

            SwitchDelegate {
                id: startingMessageState
                text: qsTr("Starting Message")
                checked: mainWindow.config.startingMessageState
            }
        }
    }

    Row {
        spacing: 10
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10

        Button {
            id: backButton
            text: qsTr("Back")

            onClicked: mainWindow.popPage()
        }

        Button {
            id: saveButton
            text: qsTr("Save")
            enabled: ipInput.text.length > 0 && portInput.text.length > 0 ? true : false

            onClicked: {
                var newConfig = {}
                newConfig.ip = ipInput.text
                newConfig.port = portInput.text
                newConfig.fullScreenState = fullScreenState.checked
                newConfig.startingMessageState = startingMessageState.checked

                mainWindow.saveConfig(newConfig)
            }
        }
    }
}
