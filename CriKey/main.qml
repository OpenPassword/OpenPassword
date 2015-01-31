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
                onTriggered: messageDialog.show(qsTr("Open action triggered"));
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }

    Rectangle {
        id: mainView

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

        onLock: {
            lockScreen.lock()
            mainView.state = "LOCKED"
        }

        onUnlock: {
            lockScreen.unlock()
            mainView.state = "UNLOCKED"
        }

        LockScreen {
            id: lockScreen
            width: parent.width
            height: parent.height
            z: 1

            onUnlockAttempt: {
                mainView.unlock()
            }
        }

        QuickLockButton {
            onClicked: {
                mainView.lock()
            }
        }
    }
}
