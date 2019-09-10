//
//  PasswordView.swift
//  MocaLock
//
//  Created by yusuke saso on 2019/04/23.
//  Copyright © 2019 yusuke saso. All rights reserved.
//

import UIKit

///
public protocol MocaLockViewDelegate: class {
    // Called when password entry is complete. Please pass the password success or failure on the call destination.
    func mocaLockView(_ mocaLockView: MocaLockView, didCompletePassword password: String)
    func didTouchUpBioAuth(_ mocaLockView: MocaLockView)
}

/// 
public protocol MocaLockViewDataSource: class {
    func mocaLockView(_ mocaLockView: MocaLockView, buttonForNumber number: UInt8) -> NumberButton
    func mocaLockView(_ mocaLockView: MocaLockView, inputSignViewForCount count: UInt8) -> InputSignView
    func deleteButton(_ mocaLockView: MocaLockView) -> UIButton
    func bioAuthButton(_ mocaLockView: MocaLockView) -> UIButton
}


/// MocaLockView is responsible for UI layout, and completion of password input.
open class MocaLockView: UIView {
   
    // MARK: - Variable
    
    public weak var delegate: MocaLockViewDelegate? = nil
    public weak var dataSource: MocaLockViewDataSource? = nil
    
    private(set) var messageLabel = UILabel()
    // 0 on 9 Buttons.
    private(set) var numberButtons = [NumberButton]()
    private(set) var deleteButton: UIButton?
    // Valid button only for biometrics enabled devices.
    private(set) var bioAuthButton: UIButton?
    // UI to inform the client how many passwords have been entered.
    // This VIew will be regenerated if the `passwordCount` is changed
    private var inputSignViews = [InputSignView]()
    // `inputSignViews` is inserted.
    private let inputSignStackView = UIStackView()
    private let outputView = UIView()
    private(set) var inputedPassword: String = ""
    private(set) var highlightColor = UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1.0)
    // Number of password digits that must be entered. 1 to 8 recommended, other values do not guarantee the operation
    private(set) var passwordCount: UInt8 = 4
    private let winSize = UIScreen.main.bounds.size
    private let keyPadMargin: CGFloat = 24
    
    private let maxHeight: CGFloat = 640
    private let maxWidth: CGFloat = 320
    
    public convenience init(passwordCount: UInt8) {
        self.init()
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .clear
        
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        
        inputSignStackView.axis = .horizontal
        inputSignStackView.distribution = .equalCentering
        inputSignStackView.alignment = .center
        
        outputView.addSubview(messageLabel)
        outputView.addSubview(inputSignStackView)
    }
    
    // MARK: - Public Function
    
    /// Call this when changing DataSource.
    func reloadViews() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        guard let dataSource = dataSource else {
            log("dataSouce is null.")
            return
        }
        // MARK: - Create Views
        
        // Number Buttons
        numberButtons.forEach {
            $0.removeTarget(self, action: #selector(touchUpNumber(_:)), for: .touchUpInside)
        }
        numberButtons.removeAll()
        for cnt in 0...9 {
            let button = dataSource.mocaLockView(self, buttonForNumber: UInt8(cnt))
            button.addTarget(self, action: #selector(touchUpNumber(_:)), for: .touchUpInside)
            numberButtons.append(button)
        }
        
        deleteButton?.removeTarget(self, action: #selector(touchUpBioAuth(_:)), for: .touchUpInside)
        deleteButton = dataSource.deleteButton(self)
        deleteButton?.addTarget(self, action: #selector(touchUpDelete(_:)), for: .touchUpInside)
        
        bioAuthButton?.removeTarget(self, action: #selector(touchUpBioAuth(_:)), for: .touchUpInside)
        bioAuthButton = dataSource.bioAuthButton(self)
        bioAuthButton?.addTarget(self, action: #selector(touchUpBioAuth(_:)), for: .touchUpInside)
        
        // lines
        let numLine_1_StackView = UIStackView(arrangedSubviews: [numberButtons[1], numberButtons[2], numberButtons[3]])
        numLine_1_StackView.axis = .horizontal
        numLine_1_StackView.spacing = keyPadMargin
        let numLine_2_StackView = UIStackView(arrangedSubviews: [numberButtons[4], numberButtons[5], numberButtons[6]])
        numLine_2_StackView.axis = .horizontal
        numLine_2_StackView.spacing = keyPadMargin
        let numLine_3_StackView = UIStackView(arrangedSubviews: [numberButtons[7], numberButtons[8], numberButtons[9]])
        numLine_3_StackView.axis = .horizontal
        numLine_3_StackView.spacing = keyPadMargin
        let numLine_4_StackView = UIStackView()
        if let btn = bioAuthButton { numLine_4_StackView.addArrangedSubview(btn) }
        numLine_4_StackView.addArrangedSubview(numberButtons[0])
        if let btn = deleteButton { numLine_4_StackView.addArrangedSubview(btn) }
        numLine_4_StackView.axis = .horizontal
        numLine_4_StackView.spacing = keyPadMargin
        //
        let topMarginView = UIView()
        topMarginView.backgroundColor = UIColor.red
        let bottomMarginView = UIView()
        bottomMarginView.backgroundColor = UIColor.blue
        
        //// Contents Stack View
        let contentsVertStackView = UIStackView(arrangedSubviews:
            [topMarginView, outputView, numLine_1_StackView, numLine_2_StackView, numLine_3_StackView, numLine_4_StackView, bottomMarginView]
        )
        contentsVertStackView.axis = .vertical
        contentsVertStackView.distribution = .fill
        contentsVertStackView.alignment = .fill
        contentsVertStackView.spacing = keyPadMargin
        self.addSubview(contentsVertStackView)
        
        contentsVertStackView.translatesAutoresizingMaskIntoConstraints = false
        contentsVertStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentsVertStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentsVertStackView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        contentsVertStackView.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight).isActive = true
        
        ////////////////////
        // MARK: - set layout
        
        outputView.translatesAutoresizingMaskIntoConstraints = false
        outputView.heightAnchor.constraint(equalTo: contentsVertStackView.heightAnchor, multiplier: 0.15).isActive = true
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.widthAnchor.constraint(equalTo: outputView.widthAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: inputSignStackView.topAnchor, constant: -8).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        inputSignStackView.translatesAutoresizingMaskIntoConstraints = false
        inputSignStackView.widthAnchor.constraint(equalTo: outputView.widthAnchor, multiplier: 0.8).isActive = true
        inputSignStackView.centerYAnchor.constraint(equalTo: outputView.centerYAnchor).isActive = true
        inputSignStackView.centerXAnchor.constraint(equalTo: outputView.centerXAnchor).isActive = true
        
        
        contentsVertStackView.translatesAutoresizingMaskIntoConstraints = false
        let cntntsMaxWidthCnst = contentsVertStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        cntntsMaxWidthCnst.priority = UILayoutPriority(rawValue: 749)
        cntntsMaxWidthCnst.isActive = true
        let cntntsWidthCnst = contentsVertStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        cntntsWidthCnst.priority = UILayoutPriority(rawValue: 750)
        cntntsWidthCnst.isActive = true
        contentsVertStackView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 1.0).isActive = true
        contentsVertStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentsVertStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        numberButtons[2].widthAnchor.constraint(equalTo: numberButtons[1].widthAnchor).isActive = true
        numberButtons[3].widthAnchor.constraint(equalTo: numberButtons[1].widthAnchor).isActive = true
        numberButtons[5].widthAnchor.constraint(equalTo: numberButtons[4].widthAnchor).isActive = true
        numberButtons[6].widthAnchor.constraint(equalTo: numberButtons[4].widthAnchor).isActive = true
        numberButtons[8].widthAnchor.constraint(equalTo: numberButtons[7].widthAnchor).isActive = true
        numberButtons[9].widthAnchor.constraint(equalTo: numberButtons[7].widthAnchor).isActive = true
        numberButtons[0].widthAnchor.constraint(equalTo: bioAuthButton!.widthAnchor).isActive = true
        numberButtons.forEach {
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        }
        deleteButton!.widthAnchor.constraint(equalTo: bioAuthButton!.widthAnchor).isActive = true
        
        numLine_1_StackView.translatesAutoresizingMaskIntoConstraints = false
        numLine_2_StackView.translatesAutoresizingMaskIntoConstraints = false
        numLine_3_StackView.translatesAutoresizingMaskIntoConstraints = false
        numLine_4_StackView.translatesAutoresizingMaskIntoConstraints = false
        
        // margin view
        topMarginView.translatesAutoresizingMaskIntoConstraints = false
        bottomMarginView.translatesAutoresizingMaskIntoConstraints = false
        bottomMarginView.heightAnchor.constraint(equalTo: topMarginView.heightAnchor, multiplier: 0.7).isActive = true
        
        changePasswordCount(passwordCount: self.passwordCount)
    }
    
    func clearPassword() {
        self.inputedPassword = ""
        self.updateInputMarkViews()
    }
    
    /// Clear to inputed password, and remake inputMarkViews.
    /// passwordCount assumes 1 to 8 digits.
    /// Entering an expected value may cause layout problems.
    /// - Parameter passwordCount: Number of digits of password to enter
    func changePasswordCount(passwordCount: UInt8) {
        self.passwordCount = passwordCount
        self.inputedPassword = ""
        
        // Clear views
        inputSignViews.removeAll()
        inputSignStackView.subviews.forEach { $0.removeFromSuperview() }
        //// Input Mark Views
        inputSignViews.removeAll()
        inputSignStackView.subviews.forEach { $0.removeFromSuperview() }
        for cnt in 0..<passwordCount {
            guard let view = dataSource?.mocaLockView(self, inputSignViewForCount: cnt) else {
                fatalError("inputSignView is null.")
            }
            view.translatesAutoresizingMaskIntoConstraints = false
            inputSignViews.append(view)
            inputSignStackView.addArrangedSubview(view)
        }
        // Layout
        for view in inputSignViews {
            view.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
        }
    }
    
    // MARK: - Private Function
    
    private func updateInputMarkViews() {
        log("updateInputMarkViews \(inputedPassword.count)")
        let inputedCnt = inputedPassword.count
        for cnt in 0..<inputSignViews.count {
            if cnt < inputedCnt {
                inputSignViews[cnt].isInputed = true
            } else {
                inputSignViews[cnt].isInputed = false
            }
            inputSignViews[cnt].setNeedsDisplay()
        }
    }
    
    // MARK: - UI Event
    
    @objc func touchUpNumber(_ sender: UIButton) {
        log("touchUpNumber '\(sender.titleLabel?.text ?? "null")', \(passwordCount) \(inputedPassword.count)")
        guard let numBtn = sender as? NumberButton else {
            fatalError("touchUpNumber can't cast NumberButton.")
        }
        if inputedPassword.count < passwordCount {
            inputedPassword.append(numBtn.number.description)
            updateInputMarkViews()
        }
        if passwordCount == inputedPassword.count {
            log("touchUpNumber did complete")
            delegate?.mocaLockView(self, didCompletePassword: inputedPassword)
        }
    }
    
    @objc func touchUpDelete(_ sender: UIButton) {
        log("touchUpDelete")
        if inputedPassword.isEmpty == false {
            inputedPassword.removeLast()
            updateInputMarkViews()
        }
    }
    
    @objc func touchUpBioAuth(_ sender: UIButton) {
        // TODO:
        log("touchUpBioAuth")
        delegate?.didTouchUpBioAuth(self)
    }
    
    private func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
