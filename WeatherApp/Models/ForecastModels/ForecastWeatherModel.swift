//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 03.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//


import UIKit

struct ForecastWeatherModel: Decodable {
    
    var list = [Day]()
    var city: City?
}






