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
    
    @IBOutlet weak var weekdaysTextField: CalculatorDaysTextField!
    @IBOutlet weak var restdaysTextField: CalculatorDaysTextField!
    
    @IBOutlet weak var tripsByMetroAtWeekdayTextField: CalculatorTripsTextField!
    @IBOutlet weak var tripsByGroundAtWeekdayTextField: CalculatorTripsTextField!
    
    @IBOutlet weak var tripsByMetroAtRestdayTextField: CalculatorTripsTextField!
    @IBOutlet weak var tripsByGroundAtRestdayTextField: CalculatorTripsTextField!
    
    @IBOutlet weak var commercialAmountTextField: CalculatorCommercialTextField!
    
    @IBOutlet weak var totalAmountLabel: TotalAmountLabel!
    
    // MARK: -
    
    var calculator: Calculator?
    
    // MARK: -
    
    var card: Card?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator = Calculator()
        setupView()
    }
    
    // MARK: - View methods
    
    private func setupView() {
        tripsByMetroAtWeekdayTextField.setup(calculator: calculator!, transport: .Metro, dayOfWeek: .Weekday)
        tripsByGroundAtWeekdayTextField.setup(calculator: calculator!, transport: .Ground, dayOfWeek: .Weekday)
        
        tripsByMetroAtRestdayTextField.setup(calculator: calculator!, transport: .Metro, dayOfWeek: .Restday)
        tripsByGroundAtRestdayTextField.setup(calculator: calculator!, transport: .Ground, dayOfWeek: .Restday)
        
        weekdaysTextField.setup(calculator: calculator!, dayOfWeek: .Weekday)
        restdaysTextField.setup(calculator: calculator!, dayOfWeek: .Restday)
        
        commercialAmountTextField.setup(calculator: calculator!)
        
        totalAmountLabel.setup(calculator: calculator!)
    }
    
    // MARK: - Actions
    
    @IBAction func topUpTheBalanceBySMS(_ sender: UIButton) {
        showTopUpTheBalanceBySMSAlert()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        tripsByMetroAtWeekdayTextField.resignFirstResponder()
        tripsByGroundAtWeekdayTextField.resignFirstResponder()
        
        tripsByMetroAtRestdayTextField.resignFirstResponder()
        tripsByGroundAtRestdayTextField.resignFirstResponder()
        
        weekdaysTextField.resignFirstResponder()
        restdaysTextField.resignFirstResponder()
        
        commercialAmountTextField.resignFirstResponder()
    }
    
    // MARK: - Helper methods
    
    private func showTopUpTheBalanceBySMSAlert() {
        let alertController = UIAlertController(title: "Enter card number and amount",
                                                message: "The application will generate an SMS-message for recharging the balance",
                                                preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.text = self.card?.number
            textField.placeholder = "Card Number"
            textField.keyboardType = .decimalPad
        }
        alertController.addTextField { (textField) in
            textField.text = "\(self.calculator!.getRoundedAmount())"
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let cardNumberTextField = alertController.textFields![0]
            let amountTextField = alertController.textFields![1]
            
            self.card?.number = cardNumberTextField.text!
            let amount = amountTextField.text!
            
            self.composeMessage(cardNumber: (self.card?.number)!, amount: amount)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true)
    }

    private func composeMessage(cardNumber: String, amount: String) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = "pod \(cardNumber) \(amount)"
            messageVC.recipients = [MessageSettings.recipient]
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true, completion: nil)
        } else {
            showSimpleAlert(title: "Sorry...", message: "This device is not configured to send messages.")
        }
    }
    
}

// MARK: - MFMessageComposeViewControllerDelegate methods

extension CalculatorViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case .cancelled:
            print("Message was cancelled")
        case .failed:
            print("Message failed")
        case .sent:
            print("Message was sent")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
