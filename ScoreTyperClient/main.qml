import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import "pages"

ApplicationWindow {
    id: mainWindow
    visible: true
    title: "Score Typer"

    width: Screen.desktopAvailableWidth / 1.5
    height: Screen.desktopAvailableHeight / 1.5
    minimumHeight: 600
    minimumWidth: 800

    StackView {
       id: pagesView
       anchors.fill: parent
       initialItem: LoggingPage {}
   }

    function pushPage(page) {
        pagesView.push(page)
    }

    function popPage() {
        pagesView.pop()
    }
}