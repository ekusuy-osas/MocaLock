//
//  InputMarkView.swift
//  MocaLock
//
//  Created by yusuke saso on 2019/05/25.
//  Copyright © 2019 yusuke saso. All rights reserved.
//

import UIKit

internal class PointSignView: UIView, InputSignView {
    
    public var isInputed: Bool = false
    var lineWidth: CGFloat! = 2
    var fillColor: UIColor? = nil
    var lineColor: UIColor? = nil
    
    public override func draw(_ rect: CGRect) {
        let oval = UIBezierPath(ovalIn: CGRect(x: lineWidth, y: lineWidth, width: self.bounds.size.width - lineWidth * 2, height: self.bounds.size.height - lineWidth * 2))
        // Fill Color
        if isInputed {
            fillColor?.setFill()
            oval.fill()
        }
        // Line Color
        lineColor?.setStroke()
        oval.lineWidth = lineWidth
        oval.stroke()
    }
}

