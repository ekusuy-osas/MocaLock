# MocaLock

This is a library for displaying password lock screen. It also supports biometrics (Face ID, TouchID).

- Prompt for entering and re-entering password with RegisterType. 

- Prompt for password input or biometric authentication with UnlockType.
  You can customize the design if you wish.

## Installation

coming soon...

## Usage

Specify MocaLockType.register to display the password registration screen.

```Swift:ViewController.swift
let vc = MocaLockViewController.init(MocaLockType: .register)
vc.registerDelegate = self
self.present(vc, animated: true, completion: nil)
```

Receive events on MocaLockUnlockDelegate.



Specify MocaLockType.unlock to display the password entry screen.

```Swift:ViewController.swift
let vc = MocaLockViewController.init(MocaLockType: .unlock)
vc.unlockDelegate = self
vc.unlockPassword = "1234"
self.present(vc, animated: true, completion: nil)
```

Receive events on MocaLockUnlockDelegate.

