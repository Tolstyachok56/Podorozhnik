//
//  CalculatorAmountTableViewCell.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

class CalculatorAmountTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let identifier: String = String(describing: CalculatorAmountTableViewCell.self)

    // MARK: - Outlets
    @IBOutlet private weak var totalAmountLabel: UILabel!
    @IBOutlet private weak var missingAmountLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.totalAmountLabel.text = viewModel.totalAmount
            self.missingAmountLabel.text = viewModel.missingAmount
        }
    }
}

extension CalculatorAmountTableViewCell {
    struct ViewModel {
        var totalAmount: String
        var missingAmount: String
    }
}

extension CalculatorAmountTableViewCell.ViewModel {
    init(_ calculatorController: CalculatorController) {
        self.totalAmount = String(calculatorController.getTotalAmount())
        self.missingAmount = String(calculatorController.getMissingAmount() ?? 0)
    }
}
