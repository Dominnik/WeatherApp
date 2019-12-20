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
    
     var cityInfo: String?
    var currentCity: String?
    var locationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        geoCoder.reverseGeocodeLocation(location) { (placeMark, error) in
            if error != nil {
                print("*** Error in \(#function): placemark is nil")
            } else {
                if let place = placeMark?[0] {
                    self.currentCity = place.locality
                    self.currentWeatherRequest(with: place.locality!)
                    self.currentWeatherView.delegate = self
                    self.locationManager.stopUpdatingLocation()
                }
            }
        }
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
                
                print(self.cityInfo!)
                self.currentWeatherRequest(with: textField.text!)
            }))
        }
        
        @IBAction func goToCurrentLocationAction(_ sender: UIBarButtonItem) {
            
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            currentWeatherRequest(with: currentCity ?? cityInfo!)
            locationManager.stopUpdatingLocation()
        }
        
        @IBAction func newCitySearchBarButton(_ sender: UIBarButtonItem) {
            showAlertAction(title: "Новый город", message: "Введите название", placeholder: "Название города")
        }
        
        func currentWeatherRequest(with cityInfo: String) {
            APIServices.shared.getObject(method: .currentEventMethod, params: ["q": cityInfo, "appid": "d988069c070ff798d8c1fea149be599a"])
            {[weak self](result: CurrentWeatherModel?, error: Error?) in
                if let error = error {
                    print("\(error)")
                    self?.showAlertAction(title: "Ошибка", message: "Введите корректное имя города", placeholder: "Название города")
                } else if let currentResult = result {
                    self?.cityInfo = cityInfo
                    self?.navigationItem.title = cityInfo
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


