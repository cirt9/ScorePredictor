import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import "pages"

ApplicationWindow {
    id: mainWindow
    visible: true
    title: "Score Predictor Server"
    width: Screen.desktopAvailableWidth / 1.5
    height: Screen.desktopAvailableHeight / 1.5
    minimumWidth: 1150
    minimumHeight: 650

    property color backgroundColor: "#212027"
    property color accentColor: "#E8CDD0"
    property color fontColor: "white"
    property color colorA: "#8D2F23"
    property color acceptedColor: "green"
    property color deniedColor: "#d1474e"

    MainPage {
        id: mainPage
        anchors.fill: parent
    }

    onClosing: {
        server.closeServer()

        if(!server.isSafeToTerminate())
        {
            close.accepted = false
            terminationTimer.start()
        }
    }

    Timer {
        id: terminationTimer
        interval: 1000
        repeat: true

        onTriggered: {
            if(server.isSafeToTerminate())
            {
                terminationTimer.stop()
                close.accepted = true
                Qt.quit()
            }
        }
    }
}
