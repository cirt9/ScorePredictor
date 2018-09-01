import QtQuick 2.9

Item {
    id: root
    width: textMetrics.width
    height: textMetrics.height * 1.10

    property alias text: responseText.text
    property color acceptedColor: "green"
    property color deniedColor: "red"
    property alias fontSize: responseText.font.pointSize
    property alias bold: responseText.font.bold
    property alias visibilityTime: hideResponseTimer.interval
    property int showingDuration: 150
    property int hidingDuration: 500

    TextMetrics {
        id: textMetrics
        text: root.text
        font.family: responseText.font
        font.pointSize: root.fontSize
        font.bold: root.bold
    }

    Text {
        id: responseText
        font.pointSize: 12
        opacity: 0.0
        anchors.centerIn: parent
        property bool hidden: true

        states: [
            State {
                name: "hidden"
                when: responseText.hidden

                PropertyChanges {
                    target: responseText
                    opacity: 0.0
                }
            },
            State {
                name: "visible"
                when: !responseText.hidden

                PropertyChanges {
                    target: responseText
                    opacity: 1.0
                }
            }
        ]

        transitions: [
            Transition {
                from: "hidden"; to: "visible"; reversible: false
                NumberAnimation {
                    properties: "opacity"
                    duration: root.showingDuration
                    easing.type: Easing.Linear
                }
            },
            Transition {
                from: "visible"; to: "hidden"; reversible: false
                NumberAnimation {
                    properties: "opacity"
                    duration: root.hidingDuration
                    easing.type: Easing.Linear
                }
            }
        ]
    }

    Timer {
        id: hideResponseTimer
        interval: 5000

        onTriggered: responseText.hidden = true
    }

    function showAcceptedResponse(text)
    {
        responseText.color = root.acceptedColor
        responseText.text = text
        responseText.hidden = false
        hideResponseTimer.restart()
    }

    function showDeniedResponse(text)
    {
        responseText.color = root.deniedColor
        responseText.text = text
        responseText.hidden = false
        hideResponseTimer.restart()
    }

    function hide()
    {
        responseText.hidden = true
    }
}
