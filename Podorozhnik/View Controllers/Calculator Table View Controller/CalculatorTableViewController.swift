//
//  CalculatorTableViewController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 27.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class CalculatorTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    
    @IBOutlet weak var startDateButton: DateButton!
    @IBOutlet weak var endDateButton: DateButton!
    
    @IBOutlet weak var tripsByMetroAtWeekdayTextField: CalculatorTripsTextField!
    @IBOutlet weak var tripsByGroundAtWeekdayTextField: CalculatorTripsTextField!
    
    @IBOutlet weak var tripsByMetroAtRestdayTextField: CalculatorTripsTextField!
    @IBOutlet weak var tripsByGroundAtRestdayTextField: CalculatorTripsTextField!
    
    @IBOutlet weak var commercialAmountTextField: CalculatorCommercialTextField!
    
    @IBOutlet weak var totalAmountLabel: TotalAmountLabel!

    // MARK: -
    
    var calculator: Calculator?
    
    // MARK: -
    
    var card: Card?
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculator = Calculator()
        calculator?.card = card
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    // MARK: - View methods
    
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        
        startDateButton.setup(calculator: calculator!, dateIntervalEdge: .start)
        endDateButton.setup(calculator: calculator!, dateIntervalEdge: .end)
        
        tripsByMetroAtWeekdayTextField.setup(calculator: calculator!, transport: .metro, dayOfWeek: .weekday)
        tripsByGroundAtWeekdayTextField.setup(calculator: calculator!, transport: .ground, dayOfWeek: .weekday)
        
        tripsByMetroAtRestdayTextField.setup(calculator: calculator!, transport: .metro, dayOfWeek: .restday)
        tripsByGroundAtRestdayTextField.setup(calculator: calculator!, transport: .ground, dayOfWeek: .restday)
        
        commercialAmountTextField.setup(calculator: calculator!)
        
        totalAmountLabel.setup(calculator: calculator!)
    }
    
    private func updateView() {
        startDateButton.update()
        endDateButton.update()
        
        tripsByMetroAtWeekdayTextField.update()
        tripsByGroundAtWeekdayTextField.update()
        
        tripsByMetroAtRestdayTextField.update()
        tripsByGroundAtRestdayTextField.update()
        
        commercialAmountTextField.update()
        
        totalAmountLabel.update()
    }
    
    // MARK: - Actions
    
    @IBAction func chooseStartDate(_ sender: UIButton) {
        showDatePickerAlert(.start)
    }
    
    @IBAction func chooseEndDate(_ sender: UIButton) {
        showDatePickerAlert(.end)
    }
    
    @IBAction func topUpTheBalance(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: Link.isppMetro)!)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        
        tripsByMetroAtWeekdayTextField.resignFirstResponder()
        tripsByGroundAtWeekdayTextField.resignFirstResponder()
        
        tripsByMetroAtRestdayTextField.resignFirstResponder()
        tripsByGroundAtRestdayTextField.resignFirstResponder()
        
        commercialAmountTextField.resignFirstResponder()
    }
    
    // MARK: - Methods
    
    private func showDatePickerAlert(_ dateIntervalEdge: DateIntervalEdge) {
        let alertController = UIAlertController(title: "Choose date", message: nil, preferredStyle: .actionSheet)
        
        
        let contentViewController = UIViewController()
        contentViewController.preferredContentSize = CGSize(width: alertController.view.bounds.width, height: CGFloat(216))
    
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: alertController.view.bounds.width, height: CGFloat(216)))
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.date = dateIntervalEdge == .start ? (calculator?.startDate)! : (calculator?.endDate)!
        
        contentViewController.view.addSubview(datePicker)
        alertController.setValue(contentViewController, forKey: "contentViewController")
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            let newDate = Calendar.current.startOfDay(for: datePicker.date)
            
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
    
    // MARK: - UITableViewDelegate methods
    
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
        case 3,4:
            return safeAreaHeight * 0.15 - headerHeight - footerHeight
        case 5:
            return safeAreaHeight * 0.1 - headerHeight - footerHeight
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

}
