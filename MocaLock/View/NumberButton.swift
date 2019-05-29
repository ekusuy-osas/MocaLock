//
//  NumberButton.swift
//  MocaLock
//
//  Created by yusuke saso on 2019/05/28.
//  Copyright © 2019 yusuke saso. All rights reserved.
//

import UIKit

public protocol NumberButton: UIButton {
    var number: UInt8 { get set }
}
