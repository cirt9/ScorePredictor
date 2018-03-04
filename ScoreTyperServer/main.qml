import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

ApplicationWindow {
    id: mainWindow
    visible: true
    title: "Score Typer Server"

    width: Screen.desktopAvailableWidth / 1.5
    height: Screen.desktopAvailableHeight / 1.5
    minimumHeight: 600
    minimumWidth: 800

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
        interval: 5000
        repeat: true
        onTriggered: {
            if(server.isSafeToTerminate())
            {
                console.log("Tick")
                close.accepted = true
                Qt.quit()
            }
        }
    }
}
