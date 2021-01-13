//
//  UIAlertController+Extensions.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 13.01.2021.
//  Copyright © 2021 Виктория Бадисова. All rights reserved.
//

import UIKit

extension UIAlertController {
    func set(vc: UIViewController?, width: CGFloat? = nil, height: CGFloat? = nil) {
        guard let vc = vc else { return }
        setValue(vc, forKey: "contentViewController")
        if let height = height {
            vc.preferredContentSize.height = height
            preferredContentSize.height = height
        }
    }
    
    func addDatePicker(mode: UIDatePicker.Mode,
                       date: Date?  = nil,
                       minimumDate: Date? = nil,
                       maximumDate: Date? = nil,
                       action: DatePickerViewController.Action?)
    {
        let datePicker = DatePickerViewController(mode: mode, date: date, minimumDate: minimumDate, maximumDate: maximumDate, action: action)
        let height: CGFloat = 216
        set(vc: datePicker, height: height)
    }
}

final class DatePickerViewController: UIViewController {
    
    public typealias Action = (Date) -> Void
    
    fileprivate var action: Action?
    
    fileprivate lazy var datePicker: UIDatePicker = { [unowned self] in
        $0.addTarget(self, action: #selector(DatePickerViewController.actionForDatePicker), for: .valueChanged)
        return $0
    }(UIDatePicker())
    
    required init(mode: UIDatePicker.Mode,
                  date: Date?  = nil,
                  minimumDate: Date? = nil,
                  maximumDate: Date? = nil,
                  action: Action?)
    {
        super.init(nibName: nil, bundle: nil)
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = mode
        datePicker.date = date ?? Date()
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        self.action = action
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = datePicker
    }
    
    @objc func actionForDatePicker() {
        action?(datePicker.date)
    }
    
    public func setDate(_ date: Date) {
        datePicker.setDate(date, animated: true)
    }
}

