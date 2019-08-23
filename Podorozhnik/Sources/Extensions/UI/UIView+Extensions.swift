//
//  UIView+Extensions.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 24/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(color: UIColor, radius: CGFloat, offset: CGSize = .zero, opacity: Float = 1) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
    }
    
    func addBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
