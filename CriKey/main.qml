import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0

ApplicationWindow {
    title: qsTr("CriKey")
    width: 640
    height: 480
    visible: true

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: keychainFileDialog.open()
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }

    FileDialog {
        id: keychainFileDialog
        title: "Open keychain"
        selectFolder: true
        selectMultiple: false
        onAccepted: {
            var path = keychainFileDialog.fileUrl.toString().substr(7)
            keychain.open(path)
        }
        onRejected: {
            console.log('rejected')
        }
    }

    Keychain {
        id: keychain

        onOpened: {
            lockScreen.open()
        }

        onUnlockFailed: {
            lockScreen.fail()
        }

        onUnlocked: {
            crikey.unlock()
        }

        onLocked: {
            crikey.lock()
        }
    }

    Rectangle {
        id: crikey

        state: "LOCKED"

        states: [
            State {
                name: "LOCKED"
                PropertyChanges { target: lockScreen; visible: true }
            },
            State {
                name: "UNLOCKED"
                PropertyChanges { target: lockScreen; visible: false }
            }
        ]

        anchors.fill: parent


        signal lock
        signal unlock
        signal selectItem(variant item)

        onLock: {
            lockScreen.lock()
            crikey.state = "LOCKED"
        }

        onUnlock: {
            lockScreen.unlock()
            crikey.state = "UNLOCKED"
            keychain.refresh()
        }

        onSelectItem: {
//            console.log('on select item')
//            console.log(JSON.stringify(item))
//            keychainItemView.keychainItem = item
        }

        LockScreen {
            id: lockScreen
            width: parent.width
            height: parent.height
            z: 20

            onUnlockAttempt: {
                keychain.unlock(password)
            }
        }

        SplitView {
            id: mainContent
            anchors.fill: parent
            orientation: Qt.Horizontal

            handleDelegate: Rectangle {
                width: 1
                height: 1
                color: '#666'
            }

            Rectangle {
                id: categoriesColumn

                width: 200
                height: parent.height
                color: "#00000000"
                border.width: 0
                Layout.minimumWidth: 100

                Rectangle {
                    id: keychainSelect
                    color: "#f8f8f8"
                    border.width: 0

                    height: 70
                    anchors.right: parent.right
                    anchors.left: parent.left
                }

                Categories {
                    id: categories
                    color: "#ffffff"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: keychainSelect.bottom
                    anchors.topMargin: 0

                    border.width: 0

                    anchors.right: parent.right
                    anchors.left: parent.left
                }
            }

            Rectangle {
                id: itemsColumn

                width: 300
                height: parent.height
                color: "#00000000"
                border.width: 0
                Layout.minimumWidth: 100

                Search {
                    id: search
                    color: "#ffffff"
                    border.width: 0

                    anchors.right: parent.right
                    anchors.left: parent.left

                    onSearch: {
                        keychain.search(query)
                    }

                    onKeyUp: {
                        items.prevItem()
                    }

                    onKeyDown: {
                        items.nextItem()
                    }

                    Component.onCompleted: {
                        keychain.itemsReceived.connect(itemsUpdated)
                    }
                }

                KeychainItems {
                    id: items
                    color: "#f8f8f8"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: search.bottom
                    anchors.topMargin: 0
                    anchors.right: parent.right
                    anchors.left: parent.left

                    border.width: 0

                    Component.onCompleted: {
                        keychain.itemsReceived.connect(itemsUpdated)
                        items.itemSelected.connect(crikey.selectItem)
                    }

//                    onItemSelected: {
//                        console.log('item selected')
//                        console.log(JSON.stringify(item))
//                    }
                }
            }

            SelectedItem {
                id: selectedItem

                height: parent.height

                border.width: 0

                Layout.minimumWidth: 200
                Layout.fillWidth: true

                Component.onCompleted: {
                    crikey.selectItem.connect(itemReceived)
                }
            }
        }

//        Rectangle {
//            id: keychainItemsView

//            ListModel {
//                id: keychainItems
//            }


//            Component.onCompleted: {
//                keychain.itemsReceived.connect(updateItems)
//            }

//            function updateItems(items) {
//                keychainItems.clear()

//                items.forEach(function(item) {
//                    keychainItems.append(item)
//                })

//                keychainItemsListView.model = keychainItems
//                keychainItemsListView.reset()
//            }

//            width: 200
//            height: parent.height
//            color: "#dfdfdf"
//            anchors.topMargin: 0
//            anchors.right: keychainItemView.left
//            anchors.bottom: parent.bottom
//            anchors.top: search.bottom
//            anchors.rightMargin: 0
//            anchors.left: parent.left
//            anchors.leftMargin: 0

//            KeychainItemsListView {
//                id: keychainItemsListView
//                clip: true
//                anchors.fill: parent

//                highlight: Rectangle { color: "lightsteelblue" }

//                onCurrentIndexChanged: {
//                    crikey.selectItem(model.get(currentIndex))
//                }
//            }
//        }

//        KeychainItemView {
//            id: keychainItemView
//            height: parent.height
//            anchors.right: parent.right
//            anchors.rightMargin: 0
//            anchors.left: keychainItemsView.right
//            anchors.leftMargin: 0

//            property variant keychainItem: null

//            function getDesignated(item, designation) {
//                return item
//                    .encrypted
//                    .fields
//                    .filter(function(field) {
//                        return field.designation === designation
//                    }).reduce(function(prev, current) {
//                        return current.value
//                    }, '')
//            }

//            onKeychainItemChanged: {
//                username.text = getDesignated(keychainItem, 'username')
//                password.text = getDesignated(keychainItem, 'password')
//            }

//            TextField {
//                id: username
//                x: 0
//                y: 8
//                width: 302
//                height: 20
//                text: qsTr("Text Edit")
//                font.pixelSize: 12
//            }

//            TextField {
//                id: password
//                x: 0
//                y: 34
//                width: 302
//                height: 20
//                text: qsTr("Text Edit")
//                font.pixelSize: 12
//            }

//            TextEdit {
//                id: contents
//                y: 70
//                width: 300
//                height: 231
//                text: JSON.stringify(parent.keychainItem, undefined, 2)
//                cursorVisible: true
//                anchors.left: parent.left
//                anchors.leftMargin: 0
//                font.pixelSize: 12
//            }
//        }

        QuickLockButton {
            z: 10
            onClicked: {
                keychain.lock()
            }
        }
    }
}
