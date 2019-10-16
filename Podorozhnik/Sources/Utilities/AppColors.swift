//
//  AppColors.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/06/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

struct AppColors {
    
    static let chateauGreen: UIColor = UIColor(named: "chateauGreen") ?? colorFromRGBA(red: 38, green: 145, blue: 91)
    static let backColor: UIColor = UIColor(named: "backColor") ?? UIColor.white
    
    static private func colorFromRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}
