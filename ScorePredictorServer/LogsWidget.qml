import QtQuick 2.9

Item {
    id: root
    clip: true

    property alias backgroundColor: background.color
    property alias backgroundRadius: background.radius
    property color itemColor: "black"
    property color fontColor: "white"
    property int fontSize: 12
    property int dateTimeFontSize: 8
    property int itemRadius: 0
    property int numberOfLogs: logsModel.count

    Rectangle {
        id: background
        opacity: 0.2
        anchors.fill: parent
    }

    ListView {
        id: logsView
        model: logsModel
        delegate: logDelegate
        spacing: 5
        anchors.fill: parent
        anchors.margins: 5
    }

    Component {
        id: logDelegate

        Rectangle {
            id: delegateBackground
            width: logsView.width
            height: delegateDateTime.contentHeight + delegateText.contentHeight + 7
            color: root.itemColor
            radius: root.itemRadius

            Text {
                id: delegateDateTime
                text: new Date().toLocaleString(Qt.locale(), "dd.MM.yyyy hh:mm:ss")
                color: root.fontColor
                font.pointSize: root.dateTimeFontSize
                font.bold: true
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 3
                anchors.rightMargin: 5
            }

            TextEdit {
                id: delegateText
                text: logText
                font.pointSize: root.fontSize
                color: root.fontColor
                readOnly: true
                wrapMode: TextEdit.Wrap
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                anchors.topMargin: delegateDateTime.contentHeight + 3
                anchors.bottomMargin: 3
                anchors.leftMargin: 5
                anchors.rightMargin: 5
            }
        }
    }

    ListModel {
        id: logsModel
    }

    function addLog(logMessage)
    {
        var logItem = {}
        logItem.logText = logMessage
        logsModel.append(logItem)
    }

    function remove(index, count)
    {
        logsModel.remove(index, count)
    }
}
