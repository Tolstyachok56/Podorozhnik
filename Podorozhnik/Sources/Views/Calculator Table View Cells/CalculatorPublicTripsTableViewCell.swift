//
//  CalculatorPublicTripsTableViewCell.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

protocol CalculatorPublicTripsTableViewCellDelegate: class {
    func calulatorPublicTripsTableViewCell(_ tableViewCell: CalculatorPublicTripsTableViewCell, numberOfMetroTripsDidEndEditing newNumberOfTrips: Int, weekdayType: CalculatorPublicTripsTableViewCell.ViewModel.WeekdayType)
    func calulatorPublicTripsTableViewCell(_ tableViewCell: CalculatorPublicTripsTableViewCell, numberOfGroundTripsDidEndEditing newNumberOfTrips: Int, weekdayType: CalculatorPublicTripsTableViewCell.ViewModel.WeekdayType)
}

class CalculatorPublicTripsTableViewCell: ShadowedTableViewCell {
    
    // MARK: - Static Properties
    static let identifier: String = String(describing: CalculatorPublicTripsTableViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var metroTripsTextField: UITextField!
    @IBOutlet weak var groundTripsTextField: UITextField!
    
    // MARK: - Properties
    weak var delegate: CalculatorPublicTripsTableViewCellDelegate?
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.titleLabel.text = viewModel.title
            self.metroTripsTextField.text = viewModel.tripsByMetro
            self.groundTripsTextField.text = viewModel.tripsByGround
        }
    }
    let countTextFieldDelegate = CountTextFieldDelegate()
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.countTextFieldDelegate.calculatorPublicTripsDelegate = self
        self.metroTripsTextField.delegate = countTextFieldDelegate
        self.groundTripsTextField.delegate = countTextFieldDelegate
        self.addShadow(isFirstRow: true, isLastRow: true)
    }
}

extension CalculatorPublicTripsTableViewCell {
    struct ViewModel {
        var weekdayType: WeekdayType
        var title: String
        var tripsByMetro: String
        var tripsByGround: String
    }
}

extension CalculatorPublicTripsTableViewCell.ViewModel {
    init(weekdayType: WeekdayType, calculator: Calculator) {
        self.weekdayType = weekdayType
        self.title = weekdayType.title
        switch weekdayType {
        case .weekday:
            self.tripsByMetro = "\(calculator.tripsByMetroAtWeekday)"
            self.tripsByGround = "\(calculator.tripsByGroundAtWeekday)"
        case .restday:
            self.tripsByMetro = "\(calculator.tripsByMetroAtRestday)"
            self.tripsByGround = "\(calculator.tripsByGroundAtRestday)"
        }
    }
}

extension CalculatorPublicTripsTableViewCell.ViewModel {
    enum WeekdayType {
        case weekday
        case restday
    }
}

extension CalculatorPublicTripsTableViewCell.ViewModel.WeekdayType {
    var title: String {
        switch self {
        case .weekday:
            return "Trips at Weekdays".localized
        case .restday:
            return "Trips at Restdays".localized
        }
    }
}

extension CalculatorPublicTripsTableViewCell: CalculatorPublicTripsDelegate {
    func calculatorPublicTripsTextField(_ textField: UITextField, numberOfTripsDidEndEditing newNumberOfTrips: Int) {
        if let weekdayType = self.viewModel?.weekdayType {
            if textField == self.metroTripsTextField {
                self.delegate?.calulatorPublicTripsTableViewCell(self, numberOfMetroTripsDidEndEditing: newNumberOfTrips, weekdayType: weekdayType)
            } else if textField == self.groundTripsTextField {
                self.delegate?.calulatorPublicTripsTableViewCell(self, numberOfGroundTripsDidEndEditing: newNumberOfTrips, weekdayType: weekdayType)
            }
        }
    }
}
