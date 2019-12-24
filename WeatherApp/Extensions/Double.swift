//
//  Double.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 24.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit

extension Double {
    
    var celsius: Double { return self - 273.15 }
    var millimetreOfMercury: Double { return self * 0.75}
}
