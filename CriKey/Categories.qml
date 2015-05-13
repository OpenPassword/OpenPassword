import QtQuick 2.4

Rectangle {
    id: rectangle1
    width: 200
    height: 200

    ListModel {
        id: categoriesList

        ListElement {
            name: "Category 1"
        }
        ListElement {
            name: "Category 2"
        }
        ListElement {
            name: "Category 3"
        }
    }

    ListModel {
        id: foldersList

        ListElement {
            name: "Folder 1"
        }
        ListElement {
            name: "Folder 2"
        }
        ListElement {
            name: "Folder 3"
        }
    }

    ListModel {
        id: tagsList

        ListElement {
            name: "Tag 1"
        }
        ListElement {
            name: "Tag 2"
        }
        ListElement {
            name: "Tag 3"
        }
    }

    ListView {
        id: categories
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        height: 200

        delegate: Rectangle {
            id: categoryDelegate
            height: 20
            border.color: "#cf9595"

            Text {
                text: name
            }
        }

        Component.onCompleted: {
            console.log('height ' + delegate.height)
        }

        model: categoriesList
//        height: categoriesList.count * delegate.implicitHeight
        boundsBehavior: Flickable.StopAtBounds
    }

    ListView {
        id: folders
        anchors.top: categories.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.topMargin: 0

        model: foldersList
        height: foldersList.count * 20
        boundsBehavior: Flickable.StopAtBounds

        delegate: Text { text: name }
    }

    ListView {
        id: tags
        anchors.top: folders.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.topMargin: 0

        model: tagsList
        height: tagsList.count * 20
        boundsBehavior: Flickable.StopAtBounds

        delegate: Text { text: name }
    }
}

