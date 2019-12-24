//
//  ForecastWeatherRealmModel.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 21.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit
import RealmSwift

class ForecastWeatherRealmModel: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var country = ""
    var list = List<RealmDay>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

