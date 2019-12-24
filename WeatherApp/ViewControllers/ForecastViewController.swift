//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 03.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let factory = DateFormatterFactory()
    
    
    var connection = false
    var cityInfo: String?
    var cityName: String?
    var countryName: String?
    var forecastWeatherRealmModel: ForecastWeatherRealmModel?
    
    var sections: [ForecastWeatherSectionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Прогноз на 5 дней"
        tableView.register(UINib(nibName: "DailyWeatherCell", bundle: nil), forCellReuseIdentifier: "DailyWeatherCell")
        tableView.register(UINib(nibName: "DailyWeatherHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "DailyWeatherHeader")
        
        forecastWeatherRequest(with: cityInfo ?? "")
    }
    
    
    func forecastWeatherRequest(with cityInfo: String) {
        
        activityIndicator.startAnimating()
        APIServices.shared.getObject(method: .forecastEventMethod, params: ["q": cityInfo, "appid": APIServices.shared.userId])
        {(res: Result<ForecastWeatherModel, Error>) in
            switch res {
            case .success(let result):
                self.forecastWeatherUpdate(from: result)
                self.activityIndicator.stopAnimating()
                self.saveForecastObject(from: result)
            case .failure(let error):
                print("\(error)")
                self.forecastWeatherRealmModel = StorageManager.findObjectByName(cityInfo).first
                self.setupForecastWeatherFromCache()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    
    private func forecastWeatherUpdate(from result: ForecastWeatherModel) {
        
        sections.removeAll()
        result.list.forEach { day in
            let dayAsString = self.factory.weekdayDateFormatter.string(from: day.dt_txt).capitalized
            var section = sections.first { section in section.date == dayAsString }
            if section == nil {
                section = ForecastWeatherSectionModel.init(date: dayAsString)
                sections.append(section!)
            }
            section?.cells.append(
                ForecastWeatherCellModel(
                    humidity: day.main?.humidity ?? 0.0,
                    pressure: Int((day.main?.pressure ?? 0).millimetreOfMercury),
                    temp: Int((day.main?.temp ?? 0.0).celsius),
                    imageUrl: URL(string: "\(String(describing: day.weather.first!.icon))".iconURL),
                    time: self.factory.timeFormatter.string(from: day.dt_txt),
                    speed: day.wind?.speed ?? 0.0
                )
            )
        }
        tableView.reloadData()
    }
    
    func saveForecastObject(from result: ForecastWeatherModel) {
        
        let newForecastWeatherObject = ForecastWeatherRealmModel()
        newForecastWeatherObject.name = result.city?.name ?? ""
        newForecastWeatherObject.country = result.city?.country ?? ""
        

        for interval in result.list {
            let newForecastDay = RealmDay()
            newForecastDay.dateAndTime = interval.dt_txt
            newForecastDay.temp = interval.main?.temp ?? 0.000
            newForecastDay.pressure = interval.main?.pressure ?? 0.000
            newForecastDay.humidity = interval.main?.humidity ?? 0.000
            newForecastDay.icon = interval.weather.first?.icon ?? ""
            newForecastDay.windSpeed = interval.wind?.speed ?? 0.000
            newForecastDay.parent = newForecastWeatherObject
            
            newForecastWeatherObject.list.append(newForecastDay)
        }
        StorageManager.saveObject(newForecastWeatherObject)
        
    }
    
    private func setupForecastWeatherFromCache() {
        navigationItem.title = "Прогноз на 5 дней"
        
        sections.removeAll()
        forecastWeatherRealmModel?.list.forEach { day in
            let dayAsString = self.factory.weekdayDateFormatter.string(from: day.dateAndTime).capitalized
            var section = sections.first { section in section.date == dayAsString }
            if section == nil {
                section = ForecastWeatherSectionModel.init(date: dayAsString)
                sections.append(section!)
            }
            section?.cells.append(
                ForecastWeatherCellModel(
                   humidity: day.humidity,
                   pressure: Int(day.pressure.millimetreOfMercury),
                   temp: Int(day.temp.celsius),
                   imageUrl: .none,
                   time: self.factory.timeFormatter.string(from: day.dateAndTime),
                   speed: day.windSpeed
                )
            )
            
        }
        tableView.reloadData()
    }
}

extension ForecastViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherCell", for: indexPath) as! DailyWeatherCell
        cell.configureCell(for: sections, and: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DailyWeatherHeader") as! DailyWeatherHeader
        headerView.dateLabel?.text = sections[section].date
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
}

extension ForecastViewController: UITableViewDelegate {
    
}


