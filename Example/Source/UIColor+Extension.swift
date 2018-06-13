//
//  UIColor+Extension.swift
//  TableViewReloadAnimation
//
//  Created by yiqiwang(王一棋) on 2018/6/5.
//  Copyright © 2018年 yiqiwang(王一棋). All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: String, alpha: CGFloat = 1) {
        var cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }

        var alpha = alpha
        if (cString as NSString).length >= 8 {
            let aString = (cString as NSString).substring(to: 2)
            cString = (cString as NSString).substring(from: 2)
            var a: CUnsignedInt = 0
            Scanner(string: aString).scanHexInt32(&a)
            alpha = CGFloat(a) / 255.0
        }

        var rString = "FF"
        if (cString as NSString).length >= 2 {
            rString = (cString as NSString).substring(to: 2)
            cString = (cString as NSString).substring(from: 2)
        }
        var gString = "FF"
        if (cString as NSString).length >= 2 {
            gString = (cString as NSString).substring(to: 2)
            cString = (cString as NSString).substring(from: 2)
        }
        var bString = "FF"
        if (cString as NSString).length >= 2 {
            bString = (cString as NSString).substring(to: 2)
        }

        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        self.init(red:CGFloat(r) / 255.0, green:CGFloat(g) / 255.0, blue:CGFloat(b) / 255.0, alpha: alpha)
    }
}
