import QtQuick 2.0

Rectangle {
    id: wrapper
    width: 200
    height: 46
    color: wrapper.ListView.isCurrentItem ? "#569040" : "#80ffffff"
    border.width: 0

    signal clicked(int index)

    Text {
        id: itemTitle
        text: title
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.top: parent.top
        anchors.topMargin: 8
        font.bold: false
        font.pointSize: 10
        color: wrapper.ListView.isCurrentItem ? "white" : "black"
    }

    Text {
        id: itemLocation
        y: 23
        text: locationKey
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        color: wrapper.ListView.isCurrentItem ? "#eee" : "#666"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.clicked(index)
//            currentIndex = index
//            if (wrapper.ListView.isCurrentItem) {
//                console.log('current')
//            }
//            console.log(wrapper.parent.ListView.currentIndex)
//            console.log(index)
//            wrapper.ListView.currentIndex = index
//            wrapper.ListView.decrementCurrentIndex()
//            wrapper.ListView.focus = true
        }
    }
}
