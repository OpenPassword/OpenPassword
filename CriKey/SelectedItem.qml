import QtQuick 2.4
import QtQuick.Controls 1.3

Rectangle {
    width: 400
    height: 500
    color: "#C0E8B1"

    signal itemReceived(var item)
    onItemReceived: {
        console.log('on item received')
        keychainItem = item
    }

    property variant keychainItem: null

    function getDesignated(item, designation) {
        return item
            .encrypted
            .fields
            .filter(function(field) {
                return field.designation === designation
            }).reduce(function(prev, current) {
                return current.value
            }, '')
    }

    onKeychainItemChanged: {
        try {
            designatedUsernameField.text = getDesignated(keychainItem, 'username')
        } catch(e) {
            designatedUsernameField.text = ''
        }

        try {
            designatedPasswordField.text = getDesignated(keychainItem, 'password')
        } catch(e) {
            designatedPasswordField.text = ''
        }
    }

    Rectangle {
        id: rectangle1
        color: "#ffffff"
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 15
        anchors.topMargin: 15
        anchors.fill: parent

        Text {
            id: title
            text: keychainItem.title ? keychainItem.title : 'n/a'
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.top: parent.top
            anchors.topMargin: 25
            font.pixelSize: 16
        }

        Text {
            id: designatedUsernameLabel
            text: qsTr("Username")
            anchors.left: title.left
            anchors.leftMargin: 10
            anchors.top: title.bottom
            anchors.topMargin: 25
            font.pixelSize: 12
        }

        Text {
            id: designatedPasswordLabel
            x: -24
            text: qsTr("Password")
            anchors.right: designatedUsernameLabel.right
            anchors.rightMargin: 0
            anchors.top: designatedUsernameLabel.bottom
            anchors.topMargin: 15
            font.pixelSize: 12
        }

        TextField {
            id: designatedUsernameField
            y: -134
            width: 200
            height: 20
            text: qsTr("")
            anchors.left: designatedUsernameLabel.right
            anchors.leftMargin: 20
            anchors.verticalCenter: designatedUsernameLabel.verticalCenter
            placeholderText: "Username"
            font.pixelSize: 12
        }

        TextField {
            id: designatedPasswordField
            y: -108
            width: 200
            height: 20
            text: qsTr("")
            anchors.left: designatedPasswordLabel.right
            anchors.leftMargin: 20
            anchors.verticalCenter: designatedPasswordLabel.verticalCenter
            placeholderText: "Password"
            font.pixelSize: 12
        }
    }
}

