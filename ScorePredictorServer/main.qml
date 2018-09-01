import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

ApplicationWindow {
    id: mainWindow
    visible: true
    title: "Score Predictor Server"

    width: Screen.desktopAvailableWidth / 1.5
    height: Screen.desktopAvailableHeight / 1.5
    minimumWidth: 1150
    minimumHeight: 650

    Button {
        anchors.centerIn: parent
        text: "Start"
        onClicked: server.startServer(5000)
    }

    Button {
        text: "Stop"
        onClicked: server.closeServer()
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
