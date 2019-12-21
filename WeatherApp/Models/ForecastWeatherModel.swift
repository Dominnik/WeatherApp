//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 03.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//


import UIKit
import RealmSwift
import ObjectMapper


class ForecastWeatherModel: Object, Codable {
    
    var list = List<Day>()
    @objc dynamic var city: City?
    
}

class Day: Object, Codable {
    
    @objc dynamic var main: Main?
    @objc dynamic var dt_txt = Date()
    var weather = List<Sky>()
    @objc dynamic var wind: Wind?
    
}

class Wind: Object, Codable {
    
    @objc dynamic var speed: Double = 0.0
}


class Main: Object, Codable {
    
    @objc dynamic var temp: Double = 0.0
    @objc dynamic var pressure: Double = 0.0
    @objc dynamic var humidity: Double = 0.0
}

class Sky: Object, Codable {
    
    @objc dynamic var icon = ""
}

class City: Object, Codable {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var country = ""
    
    
}

