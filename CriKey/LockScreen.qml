import QtQuick 2.0
import QtQuick.Controls 1.3

Rectangle {
    id: lockScreen
    width: 500
    height: 300
    anchors.fill: parent

    signal unlockAttempt(string password)
    signal lock
    signal unlock

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

            onAccepted: lockScreen.unlockAttempt(passwordInput.text)
        }

        Button {
            id: unlockButton
            text: qsTr("Unlock")
            anchors.verticalCenter: passwordInput.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0

            onClicked: lockScreen.unlockAttempt(passwordInput.text)

        }
    }
}
