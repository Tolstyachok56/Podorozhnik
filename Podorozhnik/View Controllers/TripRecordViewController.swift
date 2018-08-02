//
//  TripRecordViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 02.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import MessageUI

class TripRecordViewController: UIViewController {
    
    // MARK: - Constants
    
    let metroFare: Float = 36.0
    let messageRecipient: String = "7878"
    
    // MARK: - Properties

    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var numberOfMetroTripsTextField: UITextField!
    @IBOutlet weak var metroFareLabel: UILabel!
    
    // MARK: -
    
    private var cardBalance: Float? = 0.0
    private var numberOfMetroTrips: Int = 0
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - View methods
    
    private func setupView() {
        setupBalanceTextField()
        setupMetroFareLabel()
        setupNumberOfMetroTripsTextField()
    }
    
    private func setupBalanceTextField() {
        updateBalanceTextField()
    }
    
    private func setupMetroFareLabel() {
        metroFareLabel.text = "\(metroFare)"
    }
    
    private func setupNumberOfMetroTripsTextField() {
        updateNumberOfMetroTripsTextField()
    }
    
    private func updateView() {
        updateNumberOfMetroTripsTextField()
        updateBalanceTextField()
    }
    
    private func updateBalanceTextField() {
        guard let balance = self.cardBalance else {
            balanceTextField.text = "\(0.0)"
            return
        }
        balanceTextField.text = "\(balance)"
    }
    
    private func updateNumberOfMetroTripsTextField() {
        numberOfMetroTripsTextField.text = "\(self.numberOfMetroTrips)"
    }

    // MARK: - Actions

    @IBAction func addMetroTrip(_ sender: UIButton) {
        numberOfMetroTrips += 1
        subtractFromBalance(amount: metroFare)
        updateView()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        balanceTextField.resignFirstResponder()
    }
    
    fileprivate func composeMessage(cardNumber: String, amount: String) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = "pod \(cardNumber) \(amount)"
            messageVC.recipients = [messageRecipient]
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true, completion: nil)
        } else {
            print("This device is not configured to send messages")
        }
    }
    
    @IBAction func topUpTheBalance(_ sender: UIButton) {
        composeMessage(cardNumber: "96433078[cardnumber]", amount: "[amount]")
    }
    
    
    // MARK: - Helper methods
    
    private func subtractFromBalance(amount: Float) {
        if let balance = self.cardBalance {
            self.cardBalance = balance - amount
        }
    }
}

// MARK: - UITextFieldDelegate methods

extension TripRecordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let oldText = textField.text, let r = Range(range, in: oldText) else { return true }
        let newText = oldText.replacingCharacters(in: r, with: string)
        
        //check decimal separator
        let hasMoreThanOneDecimalSeparator: Bool
        
        let existingTextHasDecimalSeparator = oldText.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        if existingTextHasDecimalSeparator != nil,
            replacementTextHasDecimalSeparator != nil{
            hasMoreThanOneDecimalSeparator = true
        } else {
            hasMoreThanOneDecimalSeparator = false
        }
        
        //check for 2 decimal digits
        let numberOfDecimalDigits: Int
        
        if let decimalSeparatorIndex = newText.index(of: "."){
            numberOfDecimalDigits = newText.distance(from: decimalSeparatorIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return !hasMoreThanOneDecimalSeparator && numberOfDecimalDigits <= 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let balanceText = self.balanceTextField.text, !balanceText.isEmpty {
            self.cardBalance = Float(balanceText)
        } else {
            self.cardBalance = 0.0
        }
        updateBalanceTextField()
    }
    
}

extension TripRecordViewController: MFMessageComposeViewControllerDelegate {
    
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
