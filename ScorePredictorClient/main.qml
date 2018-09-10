import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import FileStream 1.0
import "components"
import "pages"

ApplicationWindow {
    id: mainWindow
    visible: true
    title: "Score Predictor"
    width: Screen.desktopAvailableWidth / 1.5
    height: Screen.desktopAvailableHeight / 1.5
    minimumWidth: 1150
    minimumHeight: 650

    property color backgroundColor: "#212027"
    property color accentColor: "#E8CDD0"
    property color fontColor: "white"
    property color colorA: "#8D2F23"
    property color colorB: "#641409"
    property color colorC: "#d1474e"
    property color acceptedColor: "green"
    property color deniedColor: "#d1474e"
    property int serverResponseWaitingTimeMsec: 60000
    readonly property int minPort: 1024
    readonly property int maxPort: 65535
    property var config: new Object
    signal configurationChanged()
    signal configSaved()
    signal configSavingError(var error)

    StackView {
        id: pagesView
        anchors.fill: parent
        initialItem: ConnectingPage {}
    }

    Item {
        width: errorPopup.width
        height: errorPopup.height
        anchors.centerIn: parent

        PopupBox {
            id: errorPopup
            width: 450
            height: 250

            Text {
                id: errorPopupTitle
                text: qsTr("Error")
                color: mainWindow.fontColor
                font.bold: true
                font.pointSize: 25
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 15
            }

            TextEdit {
                id: errorPopupText
                font.pointSize: 12
                color: mainWindow.fontColor
                readOnly: true
                wrapMode: TextEdit.Wrap
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                anchors.topMargin: 70
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                anchors.bottomMargin: 15
            }
        }
    }

    Item {
        width: startingMessagePopup.width
        height: startingMessagePopup.height
        anchors.centerIn: parent

        PopupBox {
            id: startingMessagePopup
            width: 600
            height: 300

            Text {
                id: startingMessagePopupTitle
                text: qsTr("Starting Message")
                color: mainWindow.fontColor
                font.bold: true
                font.pointSize: 25
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 15
            }

            TextDisplayArea {
                id: startingMessagePopupText
                fontSize: 12
                textColor: mainWindow.fontColor
                scrollBarColor: mainWindow.colorB
                scrollBarWidth: 8
                textRightMargin: 9
                textHorizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                anchors.leftMargin: 29
                anchors.rightMargin: 22
                anchors.bottomMargin: 15
                anchors.topMargin: 70
            }
        }
    }

    Connections {
        target: packetProcessor

        onRequestError: {
            backend.disconnectFromServer()
            showErrorPopup(errorMessage)
        }

        onStartingMessageArrived: {
            startingMessagePopupText.text = startingMessage
            startingMessagePopup.open()
        }
    }

    BusyIndicator {
        id: busyIndicator
        running: false
        z: 1
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 15
        anchors.bottomMargin: 15
    }

    FileStream {
        id: configFile
        source: "config.txt"

        onWritingSuccess: mainWindow.configSaved();
        onWritingError: mainWindow.configSavingError(error);
    }

    onClosing: closeApp()

    Component.onCompleted: {
        mainWindow.loadConfig()
        backend.connectToServer(mainWindow.config.ip, mainWindow.config.port)
    }

    function pushPage(page)
    {
        pagesView.push(page)
    }

    function popPage()
    {
        pagesView.pop()
    }

    function popToInitialPage()
    {
        while(pagesView.depth > 1)
            pagesView.pop()
    }

    function closeApp()
    {
        backend.close()
        Qt.quit()
    }

    function startBusyIndicator()
    {
        busyIndicator.running = true
    }

    function stopBusyIndicator()
    {
        busyIndicator.running = false
    }

    function showErrorPopup(message)
    {
        errorPopupText.text = message
        errorPopup.open()
    }

    function startLoading(busyTimer)
    {
        mainWindow.startBusyIndicator()
        busyTimer.restart()

        for(var i=1; i<arguments.length; i++)
            arguments[i].enabled = false
    }

    function stopLoading(busyTimer)
    {
        for(var i=1; i<arguments.length; i++)
            arguments[i].enabled = true

        busyTimer.stop()
        mainWindow.stopBusyIndicator()
    }

    function saveConfig(newConfig)
    {
        setConfig(newConfig)

        var configData = mainWindow.config.ip + ";" + mainWindow.config.port + ";" +
                         mainWindow.config.fullScreenState + ";" + mainWindow.config.startingMessageState + ";"

        configFile.write(configData)
    }

    function loadConfig()
    {
        var loadedData = configFile.read().split(";")
        var loadedConfig = {}

        loadedConfig.ip = loadedData[0]
        loadedConfig.port = loadedData[1]
        loadedConfig.fullScreenState = loadedData[2] === "true"
        loadedConfig.startingMessageState = loadedData[3] === "true"

        setConfig(loadedConfig)
    }

    function setConfig(newConfig)
    {
        mainWindow.config.ip = newConfig.ip
        mainWindow.config.port = newConfig.port
        mainWindow.config.fullScreenState = newConfig.fullScreenState
        mainWindow.config.startingMessageState = newConfig.startingMessageState

        mainWindow.processConfigChanges()
    }

    function processConfigChanges()
    {
        if(mainWindow.config.fullScreenState)
            mainWindow.showFullScreen()
        else
            mainWindow.showNormal()
    }
}
