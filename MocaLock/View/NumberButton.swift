//
//  NumberButton.swift
//  MocaLock
//
//  Created by yusuke saso on 2019/05/28.
//  Copyright © 2019 yusuke saso. All rights reserved.
//

import UIKit


/// Button protocol for password entry.
public protocol NumberButton: UIButton {
    /// The value is set from 0 to 9
    var number: UInt8 { get set }
}
