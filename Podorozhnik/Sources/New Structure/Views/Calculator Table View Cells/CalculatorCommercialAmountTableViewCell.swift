//
//  CalculatorCommercialTripsTableViewCell.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

protocol CalculatorCommercialAmountTableViewCellDelegate: class {
    func calculatorCommercialAmountTableViewCell(_ tableViewCell: CalculatorCommercialAmountTableViewCell, commercialAmountDidEndEditing newAmount: Double)
}

class CalculatorCommercialAmountTableViewCell: UITableViewCell {

    // MARK: - Static Properties
    static let identifier: String = String(describing: CalculatorCommercialAmountTableViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var commercialAmountTextField: UITextField!
    
    // MARK: - Properties
    weak var delegate: CalculatorCommercialAmountTableViewCellDelegate?
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.titleLabel.text = viewModel.title
            self.commercialAmountTextField.text = viewModel.commercialAmount
        }
    }
    let currencyTextFieldDelegate = CurrencyTextFieldDelegate()
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.currencyTextFieldDelegate.calculatorCommercialAmountDelegate = self
        self.commercialAmountTextField.delegate = currencyTextFieldDelegate
        self.commercialAmountTextField.tag = CurrencyTextFieldDelegate.Tag.calculatorCommercialAmount.rawValue
    }
}

extension CalculatorCommercialAmountTableViewCell {
    struct ViewModel {
        var title: String
        var commercialAmount: String
    }
}

extension CalculatorCommercialAmountTableViewCell.ViewModel {
    init(calculator: Calculator) {
        self.title = "Commercial"
        self.commercialAmount = "\(calculator.commercialAmount)"
    }
}

extension CalculatorCommercialAmountTableViewCell: CalculatorCommercialAmountDelegate {
    func calculatorCommercialAmountTextField(_ textField: UITextField, commercialAmountDidEndEditing newAmount: Double) {
        self.delegate?.calculatorCommercialAmountTableViewCell(self, commercialAmountDidEndEditing: newAmount)
    }
}
