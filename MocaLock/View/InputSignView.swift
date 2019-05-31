//
//  InputSignView.swift
//  MocaLock
//
//  Created by yusuke saso on 2019/05/28.
//  Copyright © 2019 yusuke saso. All rights reserved.
//

import UIKit


/// This is a protocol for displaying password input digits.
public protocol InputSignView: UIView {
    
    /// This value changes when the password is entered or deleted.
    /// Hook the change of this value and switch the drawing.
    var isInputed: Bool { get set }
}
