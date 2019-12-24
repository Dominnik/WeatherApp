//
//  ForecastWeatherCellModel.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 24.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit

class ForecastWeatherCellModel {
    
    var humidity: Double = 0.0
    var pressure: Int = 0
    var temp: Int = 0
    var imageUrl: URL?
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
