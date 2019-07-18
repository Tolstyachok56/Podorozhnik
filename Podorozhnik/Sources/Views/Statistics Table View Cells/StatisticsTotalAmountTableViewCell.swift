//
//  StatisticsTotalAmountTableViewCell.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 11/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

class StatisticsTotalAmountTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    static let identifier: String = String(describing: StatisticsTotalAmountTableViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet weak var totalAmountLabel: UILabel!

    // MARK: - Properties
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.totalAmountLabel.text = viewModel.totalAmount
        }
    }
}

extension StatisticsTotalAmountTableViewCell {
    struct ViewModel {
        var totalAmount: String
    }
}

extension StatisticsTotalAmountTableViewCell.ViewModel {
    init(_ trips: [Trip]) {
        self.totalAmount = String(trips.map{$0.fare}.reduce(0, +)).rublesGroupedFormatting ?? "?"
    }
}
