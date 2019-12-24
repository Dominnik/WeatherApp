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
    @objc dynamic var pressure = 0
    @objc dynamic var humidity = 0
    @objc dynamic var speed = 0.0
    @objc dynamic var cloudy = 0
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    func getResultFromModel(with result: CurrentWeatherModel) {
        name = result.name
        country = result.sys!.country
        icon = result.weather.first!.icon
        temp = result.main!.temp
        pressure = Int(result.main!.pressure)
        humidity = Int(result.main!.humidity)
        speed = result.wind!.speed
        cloudy = result.clouds!.all
    }
}
