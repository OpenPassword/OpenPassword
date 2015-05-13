import QtQuick 2.0
import QtQuick.Controls 1.3

Rectangle {
    id: search
    width: 640
    height: 73
    focus: true

    signal search(string query)
    signal itemsUpdated(var items)
    signal keyUp
    signal keyDown

    onItemsUpdated: {
        itemCount.text = items.length + " " + (items.length === 1 ? qsTr("item") : qsTr("items"))
    }

    onKeyUp: {
        console.log('keyup')
    }

    onKeyDown: {
        console.log('keydown')
    }

    TextField {
        id: searchField
        height: 20
        text: qsTr("")
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        placeholderText: "Search"
        font.pixelSize: 12

        Timer {
            id: searchTimer
            interval: 50
            running: false
            repeat: false
            onTriggered: {
                search.search(searchField.text)
            }
        }

        onTextChanged: {
            searchTimer.restart()
        }

        Keys.onUpPressed: {
            parent.keyUp()
        }

        Keys.onDownPressed: {
            parent.keyDown()
        }
    }

    TextEdit {
        id: itemCount
        y: 42
        height: 12
        color: "#666666"
        text: qsTr("")
        readOnly: true
        activeFocusOnPress: false
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
        focus: true
    }

    Image {
        id: image1
        x: 10
        y: 20
        width: 20
        height: 20
        sourceSize.height: 20
        sourceSize.width: 20
        source: "../icons/magnifying-glass.svg"
    }
}
