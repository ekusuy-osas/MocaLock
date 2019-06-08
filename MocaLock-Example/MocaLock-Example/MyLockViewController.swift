//
//  MyLockViewController.swift
//  MocaLock-Example
//
//  Created by yusuke saso on 2019/06/08.
//  Copyright © 2019 yusuke saso. All rights reserved.
//

import MocaLock

class MyLockViewController: MocaLockViewController {
    override func deleteButton(_ mocaLockView: MocaLockView) -> UIButton {
        let btn = UIButton()
//        btn.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
        return btn
    }
}
