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


