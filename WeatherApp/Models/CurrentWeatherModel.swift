//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 16.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper


struct CurrentWeatherModel: Codable {
    
    var id = 0
    var name = ""
    var weather = [CurrentSky]()
    var main: CurrentMain?
    var wind: CurrentWind?
    var clouds: CurrentClouds?
    var sys: CurrentSystem?

}

struct CurrentSky: Codable {
    
     var icon = ""
}

struct CurrentMain: Codable {
    
    var temp: Double = 0.0
    var feels_like: Double = 0.0
    var temp_min: Double = 0.0
    var temp_max: Double = 0.0
    var pressure = 0
    var humidity = 0
}

struct CurrentWind: Codable {
    
    var speed = 0.0
}

struct CurrentClouds: Codable {
    
    var all = 0
}

struct CurrentSystem: Codable {
    
    var country = ""
}
