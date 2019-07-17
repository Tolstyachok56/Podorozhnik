//
//  StatisticsTableViewCell.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 11/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {

    // MARK: - Static properties
    static let identifier: String = String(describing: StatisticsTableViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var transportTypeImageView: UIImageView!
    @IBOutlet private weak var numberOfTripsLabel: UILabel!
    @IBOutlet private weak var averageFareLabel: UILabel!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.transportTypeImageView.image = viewModel.transportTypeImage
            self.numberOfTripsLabel.text = viewModel.numberOfTrips
            self.averageFareLabel.text = viewModel.averageFare
            self.totalAmountLabel.text = viewModel.totalAmount
        }
    }
}

extension StatisticsTableViewCell {
    struct ViewModel {
        var transportTypeImage: UIImage
        var numberOfTrips: String
        var averageFare: String
        var totalAmount: String
    }
}

extension StatisticsTableViewCell.ViewModel {
    init(transportType: TransportType, trips: [Trip]) {
        self.transportTypeImage = UIImage(named: transportType.imageName)!
        self.numberOfTrips = String(trips.count)
        let totalAmount = trips.map{$0.fare}.reduce(0, +)
        self.averageFare = String(totalAmount / Double(trips.count)).rublesGroupedFormatting ?? "?"
        self.totalAmount = String(totalAmount).rublesGroupedFormatting ?? "?"
    }
}

