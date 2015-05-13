import QtQuick 2.4

Rectangle {
    width: 200
    height: 200

    signal itemsUpdated(var items)
    signal itemSelected(var item)
    signal nextItem
    signal prevItem

    onItemsUpdated: {
        keychainItems.clear()

        items.forEach(function(item) {
            keychainItems.append(item)
        })

        itemsList.model = keychainItems
        itemsList.currentIndexChanged()
    }

    onNextItem: {
        itemsList.incrementCurrentIndex()
    }

    onPrevItem: {
        itemsList.decrementCurrentIndex()
    }

    ListModel {
        id: keychainItems
    }

    ListView {
        id: itemsList
        spacing: 5

        activeFocusOnTab: true
        anchors.fill: parent
        focus: true
        highlightMoveDuration: 0
        keyNavigationWraps: true
        clip: true

        onCurrentIndexChanged: {
            parent.itemSelected(model.get(currentIndex))
        }

        delegate: KeychainItem {
            width: parent.width

            onClicked: {
                itemsList.currentIndex = index
                itemsList.focus = true
            }
        }
    }
}
