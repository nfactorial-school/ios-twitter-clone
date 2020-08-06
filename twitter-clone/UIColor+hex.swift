//
//  UIColor+hex.swift
//  twitter-clone
//
//  Created by Aidar Nugmanoff on 8/6/20.
//  Copyright © 2020 Aidar Nugmanoff. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        guard cString.count == 6 else { return nil }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255,
                  alpha: 1)
    }
}
