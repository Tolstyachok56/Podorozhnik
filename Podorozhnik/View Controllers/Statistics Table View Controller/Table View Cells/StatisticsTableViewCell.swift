//
//  StatisticsTableViewCell.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let reuseIdentifier = "StatisticsTableViewCell"
    
    // MARK: - Properties
    
    @IBOutlet weak var transportImageView: UIImageView!
    @IBOutlet weak var tripsLabel: UILabel!
    @IBOutlet weak var averageTariffLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    // MARK: - Initializing

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
