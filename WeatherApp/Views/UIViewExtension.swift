//
//  UIViewExtension.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 21.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit

extension UIView {
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
        
    }
}
