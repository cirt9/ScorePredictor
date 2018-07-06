import QtQuick 2.9

Rectangle {
    id: root
    border.width: 0
    property string lastSearchedPhrase
    property alias text: textInput.text
    property color textColor
    property int fontSize: 15
    property int inputLeftMargin: 7
    property int inputRightMargin: 7
    property int inputTopMargin: 3
    property int inputBottomMargin: 3
    property alias maximumLength: textInput.maximumLength
    property alias selectedTextColor: textInput.selectedTextColor
    property alias selectionColor: textInput.selectionColor
    property alias selectByMouse: textInput.selectByMouse
    property int borderWidthOnFocus: 2
    property url searchIcon
    property url clearIcon
    property int buttonRightMargin: 5
    property int iconsMargins: 3
    property int iconsMarginsOnPressed: 5
    property alias placeholderText: placeholder.text
    property color placeholderTextColor: textColor
    property bool trimText: true
    property alias searchingEnabled: searchButtonContainer.enabled
    property alias clearingEnabled: clearButtonContainer.enabled
    signal searchClicked()
    signal clearClicked()
    signal cleared()

    Item {
        id: inputArea
        clip: true
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: searchButtonContainer.left
        anchors.topMargin: inputTopMargin
        anchors.bottomMargin: inputBottomMargin
        anchors.leftMargin: inputLeftMargin
        anchors.rightMargin: inputRightMargin

        Text {
            id: placeholder
            text: placeholderText
            font.pointSize: textInput.font.pointSize
            color: placeholderTextColor
            opacity: 0.3
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        TextInput {
            id: textInput
            color: textColor
            verticalAlignment: Text.AlignVCenter
            font.pointSize: fontSize
            activeFocusOnTab: true
            anchors.fill: parent

            onFocusChanged: {
                if(focus)
                {
                    root.border.width = borderWidthOnFocus
                    if(textInput.text.length === 0)
                        placeholder.visible = false
                }
                else
                {
                    root.border.width = 0
                    if(textInput.text.length === 0)
                        placeholder.visible = true
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            cursorShape: Qt.IBeamCursor
        }
    }

    IconButton {
        id: searchButtonContainer
        height: parent.height
        width: height
        iconSource: searchIcon
        margins: iconsMargins
        marginsOnPressed: iconsMarginsOnPressed
        anchors.right: clearButtonContainer.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        onClicked: {
            if(trimText)
                textInput.text = textInput.text.trim()

            if(textInput.text.length > 0)
            {
                lastSearchedPhrase = textInput.text
                root.searchClicked()
            }
            textInput.focus = false
        }
    }

    IconButton {
        id: clearButtonContainer
        height: parent.height
        width: height
        iconSource: clearIcon
        margins: iconsMargins
        marginsOnPressed: iconsMarginsOnPressed
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: buttonRightMargin

        onClicked: {
            textInput.text = ""
            textInput.focus = true
            root.clearClicked()
            lastSearchedPhrase = ""
            root.cleared()
        }
    }
}
