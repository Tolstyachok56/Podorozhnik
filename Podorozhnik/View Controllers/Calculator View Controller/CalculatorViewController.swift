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
    
    @IBOutlet weak var weekdaysTextField: UITextField!
    @IBOutlet weak var restdaysTextField: UITextField!
    
    @IBOutlet weak var tripsByMetroAtWeekdayTextField: UITextField!
    @IBOutlet weak var tripsByMetroAtRestDayTextField: UITextField!
    
    @IBOutlet weak var commercialAmountTextField: UITextField!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    
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
        tripsByMetroAtWeekdayTextField.text = "\((calculator?.tripsByMetroAtWeekday)!)"
        tripsByMetroAtRestDayTextField.text = "\((calculator?.tripsByMetroAtRestDay)!)"
        
        weekdaysTextField.text = "\((calculator?.weekdays)!)"
        restdaysTextField.text = "\((calculator?.restDays)!)"
        
        commercialAmountTextField.text = "\((calculator?.commercialAmount)!)"
        
        totalAmountLabel.text = "\((calculator?.getAmount())!)"
    }
    
    // MARK: - Actions
    
    @IBAction func topUpTheBalanceBySMS(_ sender: UIButton) {
    }
    
}

// MARK: - UITextFieldDelegate methods

extension CalculatorViewController: UITextFieldDelegate {
    
}
