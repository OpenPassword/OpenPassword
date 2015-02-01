import QtQuick 2.4
import QtQuick.Controls 1.3

Rectangle {
    id: lockScreen
    width: 500
    height: 300
    anchors.fill: parent

    signal unlockAttempt(string password)

    signal open
    signal fail
    signal unlock
    signal lock

    onUnlockAttempt: {
        passwordInput.enabled = false
        unlockButton.enabled = false
    }

    onOpen: {
        console.log('on open')
        passwordInput.enabled = true
        passwordInput.focus = true
        unlockButton.enabled = true
        message.text = ""
    }

    onFail: {
        console.log('on fail')
        passwordInput.enabled = true
        passwordInput.selectAll()
        unlockButton.enabled = true
        message.text = "Incorrect password"
    }

    onLock: {
        passwordInput.enabled = true
        unlockButton.enabled = true
        message.text = ""
    }

    onUnlock: {
        passwordInput.text = ""
    }

    Rectangle {
        id: unlockContainer
        width: parent.width * 0.4
        height: 20

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        TextField {
            id: passwordInput
            height: 20
            anchors.right: unlockButton.left
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 0
            echoMode: TextInput.Password
            font.pixelSize: 12
            enabled: false

            onAccepted: lockScreen.unlockAttempt(passwordInput.text)
        }

        Button {
            id: unlockButton
            text: qsTr("Unlock")
            anchors.verticalCenter: passwordInput.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
            enabled: false

            onClicked: lockScreen.unlockAttempt(passwordInput.text)

        }
    }

    Text {
        id: message
        width: parent.width * 0.8
        text: "No Keychain opened"
        anchors.top: unlockContainer.bottom
        anchors.topMargin: 40
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 12
    }
}
