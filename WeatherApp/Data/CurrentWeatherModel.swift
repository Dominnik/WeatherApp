//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 16.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit
import RealmSwift

class CurrentWeatherModel: Object, Codable {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    var weather = List<CurrentSky>()
    @objc dynamic var main: CurrentMain?
    @objc dynamic var wind: CurrentWind?
    @objc dynamic var clouds: CurrentClouds?
    @objc dynamic var sys: CurrentSystem?
}
class CurrentSky: Object, Codable {
    
     @objc dynamic var icon = ""
}

class CurrentMain: Object, Codable {
    
    @objc dynamic var temp: Double = 0.0
    @objc dynamic var feels_like: Double = 0.0
    @objc dynamic var temp_min: Double = 0.0
    @objc dynamic var temp_max: Double = 0.0
    @objc dynamic var pressure = 0
    @objc dynamic var humidity = 0
}

class CurrentWind: Object, Codable {
    
    @objc dynamic var speed = 0
    @objc dynamic var deg = 0
}

class CurrentClouds: Object, Codable {
    
    @objc dynamic var all = 0
}

class CurrentSystem: Object, Codable {
    
    @objc dynamic var country = ""
}
