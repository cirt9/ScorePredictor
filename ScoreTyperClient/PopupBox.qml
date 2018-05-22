import QtQuick 2.0
import QtQuick.Controls 2.0

Popup {
    id: root
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    IconButton {
        id: closeButton
        width: 30
        height: 30
        iconSource: "qrc://assets/icons/icons/icons8_Delete.png"
        backgroundColor: mainWindow.colorA
        anchors.right: parent.right
        anchors.top: parent.top
        z: root.z + 1

        onClicked: root.close()
    }
}
