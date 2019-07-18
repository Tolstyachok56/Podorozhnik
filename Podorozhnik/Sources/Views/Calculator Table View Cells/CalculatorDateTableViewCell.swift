//
//  CalculatorDateTableViewCell.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

protocol CalculatorDateTableViewCellDelegate: UIViewController {
    func presentPickerAlertController(_ alertController: UIAlertController)
    func calculatorDateTableViewCellDidPickDate(_ date: Date, dateType: CalculatorDateTableViewCell.ViewModel.CalculatorDateType)
}

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
            self.dateButton.setTitle(viewModel.dateString, for: .normal)
        }
    }
    weak var delegate: CalculatorDateTableViewCellDelegate?
    
    // MARK: - Actions
    @IBAction private func dateButtonPressed(_ sender: UIButton) {
        if let viewModel = self.viewModel {
            var title: String
            switch viewModel.dateType {
            case .start:
                title = "Choose start date"
            case .end:
                title = "Choose end date"
                
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
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.delegate?.calculatorDateTableViewCellDidPickDate(datePicker.date.startOfDay, dateType: viewModel.dateType)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.delegate?.presentPickerAlertController(alertController)
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
            return "Start Date"
        case .end:
            return "End Date"
        }
    }
}
