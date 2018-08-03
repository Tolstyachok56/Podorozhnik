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
    
    // MARK: - Properties

    @IBOutlet weak var cardBalanceTextField: UITextField!
    @IBOutlet weak var tripsByMetroTextField: UITextField!
    @IBOutlet weak var metroFareLabel: UILabel!
    
    // MARK: -

    var card: Card?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.card = Defaults.getCard()
        setupView()
    }
    
    // MARK: - View methods
    
    private func setupView() {
        setupCardBalanceTextField()
        setupMetroFareLabel()
        setupTripsByMetroTextField()
    }
    
    private func setupCardBalanceTextField() {
        updateCardBalanceTextField()
    }
    
    private func setupMetroFareLabel() {
        metroFareLabel.text = "\(Fare.metro)"
    }
    
    private func setupTripsByMetroTextField() {
        updateTripsByMetroTextField()
    }
    
    private func updateView() {
        updateTripsByMetroTextField()
        updateCardBalanceTextField()
    }
    
    private func updateCardBalanceTextField() {
        guard let balance = card?.balance else {
            cardBalanceTextField.text = "\(0.0)"
            return
        }
        cardBalanceTextField.text = "\(balance)"
    }
    
    private func updateTripsByMetroTextField() {
        guard let tripsByMetro = card?.tripsByMetro else {
            tripsByMetroTextField.text = "0"
            return
        }
        tripsByMetroTextField.text = "\(tripsByMetro)"
    }

    // MARK: - Actions

    @IBAction func addMetroTrip(_ sender: UIButton) {
        card?.addTripsByMetro(1)
        updateView()
    }
    
    @IBAction func topUpTheBalance(_ sender: UIButton) {
        showTopUpTheBalanceAlert()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        cardBalanceTextField.resignFirstResponder()
    }
    
    // MARK: - Helper methods
    
    private func composeMessage(cardNumber: String, amount: String) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = "pod \(cardNumber) \(amount)"
            messageVC.recipients = [MessageSettings.recipient]
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true, completion: nil)
        } else {
            print("This device is not configured to send messages")
        }
    }
    
    private func showTopUpTheBalanceAlert() {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.text = self.card?.number
            textField.placeholder = "Card Number"
            textField.keyboardType = .decimalPad
        }
        alertController.addTextField { (textField) in
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
        if let balanceText = self.cardBalanceTextField.text, !balanceText.isEmpty {
            card?.balance = Double(balanceText)!
        } else {
            card?.balance = 0.0
        }
        updateCardBalanceTextField()
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
