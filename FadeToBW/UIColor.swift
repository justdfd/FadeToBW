//
//  UIColor.swift
//  FadeToBW
//
//  Created by Dave Dombrowski on 3/19/17.
//  Copyright © 2017 justDFD. All rights reserved.
//

import UIKit

extension UIColor {
    func rgb() -> (Int?, Int?, Int?) {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            return (iRed, iGreen, iBlue)
        } else {
            // Could not extract RGBA components:
            return (nil,nil,nil)
        }
    }
}
