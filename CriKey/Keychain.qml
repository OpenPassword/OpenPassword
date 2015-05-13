import QtQuick 2.4
import io.thp.pyotherside 1.3

Python {
    id: keychain

    signal opened
    signal unlockFailed
    signal unlocked
    signal locked
    signal itemsReceived(var items)
    signal categoriesReceived(var categories)
    signal foldersReceived(var folders)
    signal tagsReceived(var tags)

    signal open(string path)
    signal unlock(string password)
    signal lock
    signal refresh
    signal search(string query)

    onOpen: {
        call('keychain.open_keychain', [path])
    }

    onUnlock: {
        call('keychain.unlock_keychain', [password])
    }

    onLock: {
        call('keychain.lock_keychain', [])
    }

    onRefresh: {
        call('keychain.get_categories', [])
        call('keychain.get_folders', [])
        call('keychain.get_tags', [])
        call('keychain.get_all_items', [])
    }

    onSearch: {
        call('keychain.search', [query])
    }

    onError: console.log(traceback)

    onReceived: {
        console.log('received data')
        console.log(data)
    }

    Component.onCompleted: {
        addImportPath('file:///home/niko/Dev/crikey/CriKey/py')
        addImportPath('file:///home/niko/Dev/crikey/CriKey/py/lib')

        importModule('keychain', function() {
            console.log('Module imported')
        })

        setHandler('keychainOpened', function() {
            console.log('keychainOpened received')
            keychain.opened()
        })

        setHandler('keychainUnlocked', function() {
            console.log('keychainUnlocked received')
            keychain.unlocked()
        })

        setHandler('keychainLocked', function() {
            console.log('keychainLocked received')
            keychain.locked()
        })

        setHandler('keychainUnlockFailed', function() {
            console.log('keychainUnlockFailed received')
            keychain.unlockFailed()
        })

        setHandler('keychainItems', function(items) {
            console.log('keychainItems received')
            keychain.itemsReceived(items)
        })

        setHandler('categories', function(categories) {
            console.log('categories received')
            keychain.categoriesReceived(categories)
        })

        setHandler('folders', function(folders) {
            console.log('folders received')
            keychain.foldersReceived(folders)
        })

        setHandler('tags', function(tags) {
            console.log('tags received')
            keychain.tagsReceived(tags)
        })
    }
}
