import QtQuick 2.4

ListView {
    id: itemList
    activeFocusOnTab: true
    anchors.fill: parent
    focus: true
    highlightMoveDuration: 0
    keyNavigationWraps: true

    Keys.onUpPressed: {
        keychainItemsListView.decrementCurrentIndex()
    }

    Keys.onDownPressed: {
        keychainItemsListView.incrementCurrentIndex()
    }

//    ScrollBar {
//        flickable: itemList
//        vertical: true
//    }

    delegate: Component {
        id: itemDelegate

        Item {
            id: wrapper
            width: parent.width
            height: 30

            Text {
                text: title
            }

            Text {
                y: 15
                text: locationKey
                color: '#666'
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    itemList.currentIndex = index
                    itemList.focus = true
                }
            }
        }
    }
}
