//
//  String.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation


extension String {
    
    func double() -> Double? {
        return Double(self.replacingOccurrences(of: ",", with: "."))
    }
    
}
