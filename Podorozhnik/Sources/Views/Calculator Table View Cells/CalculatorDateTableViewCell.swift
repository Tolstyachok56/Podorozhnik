//
//  CalculatorDateTableViewCell.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

protocol CalculatorDateTableViewCellDelegate: UIViewController {
    func calculatorDateTableViewCell(_ cell: CalculatorDateTableViewCell, didPickDate date: Date, dateType: CalculatorDateTableViewCell.ViewModel.CalculatorDateType)
}

class CalculatorDateTableViewCell: ShadowedTableViewCell {
    
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
            self.dateButton.setTitle(viewModel.dateString, for: .normal)
            switch viewModel.dateType {
            case .start:
                self.addShadow(isFirstRow: true)
            case .end:
                self.addShadow(isLastRow: true)
            }
        }
    }
    weak var delegate: CalculatorDateTableViewCellDelegate?
    
    // MARK: - Actions
    @IBAction private func dateButtonPressed(_ sender: UIButton) {
        if let viewModel = self.viewModel {
            var title: String
            switch viewModel.dateType {
            case .start:
                title = "Choose start date".localized
            case .end:
                title = "Choose end date".localized
            }
        
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            let size = CGSize(width: alertController.view.bounds.width, height: CGFloat(216))
            
            let contentViewController = UIViewController()
            contentViewController.preferredContentSize = size
            
            let datePicker = UIDatePicker(frame: CGRect(origin: .zero, size: size))
            datePicker.datePickerMode = .date
            datePicker.minimumDate = Date()
            datePicker.date = viewModel.date
            
            contentViewController.view.addSubview(datePicker)
            alertController.setValue(contentViewController, forKey: "contentViewController")
            
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "OK".localized, style: .default) { (action) in
                self.delegate?.calculatorDateTableViewCell(self, didPickDate: datePicker.date.startOfDay, dateType: viewModel.dateType)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.delegate?.present(alertController, animated: true, completion: nil)
        }
    }
}

extension CalculatorDateTableViewCell {
    struct ViewModel {
        var dateType: CalculatorDateType
        var title: String
        var date: Date
        var dateString: String
    }
}

extension CalculatorDateTableViewCell.ViewModel {
    init(dateType: CalculatorDateType, calculator: Calculator) {
        self.dateType = dateType
        self.title = dateType.title
        switch dateType {
        case .start:
            self.date = calculator.startDate
            self.dateString = calculator.startDate.mediumFormatting
        case .end:
            self.date = calculator.endDate
            self.dateString = calculator.endDate.mediumFormatting
        }
    }
}

extension CalculatorDateTableViewCell.ViewModel {
    enum CalculatorDateType {
        case start
        case end
    }
}

extension CalculatorDateTableViewCell.ViewModel.CalculatorDateType {
    var title: String {
        switch self {
        case .start:
            return "Start Date".localized
        case .end:
            return "End Date".localized
        }
    }
}
