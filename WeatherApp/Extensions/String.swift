//
//  String.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 24.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import Foundation

extension String {
    
    var celsius: String { return self + "°C" }
    var millimetreOfMercury: String { return self + " мм рт.ст."}
    var metersPerSecond: String { return self + " м/с" }
    var percent: String { return self + "%" }
    var iconURL: String { return "http://openweathermap.org/img/wn/" + self + "@2x.png"}
}
