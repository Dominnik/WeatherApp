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
    
    static func saveObject<T: Object>(_ object: T) {
        
        try! realm.write {
            realm.add(object, update: .modified)
            
        }
    }
    
    static func findObjectByName<T: Object>(_ name: String) -> Results<T> {
        
        let predicate = NSPredicate(format: "name = %@", name)
        return realm.objects(T.self).filter(predicate)

    }
}
