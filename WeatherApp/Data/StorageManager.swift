//
//  StorageManager.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 11.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import RealmSwift


let realm = try! Realm()

struct StorageManager {
    
    static func saveObject(_ weatherModel: CurrentWeatherRealmModel) {
        
        try! realm.write {
            realm.add(weatherModel, update: .modified)
            
        }
    }
    
    static func findCurrentWeatherByName(_ name: String) -> Results<CurrentWeatherRealmModel> {
        
        let predicate = NSPredicate(format: "name = %@", name)
        return realm.objects(CurrentWeatherRealmModel.self).filter(predicate)

    }
    
    static func findForecastWeatherByName(_ name: String) -> Results<ForecastWeatherRealmModel> {
        
        let predicate = NSPredicate(format: "name = %@", name)
        return realm.objects(ForecastWeatherRealmModel.self).filter(predicate)
    }
    
    static func saveForecastObject(_ forecastWeatherModel: ForecastWeatherRealmModel) {
        
        try! realm.write {
            realm.add(forecastWeatherModel, update: .all)
        }
    }
    
    static func deleteObject(_ currentWeatherModel: CurrentWeatherRealmModel, _ forecastWeatherModel: ForecastWeatherRealmModel) {
        try! realm.write {
            realm.delete(currentWeatherModel)
            realm.delete(forecastWeatherModel)
        }
    }
    
    static func clearDatabase() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
