//
//  SMSViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 14.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class SMSViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cardNumberTextField: CardNumberTextField!
    @IBOutlet weak var amountTextField: AmountTextField!
    
    // MARK: -
    
    var card: Card?
    var amount: Int?
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        setupView()
    }
    
    // MARK: - View methods
    
    private func setupView() {
        cardNumberTextField.setup(card: card!)
        amountTextField.setup(amount: amount!)
    }
    
    // MARK: - Actions
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        cardNumberTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func makeTopUpTheBalanceMessage(_ sender: UIButton) {
        
    }
    
    // MARK: - Notifications methods
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc private func keyboardWasShown(_ notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect, let tabBarHeight = tabBarController?.tabBar.frame.height {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - tabBarHeight + 10, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc private func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

}
