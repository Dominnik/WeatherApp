//
//  CacheViewController.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 20.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit
import RealmSwift

class CacheViewController: UIViewController {

    @IBOutlet weak var cacheTableView: UITableView!
    
    var weatherRecords: Results<CurrentWeatherRealmModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Назад"

        weatherRecords = realm.objects(CurrentWeatherRealmModel.self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showCacheModel" {
            
            guard let indexPath = cacheTableView.indexPathForSelectedRow else { return }
            let currentWeatherRealmModel: CurrentWeatherRealmModel
            currentWeatherRealmModel = weatherRecords[indexPath.row]
            
            let newCachedViewController = segue.destination as! CurrentDayViewController
            newCachedViewController.currentWeatherRealmModel = currentWeatherRealmModel
        }
    }
}

extension CacheViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherRecords.isEmpty ? 0 : weatherRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cacheCell", for: indexPath)
        
        let weatherRecord = weatherRecords[indexPath.row]
        
        cell.textLabel?.text = weatherRecord.name
        cell.detailTextLabel?.text = String(format:"%.0f", (weatherRecord.temp - 273.15)) + " °C"
        
        return cell
    }
    
    
    
}
