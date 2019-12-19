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
    
    private let factory = DateFormatterFactory()
    
    var cityInfo: String?
    var cityName: String?
    var countryName: String?
    
    var sections: [ForecastWeatherSectionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: "DailyWeatherCell", bundle: nil), forCellReuseIdentifier: "DailyWeatherCell")
        tableView.register(UINib(nibName: "DailyWeatherHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "DailyWeatherHeader")
        
        forecastWeatherRequest()
    }
    
    
    func forecastWeatherRequest() {
            
        APIServices.shared.getObject(method: .forecastEventMethod, params: ["q": cityInfo!, "appid": "d988069c070ff798d8c1fea149be599a"])
            {[weak self](result: ForecastWeatherModel?, error: Error?) in
                if let error = error {
                    print("\(error)")
                } else if let forecastResult = result {
                    self?.saveObject(from: forecastResult)
                    self?.forecastWeatherUpdate(from: forecastResult)
                }
            }
    }

    
    private func forecastWeatherUpdate(from result: ForecastWeatherModel) {
        navigationItem.title = "Прогноз на 5 дней"
        
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
                    pressure: Int((day.main?.pressure ?? 0) * 0.75),
                    temp: Int((day.main?.temp ?? 273.15) - 273.15),
                    imageUrl: URL(string: "http://openweathermap.org/img/wn/\(String(describing: day.weather.first!.icon))@2x.png"),
                    time: self.factory.timeFormatter.string(from: day.dt_txt),
                    speed: day.wind?.speed ?? 0.0
                )
            )
            
        }
        tableView.reloadData()
    }
    
    
    func saveObject(from result: ForecastWeatherModel) {
        
        let newCity = ForecastWeatherModel()
        newCity.list = result.list
        newCity.city = result.city
        StorageManager.saveObject(newCity)
        
    }
    
    private func configureCell(cell: DailyWeatherCell, for indexPath: IndexPath) {
        let row = sections[indexPath.section].cells[indexPath.row]
        
        cell.weatherValueLabel?.text = String(row.temp) + "°C"
        cell.dateValueLabel?.text = row.time
        cell.humidityValueLabel?.text = String(row.humidity) + "%"
        cell.pressureValueLabel?.text = String(row.pressure) + "мм рт.ст."
        cell.windSpeeedValueLabel?.text = String(row.speed) + "м/с"
        
        
        DispatchQueue.global().async {
            
            guard let iconUrl = row.imageUrl else { return }
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

extension ForecastViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherCell", for: indexPath) as! DailyWeatherCell
        configureCell(cell: cell, for: indexPath)
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


