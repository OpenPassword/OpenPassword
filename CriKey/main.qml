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
            var path = keychainFileDialog.folder.toString().substr(7)
            keychain.open(path)
        }
        onRejected: {
            console.log('rejected')
        }
    }

    ListModel {
        id: keychainItems
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

        onItemsReceived: {
            keychainItems.clear()

            items.forEach(function(item) {
                keychainItems.append(item)
            })

            keychainItemsListView.model = keychainItems
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
            console.log(item)
            keychainItemView.keychainItem = item
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

        Rectangle {
            id: keychainItemsView
            width: 200
            height: parent.height
            color: "#dfdfdf"
            anchors.right: keychainItemView.left
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

            KeychainItemsListView {
                id: keychainItemsListView
                anchors.fill: parent

                highlight: Rectangle { color: "lightsteelblue" }

                onCurrentIndexChanged: {
                    crikey.selectItem(model.get(currentIndex))
                }
            }
        }

        KeychainItemView {
            id: keychainItemView
            height: parent.height
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: keychainItemsView.right
            anchors.leftMargin: 0

            property variant keychainItem: null

            TextEdit {
                id: contents
                width: 300
                height: 231
                text: JSON.stringify(parent.keychainItem, undefined, 2)
                cursorVisible: true
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                font.pixelSize: 12
            }

            onKeychainItemChanged: {
                console.log('keychain item changed')
                console.log(JSON.stringify(keychainItem))
            }
        }

        QuickLockButton {
            z: 10
            onClicked: {
                keychain.lock()
            }
        }
    }
}
