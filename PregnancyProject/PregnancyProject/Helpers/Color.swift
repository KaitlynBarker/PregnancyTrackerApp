//
//  Color.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 2/20/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    // MARK: - Color Pallette
    
    
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: CGFloat(r) / 0xff, green: CGFloat(g) / 0xff, blue: CGFloat(b) / 0xff, alpha: 1)
    }
}
