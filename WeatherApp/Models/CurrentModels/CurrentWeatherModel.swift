//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 16.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit
import RealmSwift


struct CurrentWeatherModel: Decodable {
    
    var id = 0
    var name = ""
    var weather = [Sky]()
    var main: Main?
    var wind: Wind?
    var clouds: Clouds?
    var sys: System?

}



