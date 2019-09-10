//
//  ViewController.swift
//  MocaLock-Example
//
//  Created by yusuke saso on 2019/05/27.
//  Copyright © 2019 yusuke saso. All rights reserved.
//

import UIKit
import MocaLock

class ViewController: UIViewController {

    @IBOutlet weak var passwordLabel: UILabel!
    
    let passwordKey = "password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordLabel.text = "PW: " + (UserDefaults.standard.string(forKey: passwordKey) ?? "not setting.")
        
    }

    @IBAction func touchUpRegister(_ sender: Any) {
        let vc = MocaLockViewController.init(mocaLockType: .register)
        vc.registerDelegate = self
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func touchUpUnlock(_ sender: Any) {
        let bgColor = UIColor(red: 0.54, green: 0.68, blue: 0.90, alpha: 1.0)
        let btnTextColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let btnBGColor = UIColor(red: 0.10, green: 0.20, blue: 0.42, alpha: 1.0)
        let vc = MocaLockViewController.init(mocaLockType: .unlock,
                                             backgroundColor: bgColor,
                                             buttonTextColor: btnTextColor,
                                             buttonBGColor: btnBGColor
        )
        vc.unlockDelegate = self
        vc.unlockPassword = UserDefaults.standard.string(forKey: passwordKey)
        self.present(vc, animated: true, completion: nil)
        // start Bio Auth
        vc.startBioAuth()
    }
}

extension ViewController: MocaLockUnlockDelegate {
    func correctPassword() {
        let alert = UIAlertController(title: "Unlock Success", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        print("correctPassword.")
    }
}

extension ViewController: MocaLockRegisterDelegate {
    func completeRegister(password: String) {
        passwordLabel.text = password
        UserDefaults.standard.set(password, forKey: passwordKey)
        print("completeRegister. \(password)")
    }
}
