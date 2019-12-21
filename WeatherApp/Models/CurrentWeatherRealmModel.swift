//
//  CurrentWeatherRealmModel.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 20.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit
import RealmSwift

class CurrentWeatherRealmModel: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var country = ""
    @objc dynamic var icon = ""
    @objc dynamic var temp: Double = 0.0
    @objc dynamic var tempMin: Double = 0.0
    @objc dynamic var tempMax: Double = 0.0
    @objc dynamic var pressure = 0
    @objc dynamic var humidity = 0
    @objc dynamic var speed = 0.0
    @objc dynamic var cloudy = 0
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    convenience init(name: String, country: String, icon: String, temp: Double, tempMin: Double, tempMax: Double, pressure: Int, humidity: Int, speed: Double, cloudy: Int) {
        
        self.init()
        self.name = name
        self.country = country
        self.icon = icon
        self.temp = temp
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.humidity = humidity
        self.speed = speed
        self.cloudy = cloudy
    }
}
