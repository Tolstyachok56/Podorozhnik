//
//  CalculatorViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import MessageUI

class CalculatorViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var daysTextField: CalculatorDaysTextField!
    @IBOutlet weak var dateIntervalLabel: DateIntervalLabel!
    
    @IBOutlet weak var tripsByMetroAtWeekdayTextField: CalculatorTripsTextField!
    @IBOutlet weak var tripsByGroundAtWeekdayTextField: CalculatorTripsTextField!
    
    @IBOutlet weak var tripsByMetroAtRestdayTextField: CalculatorTripsTextField!
    @IBOutlet weak var tripsByGroundAtRestdayTextField: CalculatorTripsTextField!
    
    @IBOutlet weak var commercialAmountTextField: CalculatorCommercialTextField!
    
    @IBOutlet weak var totalAmountLabel: TotalAmountLabel!
    
    @IBOutlet weak var topUpTheBalanceButton: UIButton!
    // MARK: -
    
    var calculator: Calculator?
    
    // MARK: -
    
    var card: Card?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculator = Calculator()
        calculator?.card = card
        
        registerForKeyboardNotifications()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    // MARK: - View methods
    
    private func setupView() {
        daysTextField.setup(calculator: calculator!)
        dateIntervalLabel.setup(calculator: calculator!)
        
        tripsByMetroAtWeekdayTextField.setup(calculator: calculator!, transport: .metro, dayOfWeek: .weekday)
        tripsByGroundAtWeekdayTextField.setup(calculator: calculator!, transport: .ground, dayOfWeek: .weekday)
        
        tripsByMetroAtRestdayTextField.setup(calculator: calculator!, transport: .metro, dayOfWeek: .restday)
        tripsByGroundAtRestdayTextField.setup(calculator: calculator!, transport: .ground, dayOfWeek: .restday)
        
        commercialAmountTextField.setup(calculator: calculator!)
        
        totalAmountLabel.setup(calculator: calculator!)
        
        setupTopUpTheBalanceButton()
    }
    
    private func setupTopUpTheBalanceButton() {
        topUpTheBalanceButton.layer.cornerRadius = 5
    }
    
    private func updateView() {
        daysTextField.update()
        dateIntervalLabel.update()
        
        tripsByMetroAtWeekdayTextField.update()
        tripsByGroundAtWeekdayTextField.update()
        
        tripsByMetroAtRestdayTextField.update()
        tripsByGroundAtRestdayTextField.update()
        
        commercialAmountTextField.update()
        
        totalAmountLabel.update()
    }
    
    // MARK: - Actions
    
    @IBAction func topUpTheBalanceBySMS(_ sender: UIButton) {
        for viewController in (tabBarController?.viewControllers)! {
            if let smsVC = viewController as? SMSViewController {
                smsVC.amount = calculator?.getRoundedTotalAmount()
                let index = tabBarController?.viewControllers?.index(of: smsVC)
                self.tabBarController?.selectedIndex = index!
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        daysTextField.resignFirstResponder()
        
        tripsByMetroAtWeekdayTextField.resignFirstResponder()
        tripsByGroundAtWeekdayTextField.resignFirstResponder()
        
        tripsByMetroAtRestdayTextField.resignFirstResponder()
        tripsByGroundAtRestdayTextField.resignFirstResponder()
        
        commercialAmountTextField.resignFirstResponder()
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
