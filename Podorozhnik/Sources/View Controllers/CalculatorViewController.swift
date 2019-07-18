//
//  CalculatorViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            self.tableView.estimatedRowHeight = 44
            self.tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    // MARK: - Properties
    var transportCard: TransportCard?
    var publicTransportFaresController: PublicTransportFaresStateController!
    var transportCardsController: TransportCardsStateController!
    var calculatorController: CalculatorController!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.transportCard = self.transportCardsController.transportCards.first
        if let transportCard = self.transportCard {
            self.calculatorController = CalculatorController(calculator: Calculator(), transportCard: transportCard, publicTransportFares: self.publicTransportFaresController)
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func viewTapped(_ gesture: UITapGestureRecognizer) {
        let cells = self.tableView.visibleCells
        for cell in cells {
            if let cell = cell as? CalculatorPublicTripsTableViewCell {
                cell.metroTripsTextField.resignFirstResponder()
                cell.groundTripsTextField.resignFirstResponder()
            } else if let cell = cell as? CalculatorCommercialAmountTableViewCell {
                cell.commercialAmountTextField.resignFirstResponder()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension CalculatorViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1...4:
            return 1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let calculator = self.calculatorController?.calculator else { return UITableViewCell()}
        
        switch indexPath {
            
        case IndexPath(row: 0, section: 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: CalculatorDateTableViewCell.identifier, for: indexPath) as! CalculatorDateTableViewCell
            cell.viewModel = CalculatorDateTableViewCell.ViewModel(dateType: .start, calculator: calculator)
            cell.delegate = self
            return cell
            
        case IndexPath(row: 1, section: 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: CalculatorDateTableViewCell.identifier, for: indexPath) as! CalculatorDateTableViewCell
            cell.viewModel = CalculatorDateTableViewCell.ViewModel(dateType: .end, calculator: calculator)
            cell.delegate = self
            return cell
            
        case IndexPath(row: 0, section: 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: CalculatorPublicTripsTableViewCell.identifier, for: indexPath) as! CalculatorPublicTripsTableViewCell
            cell.viewModel = CalculatorPublicTripsTableViewCell.ViewModel(weekdayType: .weekday, calculator: calculator)
            cell.delegate = self
            return cell
            
        case IndexPath(row: 0, section: 2):
            let cell = tableView.dequeueReusableCell(withIdentifier: CalculatorPublicTripsTableViewCell.identifier, for: indexPath) as! CalculatorPublicTripsTableViewCell
            cell.viewModel = CalculatorPublicTripsTableViewCell.ViewModel(weekdayType: .restday, calculator: calculator)
            cell.delegate = self
            return cell
            
        case IndexPath(row: 0, section: 3):
            let cell = tableView.dequeueReusableCell(withIdentifier: CalculatorCommercialAmountTableViewCell.identifier, for: indexPath) as! CalculatorCommercialAmountTableViewCell
            cell.viewModel = CalculatorCommercialAmountTableViewCell.ViewModel(calculator: calculator)
            cell.delegate = self
            return cell
            
        case IndexPath(row: 0, section: 4):
            let cell = tableView.dequeueReusableCell(withIdentifier: CalculatorAmountTableViewCell.identifier, for: indexPath) as! CalculatorAmountTableViewCell
            cell.viewModel = CalculatorAmountTableViewCell.ViewModel(self.calculatorController)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension CalculatorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat(8)
        default:
            return CGFloat(0.0001)
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  CGFloat(8)
    }
}

// MARK: - CalculatorPublicTripsTableViewCellDelegate
extension CalculatorViewController: CalculatorPublicTripsTableViewCellDelegate {
    func calulatorPublicTripsTableViewCell(_ tableViewCell: CalculatorPublicTripsTableViewCell, numberOfMetroTripsDidEndEditing newNumberOfTrips: Int, weekdayType: CalculatorPublicTripsTableViewCell.ViewModel.WeekdayType) {
        switch weekdayType {
        case .weekday:
            self.calculatorController.calculator.tripsByMetroAtWeekday = newNumberOfTrips
        case .restday:
            self.calculatorController.calculator.tripsByMetroAtRestday = newNumberOfTrips
        }
        self.tableView.reloadData()
    }
    
    func calulatorPublicTripsTableViewCell(_ tableViewCell: CalculatorPublicTripsTableViewCell, numberOfGroundTripsDidEndEditing newNumberOfTrips: Int, weekdayType: CalculatorPublicTripsTableViewCell.ViewModel.WeekdayType) {
        switch weekdayType {
        case .weekday:
            self.calculatorController.calculator.tripsByGroundAtWeekday = newNumberOfTrips
        case .restday:
            self.calculatorController.calculator.tripsByGroundAtRestday = newNumberOfTrips
        }
        self.tableView.reloadData()
    }
}

// MARK: - CalculatorCommercialAmountTableViewCellDelegate
extension CalculatorViewController: CalculatorCommercialAmountTableViewCellDelegate {
    func calculatorCommercialAmountTableViewCell(_ tableViewCell: CalculatorCommercialAmountTableViewCell, commercialAmountDidEndEditing newAmount: Double) {
        self.calculatorController.calculator.commercialAmount = newAmount
        self.tableView.reloadData()
    }
}

// MARK: -
extension CalculatorViewController: CalculatorDateTableViewCellDelegate {
    func presentPickerAlertController(_ alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func calculatorDateTableViewCellDidPickDate(_ date: Date, dateType: CalculatorDateTableViewCell.ViewModel.CalculatorDateType) {
        switch dateType {
        case .start:
            self.calculatorController.calculator.startDate = date
        case .end:
            self.calculatorController.calculator.endDate = date
        }
        self.tableView.reloadData()
    }
}
