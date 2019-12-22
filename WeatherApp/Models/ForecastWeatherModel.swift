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


struct ForecastWeatherModel: Codable {
    
    var list = [ForecastDay]()
    var city: ForecastCity?
}

struct ForecastCity: Codable {
    
    var id = 0
    var name = ""
    var country = ""
}

struct ForecastDay: Codable {
    
    var main: ForecastMain?
    var dt_txt = Date()
    var weather = [ForecastSky]()
    var wind: ForecastWind?
}

struct ForecastWind: Codable {
    
    var speed: Double = 0.0
}

struct ForecastMain: Codable {
    
    var temp: Double = 0.0
    var pressure: Double = 0.0
    var humidity: Double = 0.0
}

struct ForecastSky: Codable {
    
    var icon = ""
}



