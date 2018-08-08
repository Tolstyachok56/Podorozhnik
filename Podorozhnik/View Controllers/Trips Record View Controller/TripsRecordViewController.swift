//
//  TripRecordViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 02.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import MessageUI

class TripsRecordViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var cardBalanceTextField: CardBalanceTextField!
    @IBOutlet weak var tripsByMetroTextField: TripsTextField!
    @IBOutlet weak var metroFareLabel: FareLabel!
    
    // MARK: -

    var card: Card?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.card = Defaults.getCard()
        self.card?.delegate = self
        
        setupView()
    }
    
    // MARK: - View methods
    
    private func setupView() {
        cardBalanceTextField.setup(card: card!)
        tripsByMetroTextField.setup(card: card!, transport: .Metro)
        metroFareLabel.setup(card: card!, transport: .Metro)
    }
    
    private func updateView() {
        cardBalanceTextField.update()
        tripsByMetroTextField.update()
        metroFareLabel.update()
    }
    
    // MARK: - Actions

    @IBAction func topUpTheBalance(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter amount", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            if let amountText = alertController.textFields?.first?.text,
                let amount = Double(amountText) {
                self.card?.topUpTheBalance(amount: amount)
                self.cardBalanceTextField.update()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addMetroTrip(_ sender: UIButton) {
        card?.addTripByMetro()
        updateView()
    }
    
    @IBAction func reduceMetroTrip(_ sender: UIButton) {
        card?.reduceTripByMetro()
        updateView()
    }
    
    @IBAction func topUpTheBalanceBySMS(_ sender: UIButton) {
        showTopUpTheBalanceBySMSAlert()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        cardBalanceTextField.resignFirstResponder()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "ShowStatistics":
            guard let destination = segue.destination as? StatisticsTableViewController else { return }
            destination.statistics = card?.statistics
        case "ShowCalculator":
            guard let destination = segue.destination as? CalculatorViewController else { return }
        default:
            fatalError("Unexpected segue identifier")
        }
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
            showSimpleAlert(title: "Sorry...", message: "This device is not configured to send messages.")
        }
    }
    
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

// MARK: - MFMessageComposeViewControllerDelegate methods

extension TripsRecordViewController: MFMessageComposeViewControllerDelegate {
    
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

extension TripsRecordViewController: CardDelegate {
    
    func cardBalanceDidBecameLessThanFare(_ card: Card) {
        let alertController = UIAlertController(title: "Balance is less than fare", message: "Would you like to top up the balance?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.showTopUpTheBalanceBySMSAlert()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
