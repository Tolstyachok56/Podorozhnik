//
//  TripsTrackerViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

class TripsTrackerViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var tripsTrackerView: TripsTrackerView!
    @IBOutlet fileprivate weak var fareOfCommercialTextField: UITextField!
    
    // MARK: - Properties
    var transportCard: TransportCard?
    var publicTransportFaresController: PublicTransportFaresStateController!
    var transportCardsController: TransportCardsStateController!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerForKeyboardNotifications()
        self.transportCard = self.transportCardsController.transportCards.first
        self.updateView()
        self.tripsTrackerView.delegate = self
    }
    
    // MARK: - View methods
    private func updateView() {
        if let transportCard = self.transportCard {
            self.tripsTrackerView.viewModel = TripsTrackerView.ViewModel(transportCard)
        }
    }
    
    // MARK: - Notification Methods
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc private func keyboardDidShow(_ notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect /*,
            let tabBarHeight = tabBarController?.tabBar.frame.height*/ {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height/* - tabBarHeight*/ + 100, right: 0) // TODO: - Отступ расчитать
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    @objc private func keyboardDidHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Actions
    @IBAction private func topUpTheBalance(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter amount", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
            textField.textAlignment = .center
        }
        if let textField = alertController.textFields?.first {
            textField.delegate = self
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            if self.transportCard != nil,
                let amountText = alertController.textFields?.first?.text,
                let amount = Double(amountText) {
                let balance = self.transportCard!.balance + amount
                self.transportCardsController.setBalance(balance, forTransportCard: &self.transportCard!)
                self.updateView()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    @IBAction private func addTripPressed(_ sender: UIButton) {
        func addTrip(by transportType: TransportType, numberOfTrip: Int, fare: Double) {
            guard self.transportCard != nil else { return }
            if self.transportCard!.balance >= fare {
                let trip = Trip(transportType: transportType, numberOfTrip: numberOfTrip, fare: fare, date: Date())
                self.transportCardsController.addTrip(trip, forTransportCard: &self.transportCard!)
                self.updateView()
            } else {
                self.showSimpleAlert(title: "Oops!", message: "Your card balance is less than fare. You need to top up the balance.")
            }
        }
        
        switch sender.tag {
        case TransportType.metro.tag:
            guard self.transportCard != nil else { return }
            let numberOfTrip = self.transportCard!.numberOfTripsByMetro + 1
            let fare = self.publicTransportFaresController.getMetroFare(numberOfTrip: numberOfTrip)
            addTrip(by: .metro, numberOfTrip: numberOfTrip, fare: fare)

        case TransportType.ground.tag:
            let numberOfTrip = self.transportCard!.numberOfTripsByGround + 1
            let fare = self.publicTransportFaresController.getGroundFare(numberOfTrip: numberOfTrip)
            addTrip(by: .ground, numberOfTrip: numberOfTrip, fare: fare)
            
        case TransportType.commercial.tag:
            guard self.transportCard != nil,
                let text = self.fareOfCommercialTextField.text, !text.isEmpty,
                let fare = Double(text) else { return }
            let numberOfTrip = self.transportCard!.numberOfTripsByCommercial + 1
            addTrip(by: .commercial, numberOfTrip: numberOfTrip, fare: fare)
            self.fareOfCommercialTextField.text = ""

        default:
            break
        }
    }
    @IBAction private func reduceTripPressed(_ sender: UIButton) {
        func reduceTrip(by transportType: TransportType) {
            guard self.transportCard != nil else { return }
            self.transportCardsController.reduceTrip(by: transportType, fromTransportCard: &self.transportCard!)
            self.updateView()
        }
        
        switch sender.tag {
        case TransportType.metro.tag:
            reduceTrip(by: .metro)
        case TransportType.ground.tag:
            reduceTrip(by: .ground)
        case TransportType.commercial.tag:
            reduceTrip(by: .commercial)
            self.fareOfCommercialTextField.text = ""
        default:
            break
        }
    }
    
}

// MARK: - TransportCardBalanceDelegate
extension TripsTrackerViewController: TripsTrackerViewDelegate {
    func tripsTrackerView(_ tripsTrackerView: TripsTrackerView, cardBalanceDidEndEditing newBalance: Double) {
        guard self.transportCard != nil else { return }
        self.transportCardsController.setBalance(newBalance, forTransportCard: &self.transportCard!)
    }
}

// MARK: - UITextFieldDelegate
extension TripsTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        // check for decimal digits
        let allowedCharacters = CharacterSet(charactersIn: "1234567890\(decimalSeparator)")
        let characterSet = CharacterSet(charactersIn: string)
        let isNumber = allowedCharacters.isSuperset(of: characterSet)
        if !isNumber {
            return false
        } else {
            //check for more than one decimal separator
            let hasMoreThanOneDecimalSeparator: Bool
            guard let oldText = textField.text, let r = Range(range, in: oldText) else { return true }
            let existingTextHasDecimalSeparator = oldText.range(of: decimalSeparator)
            let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
            
            if existingTextHasDecimalSeparator != nil,
                replacementTextHasDecimalSeparator != nil{
                hasMoreThanOneDecimalSeparator = true
            } else {
                hasMoreThanOneDecimalSeparator = false
            }
            //get number of decimal digits
            let numberOfDecimalDigits: Int
            let newText = oldText.replacingCharacters(in: r, with: string)
            
            if let decimalSeparatorIndex = newText.firstIndex(of: Character(decimalSeparator)){
                numberOfDecimalDigits = newText.distance(from: decimalSeparatorIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            return !hasMoreThanOneDecimalSeparator && numberOfDecimalDigits <= 2
        }
    }
}
