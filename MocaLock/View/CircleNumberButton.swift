//
//  HighlightButton.swift
//  MocaLock-Example
//
//  Created by yusuke saso on 2019/05/26.
//  Copyright © 2019 yusuke saso. All rights reserved.
//

import UIKit

internal class CircleNumberButton: UIButton, NumberButton {
    
    var number: UInt8 = 0
    var fillColor: UIColor? = nil
    
    override func draw(_ rect: CGRect) {
        let oval = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        // Fill Color
        fillColor?.setFill()
        oval.fill()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchStartAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchEndAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEndAnimation()
    }
    
    private func touchStartAnimation(){
        UIView.animate(withDuration: 0.12,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: {() -> Void in
                        self.alpha = 0.4
        }, completion: nil)
    }
    
    private func touchEndAnimation(){
        UIView.animate(withDuration: 0.12,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: {() -> Void in
                        self.alpha = 1.0
        }, completion: nil)
    }
}
