//
//  CurrentDayViewController.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 09.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit
import SceneKit
import MapKit

class CurrentDayViewController: UIViewController, CurrentWeatherViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var currentWeatherView: CurrentWeatherView!
    
    private let locationManager = LocationManager()
    
    var cityInfo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let exposedLocation = self.locationManager.exposedLocation else {
            print("*** Error in \(#function): exposedLocation is nil")
            currentWeatherRequest()
            return
        }
        
        self.locationManager.getPlace(for: exposedLocation) { (placemark) in
            
            guard let placemark = placemark else { return }
            
            if let city = placemark.locality {
                self.cityInfo = city
                self.navigationItem.title = city
            }
        }
        
        currentWeatherView.delegate = self
        currentWeatherRequest()
    }
    
    
    func goToForecastViewController() {
        performSegue(withIdentifier: "ShowForecastWeather", sender: self)
    }
    
    func showAlertAction(title: String, message: String, placeholder: String) {
        let newCityAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        newCityAlert.addTextField { (textField) in
            textField.placeholder = placeholder
        }
        newCityAlert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
        
        self.present(newCityAlert, animated: true, completion: nil)
        
        newCityAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let textField = newCityAlert.textFields![0]
            
            guard textField.text?.isEmpty == false else { return }
            
            self.cityInfo = textField.text!
            print(self.cityInfo!)
            self.navigationItem.title = self.cityInfo
            self.currentWeatherRequest()
        }))
    }
    
    @IBAction func newCitySearchBarButton(_ sender: UIBarButtonItem) {
        showAlertAction(title: "Новый город", message: "Введите название", placeholder: "Название города")
    }
    
    func currentWeatherRequest() {
        APIServices.shared.getObject(method: .currentEventMethod, params: ["q": cityInfo ?? "Samara", "appid": "d988069c070ff798d8c1fea149be599a"])
        {[weak self](result: CurrentWeatherModel?, error: Error?) in
            if let error = error {
                print("\(error)")
            } else if let currentResult = result {
                self?.currentWeatherUpdate(from: currentResult)
            }
        }
    }
    
    private func currentWeatherUpdate(from result: CurrentWeatherModel) {
        navigationItem.title = result.name + ", " + result.sys!.country
        
        currentWeatherView.helloLabel?.text = String(format: "%.0f", (result.main!.temp) - 273,15) + "°C"
        
        if let pressure = result.main?.pressure {
            currentWeatherView.pressureLabel?.text = String(format: "%.0f", Double(pressure) * 0.75) + " мм рт. ст."
        }
        if let windSpeed = result.wind?.speed {
            currentWeatherView.windSpeedLabel?.text = String(windSpeed) + " м/с"
        }
        if let humidity = result.main?.humidity {
            currentWeatherView.humidityLabel?.text = String(humidity) + " %"
        }
        if let overcast = result.clouds?.all {
            currentWeatherView.cloudsLabel?.text = String(overcast) + " %"
        }
        let icons = result.weather.compactMap { day in
            return day
        }
        DispatchQueue.global().async {
            
            if let icon = icons.first?.icon {
                
                guard let iconUrl = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png") else { return }
                guard let imageData = try? Data(contentsOf: iconUrl) else { return }
                
                DispatchQueue.main.async {
                    
                    self.currentWeatherView.iconImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let forecastViewController = segue.destination as? ForecastViewController else { return }
        forecastViewController.cityInfo = cityInfo
        
        let backItem = UIBarButtonItem()
        backItem.title = "Сегодня"
        navigationItem.backBarButtonItem = backItem
    }
    
}


