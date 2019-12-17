//
//  ForecastWeatherSectionModel.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 17.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit

class ForecastWeatherSectionModel {
    
    var date: String = ""
    var cells: [ForecastWeatherCellModel] = []
    
    init(date: String) {
        self.date = date
    }
}

class ForecastWeatherCellModel {
    
    var humidity: Double = 0.0
    var pressure: Int = 0
    var temp: Int = 0
    var imageUrl: URL? = nil
    var time: String = ""
    var speed: Double = 0.0
    
    init(humidity: Double, pressure: Int, temp: Int, imageUrl: URL?, time: String, speed: Double) {
        self.humidity = humidity
        self.pressure = pressure
        self.temp = temp
        self.imageUrl = imageUrl
        self.time = time
        self.speed = speed
    }
    
}
