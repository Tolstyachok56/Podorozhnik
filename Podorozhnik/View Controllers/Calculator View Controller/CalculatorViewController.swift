//
//  CalculatorViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var weekdaysTextField: CalculatorDaysTextField!
    @IBOutlet weak var restdaysTextField: CalculatorDaysTextField!
    
    @IBOutlet weak var tripsByMetroAtWeekdayTextField: CalculatorTripsTextField!
    @IBOutlet weak var tripsByMetroAtRestdayTextField: CalculatorTripsTextField!
    
    @IBOutlet weak var commercialAmountTextField: CalculatorCommercialTextField!
    @IBOutlet weak var totalAmountLabel: TotalAmountLabel!
    
    
    // MARK: -
    
    var calculator: Calculator?

    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator = Calculator()
        setupView()
    }
    
    // MARK: - View methods
    
    private func setupView() {
        tripsByMetroAtWeekdayTextField.setup(calculator: calculator!, transport: .Metro, dayOfWeek: .Weekday)
        tripsByMetroAtRestdayTextField.setup(calculator: calculator!, transport: .Metro, dayOfWeek: .Restday)
        
        weekdaysTextField.setup(calculator: calculator!, dayOfWeek: .Weekday)
        restdaysTextField.setup(calculator: calculator!, dayOfWeek: .Restday)
        
        commercialAmountTextField.setup(calculator: calculator!)
        
        totalAmountLabel.setup(calculator: calculator!)
    }
    
    // MARK: - Actions
    
    @IBAction func topUpTheBalanceBySMS(_ sender: UIButton) {
        
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        tripsByMetroAtWeekdayTextField.resignFirstResponder()
        tripsByMetroAtRestdayTextField.resignFirstResponder()
        weekdaysTextField.resignFirstResponder()
        restdaysTextField.resignFirstResponder()
        commercialAmountTextField.resignFirstResponder()
    }
}
