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
    pyotherside.send('keychainLocked')
    _log('keychain unlocked')


def get_all_items():
    global keychain
    pyotherside.send('keychainItems', list(keychain))

def _log(msg):
  with open('log', 'a+') as file:
    file.write('\n' + msg)

_log('run')
