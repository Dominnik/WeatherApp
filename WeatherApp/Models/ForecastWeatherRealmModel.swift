//
//  ForecastWeatherRealmModel.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 21.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit
import RealmSwift

class ForecastWeatherRealmModel: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var country = ""
    var list = List<Day>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

class Day: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var dateAndTime = Date()
    @objc dynamic var temp: Double = 0.0
    @objc dynamic var pressure: Double = 0.0
    @objc dynamic var humidity: Double = 0.0
    @objc dynamic var icon = ""
    @objc dynamic var windSpeed: Double = 0.0
    @objc dynamic var parent: ForecastWeatherRealmModel?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required init(dateAndTime: Date, temp: Double, pressure: Double, humidity: Double, icon: String, windSpeed: Double, parent: ForecastWeatherRealmModel) {
        super.init()
        id = UUID().uuidString
        self.dateAndTime = dateAndTime
        self.temp = temp
        self.pressure = pressure
        self.humidity = humidity
        self.icon = icon
        self.windSpeed = windSpeed
        parent.list.append(self)
    }
    
    required init() {
        id = UUID().uuidString
        super.init()
    }
    
}
