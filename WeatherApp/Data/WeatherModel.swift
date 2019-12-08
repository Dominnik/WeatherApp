//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 03.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import Foundation
import UIKit

//class WeatherModel {
//
//    var nameCity: String
//    var temp: Double
//    var description: String
////    var currentTime: String
////    var icon: UIImage
//
//
//    init(weatherJson: Dictionary<String, Any>) {
//
//        self.nameCity = weatherJson["name"] as! String
//        let main = weatherJson["main"] as! Dictionary<String, Any>
//        self.temp = main["temp"] as! Double
//
//        let weather = weatherJson["weather"] as! Array<Any>
//        let zero = weather[0] as! Dictionary<String, Any>
//        self.description = zero["description"] as! String
//
//    }
//}

struct WeatherModel: Codable {
    
    let list: [Day]
    let city: City
    
}

struct Day: Codable {
    
    let main: Main
    let dt_txt: String
    let weather: [Sky]
    
}

struct Main: Codable {
    
    let temp: Double
}

struct Sky: Codable {
    
    let icon: String
}

struct City: Codable {
    
    let name: String
    let country: String
}
