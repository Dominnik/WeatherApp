//
//  ViewController.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 03.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weatherSwitchControl: UISegmentedControl!
    
    var cityInfo: String?
    var date: [String] = []
    var items: [Main] = []
    var icons: [Sky] = []
    var cityName: String?
    var countryName: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherSwitchControl.selectedSegmentIndex = 0
        tableView.register(UINib(nibName: "DailyWeatherCell", bundle: nil), forCellReuseIdentifier: "DailyWeatherCell")
        
        forecastWeatherRequest()
    }
    
    
    func forecastWeatherRequest() {
            
        APIServices.shared.getObject(method: .forecastEventMethod, params: ["q": cityInfo!, "appid": "d988069c070ff798d8c1fea149be599a"])
            {[weak self](result: ForecastWeatherModel?, error: Error?) in
                if let error = error {
                    print("\(error)")
                } else if let forecastResult = result {
//                    print("\(forecastResult)")
                    self?.forecastWeatherUpdate(from: forecastResult)
        
                }
            }
    }

    
    private func forecastWeatherUpdate(from result: ForecastWeatherModel) {
        navigationItem.title = result.city!.name + ", " + result.city!.country
        
        items = result.list.compactMap { day in
            return day.main
        }
        date = result.list.compactMap { day in
            return day.dt_txt
        }
        icons = result.list.compactMap { day in
            return day.weather.first
        }
//             self.saveObject(from: result)
        tableView.reloadData()
    }
    
    
    func saveObject(from result: ForecastWeatherModel) {
        
        let newCity = ForecastWeatherModel()
        newCity.list = result.list
        newCity.city = result.city
        StorageManager.saveObject(newCity)
        
    }
    
    private func configureCell(cell: DailyWeatherCell, for indexPath: IndexPath) {
        
        cell.weatherValueLabel?.text = String(format: "%.0f", (items[indexPath.row].temp) - 273,15) + "°C"
        cell.dateValueLabel?.text = date[indexPath.row]
        
        
        DispatchQueue.global().async {
            
            guard let iconUrl = URL(string: "http://openweathermap.org/img/wn/\(self.icons[indexPath.row].icon)@2x.png") else { return }
            guard let imageData = try? Data(contentsOf: iconUrl) else { return }
        
            DispatchQueue.main.async {
                
                cell.weatherIconImage.image = UIImage(data: imageData)
                
            }
        }
        
    }
    
    @IBAction func switchWeatherForecastAction(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            
            tableView.isHidden = false
        } else {
            
            tableView.isHidden.toggle()
        }
        
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let currentViewController = segue.destination as? CurrentDayViewController else { return }
        currentViewController.cityInfo = cityInfo
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherCell", for: indexPath) as! DailyWeatherCell
        
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
}


