//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 03.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import Foundation

class WeatherModel {
    
    var nameCity: String
    var temp: Double
    
    init(weatherJson: Dictionary<String, Any>) {
        
        self.nameCity = weatherJson["name"] as! String
        let main = weatherJson["main"] as! Dictionary<String, Any>
        self.temp = main["temp"] as! Double
    }
}
