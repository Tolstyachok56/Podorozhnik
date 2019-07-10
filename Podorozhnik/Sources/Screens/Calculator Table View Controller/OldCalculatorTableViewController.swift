//
//  OldCalculatorTableViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 27.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class OldCalculatorTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var startDateButton: DateButton!
    @IBOutlet weak var endDateButton: DateButton!
    
    @IBOutlet weak var tripsByMetroAtWeekdayTextField: CalculatorTripsTextField!
    @IBOutlet weak var tripsByGroundAtWeekdayTextField: CalculatorTripsTextField!
    
    @IBOutlet weak var tripsByMetroAtRestdayTextField: CalculatorTripsTextField!
    @IBOutlet weak var tripsByGroundAtRestdayTextField: CalculatorTripsTextField!
    
    @IBOutlet weak var commercialAmountTextField: CalculatorCommercialTextField!
    
    @IBOutlet weak var totalAmountLabel: TotalAmountLabel!
    @IBOutlet weak var missingAmountLabel: MissingAmountLabel!
    
    // MARK: - Properties
    var calculator: CalculatorOld?
    var card: Card?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calculator = CalculatorOld()
        self.calculator?.card = card
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateView()
    }
    
    // MARK: - View Methods
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        
        self.startDateButton.setup(calculator: self.calculator!, dateIntervalEdge: .start)
        self.endDateButton.setup(calculator: self.calculator!, dateIntervalEdge: .end)
        
        self.tripsByMetroAtWeekdayTextField.setup(calculator: self.calculator!, transport: .metro, dayOfWeek: .weekday)
        self.tripsByGroundAtWeekdayTextField.setup(calculator: self.calculator!, transport: .ground, dayOfWeek: .weekday)
        
        self.tripsByMetroAtRestdayTextField.setup(calculator: self.calculator!, transport: .metro, dayOfWeek: .restday)
        self.tripsByGroundAtRestdayTextField.setup(calculator: self.calculator!, transport: .ground, dayOfWeek: .restday)
        
        self.commercialAmountTextField.setup(calculator: self.calculator!)
        
        self.totalAmountLabel.setup(calculator: self.calculator!)
        self.missingAmountLabel.setup(calculator: self.calculator!)
    }
    
    private func updateView() {
        self.startDateButton.update()
        self.endDateButton.update()
        
        self.tripsByMetroAtWeekdayTextField.update()
        self.tripsByGroundAtWeekdayTextField.update()
        
        self.tripsByMetroAtRestdayTextField.update()
        self.tripsByGroundAtRestdayTextField.update()
        
        self.commercialAmountTextField.update()
        
        self.totalAmountLabel.update()
        self.missingAmountLabel.update()
    }
    
    // MARK: - Actions
    @IBAction func chooseStartDate(_ sender: UIButton) {
        self.showDatePickerAlert(.start)
    }
    
    @IBAction func chooseEndDate(_ sender: UIButton) {
        self.showDatePickerAlert(.end)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        
        self.tripsByMetroAtWeekdayTextField.resignFirstResponder()
        self.tripsByGroundAtWeekdayTextField.resignFirstResponder()
        
        self.tripsByMetroAtRestdayTextField.resignFirstResponder()
        self.tripsByGroundAtRestdayTextField.resignFirstResponder()
        
        self.commercialAmountTextField.resignFirstResponder()
    }
    
    // MARK: - Methods
    private func showDatePickerAlert(_ dateIntervalEdge: DateIntervalEdge) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let contentViewController = UIViewController()
        contentViewController.preferredContentSize = CGSize(width: alertController.view.bounds.width, height: CGFloat(216))
    
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: alertController.view.bounds.width, height: CGFloat(216)))
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.date = dateIntervalEdge == .start ? (self.calculator?.startDate)! : (self.calculator?.endDate)!
        
        contentViewController.view.addSubview(datePicker)
        alertController.setValue(contentViewController, forKey: "contentViewController")
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let actionTitle = dateIntervalEdge == .start ? "Set start date" : "Set end date"
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
            let newDate = datePicker.date.startOfDay
            
            switch dateIntervalEdge {
            case .start:
                self.calculator?.startDate = newDate
                if let end = self.calculator?.endDate, newDate > end {
                    self.calculator?.endDate = newDate
                }
            case .end:
                self.calculator?.endDate = newDate
                if let start = self.calculator?.startDate, newDate < start {
                    self.calculator?.startDate = newDate
                }
            }
            self.updateView()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat(8)
        default:
            return CGFloat(0.0001)
        }
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  CGFloat(8)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
        let headerHeight = self.tableView(tableView, heightForHeaderInSection: indexPath.section)
        let footerHeight = self.tableView(tableView, heightForFooterInSection: indexPath.section)
        
        switch indexPath.section {
        case 0:
            return (safeAreaHeight * 0.2 - headerHeight - footerHeight) / 2
        case 1,2:
            return safeAreaHeight * 0.2 - headerHeight - footerHeight
        case 3:
            return safeAreaHeight * 0.15 - headerHeight - footerHeight
        case 4:
            return (safeAreaHeight * 0.2 - headerHeight - footerHeight) / 2
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

}
