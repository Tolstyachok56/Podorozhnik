//
//  TripRecordViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 02.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import MessageUI

class TripsTrackerViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cardBalanceTextField: CardBalanceTextField!

    @IBOutlet weak var tripsByMetroTextField: TripsTextField!
    @IBOutlet weak var metroTariffLabel: TariffLabel!

    @IBOutlet weak var tripsByGroundTextField: TripsTextField!
    @IBOutlet weak var groundTariffLabel: TariffLabel!

    @IBOutlet weak var tripsByCommercialTextField: TripsTextField!
    @IBOutlet weak var commercialTariffTextField: CommercialTariffTextField!

    // MARK: -
    
    private var card: Card?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCard()
        
        registerForKeyboardNotifications()
        
        setupView()
    }
    
    // MARK: - Methods
    
    private func getCard() {
        self.card = Defaults.getCard()
        self.card?.delegate = self
        
        for viewController in (tabBarController?.viewControllers)! {
            if let statisticsVC = viewController as? StatisticsTableViewController {
                statisticsVC.statistics = self.card?.statistics
            } else if let calculatorVC = viewController as? CalculatorViewController {
                calculatorVC.card = self.card
            } else if let smsVC = viewController as? SMSViewController {
                smsVC.card = self.card
                smsVC.amount = 0
            }
        }
    }

    // MARK: - View methods
    
    private func setupView() {
        cardBalanceTextField.setup(card: card!)
        
        tripsByMetroTextField.setup(card: card!, transport: .metro)
        metroTariffLabel.setup(card: card!, transport: .metro)
        
        tripsByGroundTextField.setup(card: card!, transport: .ground)
        groundTariffLabel.setup(card: card!, transport: .ground)
        
        commercialTariffTextField.setup(card: card!)
        tripsByCommercialTextField.setup(card: card!, transport: .commercial)
    }
    
    private func updateView() {
        cardBalanceTextField.update()
        
        tripsByMetroTextField.update()
        metroTariffLabel.update()
        
        tripsByGroundTextField.update()
        groundTariffLabel.update()
        
        commercialTariffTextField.update()
        tripsByCommercialTextField.update()
    }
    
    // MARK: - Actions
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        cardBalanceTextField.resignFirstResponder()
        commercialTariffTextField.resignFirstResponder()
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

    @IBAction func addGroundTrip(_ sender: UIButton) {
        card?.addTripByGround()
        updateView()
    }
    
    @IBAction func reduceGroundTrip(_ sender: UIButton) {
        card?.reduceTripByGround()
        updateView()
    }

    @IBAction func addCommercialTrip(_ sender: UIButton) {
        card?.addTripByCommercial(tariff: commercialTariffTextField.getTariff())
        updateView()
    }
    
    @IBAction func reduceCommercialTrip(_ sender: UIButton) {
        card?.reduceTripByCommercial(tariff: commercialTariffTextField.getTariff())
        updateView()
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

// MARK: - CardDelegate methods

extension TripsTrackerViewController: CardDelegate {
    
    func cardBalanceDidBecameLessThanTariff(_ card: Card) {
        let alertController = UIAlertController(title: "Balance is less than tariff", message: "Would you like to top up the balance by SMS?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            for viewController in (self.tabBarController?.viewControllers)! {
                if let smsVC = viewController as? SMSViewController {
                    smsVC.amount = 0
                    let index = self.tabBarController?.viewControllers?.index(of: smsVC)
                    self.tabBarController?.selectedIndex = index!
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
