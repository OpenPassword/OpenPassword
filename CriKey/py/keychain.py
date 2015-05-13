import pyotherside
from blimey import AgileKeychain
from blimey.exceptions import IncorrectPasswordException

keychain = None


def open_keychain(path):
    global keychain

    if keychain is not None:
        lock_keychain()

    keychain = AgileKeychain(path)
    pyotherside.send('keychainOpened')
    _log('keychain opened')
    _log(repr(keychain))


def unlock_keychain(password):
    global keychain
    _log('attempting to unlock')
    _log(repr(keychain))
    try:
        keychain.unlock(password)
        pyotherside.send('keychainUnlocked')
        _log('keychain unlocked')
    except IncorrectPasswordException:
        pyotherside.send('keychainUnlockFailed')


def lock_keychain():
    global keychain
    _log('attempting to unlock')
    _log(repr(keychain))
    keychain.lock()
    pyotherside.send('keychainItems', [])
    pyotherside.send('keychainLocked')
    _log('keychain unlocked')


def search(query):
    global keychain
    results = []

    for item in keychain:
        if item['title'] is not None and query.lower() in item['title'].lower():
            results.append(item)
            continue

        if item['location'] is not None and query.lower() in item['location'].lower():
            results.append(item)
            continue

        if item['locationKey'] is not None and query.lower() in item['locationKey'].lower():
            results.append(item)
            continue

    pyotherside.send('keychainItems', _sort(results))

def get_all_items():
    global keychain
    pyotherside.send('keychainItems', _sort(keychain))


def get_categories():
    pyotherside.send('categories', ['foo', 'bar'])


def get_folders():
    pyotherside.send('folders', ['folder', 'folder2'])


def get_tags():
    pyotherside.send('tags', ['tag1', 'tag2'])


def _sort(items):
    return sorted(items, key=lambda item: item['title'].lower())


def _log(msg):
  with open('log', 'a+') as file:
    file.write('\n' + msg)

_log('run')
