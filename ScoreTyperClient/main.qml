import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import "components"
import "pages"

ApplicationWindow {
    id: mainWindow
    visible: true
    title: "Score Typer"

    width: Screen.desktopAvailableWidth / 1.5
    height: Screen.desktopAvailableHeight / 1.5
    minimumWidth: 1150
    minimumHeight: 650
    onClosing: closeApp()

    property color backgroundColor: "#212027"
    property color accentColor: "#E8CDD0"
    property color fontColor: "white"
    property color colorA: "#8D2F23"
    property color colorB: "#641409"
    property color colorC: "#d1474e"
    property color acceptedColor: "green"
    property color deniedColor: "#d1474e"
    property int serverResponseWaitingTimeMsec: 60000

    StackView {
       id: pagesView
       anchors.fill: parent
       initialItem: ConnectingPage {}
   }

    Item {
        anchors.centerIn: parent
        width: errorPopup.width
        height: errorPopup.height

        PopupBox {
            id: errorPopup
            width: 600
            height: 200
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            Text {
                id: popupText
                anchors.centerIn: parent
                font.pointSize: 12
                color: fontColor
            }
        }

        Connections {
            target: packetProcessor
            onRequestError: {
                backend.disconnectFromServer()
                showErrorPopup(errorMessage)
            }
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
        popupText.text = message
        errorPopup.open()
    }
}
