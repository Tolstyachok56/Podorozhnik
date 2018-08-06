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

    @IBOutlet weak var cardBalanceTextField: CardBalanceTextField!
    @IBOutlet weak var tripsByMetroTextField: TripsTextField!
    @IBOutlet weak var metroFareLabel: UILabel!
    
    // MARK: -

    var card: Card?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.card = Defaults.getCard()
        self.card?.delegate = self
        
        cardBalanceTextField.card = card
        
        tripsByMetroTextField.card = card
        tripsByMetroTextField.transport = .Metro
        
        setupNotificationHandling()
        setupView()
    }
    
    // MARK: - View methods
    
    private func setupView() {
        cardBalanceTextField.setup()
        tripsByMetroTextField.setup()
        setupMetroFareLabel()
    }
    
    private func setupMetroFareLabel() {
        metroFareLabel.text = "\(Fare.metro)"
    }
    
    private func updateView() {
        cardBalanceTextField.update()
        tripsByMetroTextField.update()
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

    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(updateCardBalance),
                                       name: NSNotification.Name.UITextFieldTextDidChange,
                                       object: nil)
    }
    
    @objc private func updateCardBalance() {
        if let balanceText = self.cardBalanceTextField.text, !balanceText.isEmpty {
            card?.balance = Double(balanceText)!
        } else {
            card?.balance = 0.0
        }
    }
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cardBalanceTextField.update()
    }
    
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
    
}

// MARK: - MFMessageComposeViewControllerDelegate methods

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

// MARK: - CardDelegate methods

extension TripRecordViewController: CardDelegate {
    
    func cardBalanceDidBecameLessThanFare(_ card: Card) {
        let alertController = UIAlertController(title: "Balance is less than fare", message: "Would you like to top up the balance?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.showTopUpTheBalanceAlert()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
