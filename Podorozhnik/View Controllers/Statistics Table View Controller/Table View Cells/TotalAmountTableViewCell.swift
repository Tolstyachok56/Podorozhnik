//
//  TotalAmountTableViewCell.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 09.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class TotalAmountTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let reuseIdentifier = "TotalAmountTableViewCell"
    
    // MARK: - Properties
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    // MARK: - Initializing

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
