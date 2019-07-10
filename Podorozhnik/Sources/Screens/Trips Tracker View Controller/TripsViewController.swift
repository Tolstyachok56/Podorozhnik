//
//  TripRecordViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 02.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import MessageUI

class TripsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cardBalanceTextField: OldCardBalanceTextField!

    @IBOutlet weak var tripsByMetroTextField: TripsTextField!
    @IBOutlet weak var metroTariffLabel: TariffLabel!

    @IBOutlet weak var tripsByGroundTextField: TripsTextField!
    @IBOutlet weak var groundTariffLabel: TariffLabel!

    @IBOutlet weak var tripsByCommercialTextField: TripsTextField!
    @IBOutlet weak var commercialTariffTextField: CommercialTariffTextField!

    // MARK: - Properties
    private var card: Card?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCard()
        self.registerForKeyboardNotifications()
        self.setupView()
    }

    // MARK: - View Methods
    private func setupView() {
        self.cardBalanceTextField.setup(card: self.card!)
        
        self.tripsByMetroTextField.setup(card: self.card!, transport: .metro)
        self.metroTariffLabel.setup(card: self.card!, transport: .metro)
        
        self.tripsByGroundTextField.setup(card: self.card!, transport: .ground)
        self.groundTariffLabel.setup(card: self.card!, transport: .ground)
        
        self.commercialTariffTextField.setup(card: self.card!)
        self.tripsByCommercialTextField.setup(card: self.card!, transport: .commercial(tariff: 0))
    }
    
    private func updateView() {
        self.cardBalanceTextField.update()
        
        self.tripsByMetroTextField.update()
        self.metroTariffLabel.update()
        
        self.tripsByGroundTextField.update()
        self.groundTariffLabel.update()
        
        self.commercialTariffTextField.update()
        self.tripsByCommercialTextField.update()
    }
    
    // MARK: - Methods
    private func getCard() {
        self.card = Defaults.getCard()
        self.card?.delegate = self
        
        for viewController in (tabBarController?.viewControllers)! {
            if let statisticsVC = viewController as? StatisticsTableViewController {
                statisticsVC.statistics = self.card?.statistics
            } else if let calculatorTVC = viewController as? OldCalculatorTableViewController {
                calculatorTVC.card = self.card
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.cardBalanceTextField.resignFirstResponder()
        self.commercialTariffTextField.resignFirstResponder()
    }
    
    @IBAction func topUpTheBalance(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter amount", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            if let amountText = alertController.textFields?.first?.text,
                let amount = amountText.double {
                self.card?.topUpTheBalance(amount: amount)
                self.cardBalanceTextField.update()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addMetroTrip(_ sender: UIButton) {
        self.card?.addTrip(by: .metro)
        self.updateView()
    }
    
    @IBAction func reduceMetroTrip(_ sender: UIButton) {
        self.card?.reduceTrip(by: .metro)
        self.updateView()
    }

    @IBAction func addGroundTrip(_ sender: UIButton) {
        self.card?.addTrip(by: .ground)
        self.updateView()
    }
    
    @IBAction func reduceGroundTrip(_ sender: UIButton) {
        self.card?.reduceTrip(by: .ground)
        self.updateView()
    }

    @IBAction func addCommercialTrip(_ sender: UIButton) {
        self.card?.addTrip(by: .commercial(tariff: self.commercialTariffTextField.getTariff()))
        self.commercialTariffTextField.text = Double(0).priceFormat()
        self.updateView()
    }
    
    @IBAction func reduceCommercialTrip(_ sender: UIButton) {
        self.card?.reduceTrip(by: .commercial(tariff: self.commercialTariffTextField.getTariff()))
        self.updateView()
    }
    
    // MARK: - Notification Methods
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc private func keyboardDidShow(_ notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let tabBarHeight = tabBarController?.tabBar.frame.height {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - tabBarHeight + 10, right: 0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    @objc private func keyboardDidHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
}

// MARK: - CardDelegate
extension TripsViewController: CardDelegate {
    
    func cardBalanceDidBecameLessThanTariff(_ card: Card) {
        self.showSimpleAlert(title: "Balance is running low", message: "Card's balance is less than tariff. You need to top up the balance.")
    }
    
}
