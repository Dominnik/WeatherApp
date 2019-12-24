//
//  Day.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 24.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit

struct Day: Decodable {
    
    var main: Main?
    var dt_txt = Date()
    var weather = [Sky]()
    var wind: Wind?
}
