//
//  CalculatorAmountTableViewCell.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

class CalculatorAmountTableViewCell: ShadowedTableViewCell {
    
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
            self.missingAmountLabel.textColor = viewModel.missingAmountColor
        }
    }
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addShadow(isFirstRow: true, isLastRow: true)
    }
}

extension CalculatorAmountTableViewCell {
    struct ViewModel {
        var totalAmount: String
        var missingAmount: String
        var missingAmountColor: UIColor
    }
}

extension CalculatorAmountTableViewCell.ViewModel {
    init(_ calculatorController: CalculatorController) {
        self.totalAmount = String(calculatorController.getTotalAmount()).rublesGroupedFormatting!
        let missAmount = calculatorController.getMissingAmount() ?? 0
        self.missingAmount = String(missAmount).rublesGroupedFormatting ?? "?"
        if #available(iOS 13.0, *) {
            self.missingAmountColor = (missAmount == 0) ? .label : .red
        } else {
            self.missingAmountColor = (missAmount == 0) ? .black : .red
        }
    }
}
