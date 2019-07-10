//
//  CalculatorDateTableViewCell.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

class CalculatorDateTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let identifier: String = String(describing: CalculatorDateTableViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateButton: UIButton!
    
    // MARK: - Properties
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.titleLabel.text = viewModel.title
            self.dateButton.setTitle(viewModel.date, for: .normal)
        }
    }
    
    // MARK: - Actions
    @IBAction private func dateButtonPressed(_ sender: UIButton) {
        // TODO: - Реализовать выбор даты
        print("dateButtonPressed")
    }
}

extension CalculatorDateTableViewCell {
    struct ViewModel {
        var dateType: DateType
        var title: String
        var date: String
    }
}

extension CalculatorDateTableViewCell.ViewModel {
    init(dateType: DateType, calculator: Calculator) {
        self.dateType = dateType
        self.title = dateType.title
        switch dateType {
        case .start:
            self.date = calculator.startDate.mediumFormatting
        case .end:
            self.date = calculator.endDate.mediumFormatting
        }
    }
}

extension CalculatorDateTableViewCell.ViewModel {
    enum DateType {
        case start
        case end
    }
}

extension CalculatorDateTableViewCell.ViewModel.DateType {
    var title: String {
        switch self {
        case .start:
            return "Start Date"
        case .end:
            return "End Date"
        }
    }
}
