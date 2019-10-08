//
//  ShadowedTableViewCell.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 14/08/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

class ShadowedTableViewCell: UITableViewCell {
    func addShadow(isFirstRow: Bool = false, isLastRow: Bool = false) {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        if isFirstRow && isLastRow {
            self.addShadow(color: AppsColors.chateauGreen, radius: 3, offset: .zero, opacity: 0.5)
        } else if isFirstRow {
            self.addShadow(color: AppsColors.chateauGreen, radius: 1.5, offset: CGSize(width: 0, height: -1.5), opacity: 0.3)
        } else if isLastRow {
            self.addShadow(color: AppsColors.chateauGreen, radius: 1.5, offset: CGSize(width: 0, height: 1.5), opacity: 0.3)
        }
    }
}
