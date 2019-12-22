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
import Reachability

class CurrentDayViewController: UIViewController, CurrentWeatherViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var errorConnectionView: UIView!
    @IBOutlet weak var currentWeatherView: CurrentWeatherView!
    @IBOutlet weak var cacheButton: UIBarButtonItem!
    
    var currentWeatherRealmModel: CurrentWeatherRealmModel?
    var cityInfo: String?
    var currentCity: String?
    var locationManager = CLLocationManager()
    var forecastViewController = ForecastViewController()
    var geoCoder = CLGeocoder()
    
    let reachability = try! Reachability()
    var connection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testingConnection(reachability)
        reachability.stopNotifier()
        setupWeatherFromCache()  
    }
    
    func testingConnection(_ reachability: Reachability) {
        
        reachability.whenReachable = { reachability in
            self.connection = true
            self.errorConnectionView.isHidden = true
            self.cacheButton.isEnabled = false
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
        }
        
        reachability.whenUnreachable = { _ in
            self.connection = false
            self.cacheButton.isEnabled = true
            self.currentWeatherView.delegate = self
            self.errorConnectionView.isHidden = false
            self.errorConnectionView.flash()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
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
        performSegue(withIdentifier: "showForecastWeather", sender: self)
    }
    
    func showAlertAction(title: String, message: String, placeholder: String) {
        let newCityAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        newCityAlert.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.autocapitalizationType = .words
        }
        newCityAlert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
        
        self.present(newCityAlert, animated: true, completion: nil)
        
        newCityAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let textField = newCityAlert.textFields![0]
            
            guard textField.text?.isEmpty == false else { return }
            if self.connection {
                self.currentWeatherRequest(with: textField.text!)
            } else {
                self.currentWeatherRealmModel = StorageManager.findCurrentWeatherByName(textField.text!).first
                self.setupWeatherFromCache()
                
            }
        }))
    }
    
    func showErrorAlert() {
        let newErrorAlert = UIAlertController(title: "Ошибка интернет соединения", message: "Просмотрите сохраненную ранее погоду", preferredStyle: .alert)
        
        newErrorAlert.addAction(UIAlertAction(title: "Выбрать", style: .default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "ShowCacheViewController", sender: self)
        }))
        self.present(newErrorAlert, animated: true, completion: nil)
    }
    
    @IBAction func goToCurrentLocationAction(_ sender: UIBarButtonItem) {
        
        testingConnection(reachability)
        if currentCity != nil {
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
            self.currentWeatherRequest(with: self.currentCity ?? self.cityInfo!)
            self.locationManager.stopUpdatingLocation()
        } else {
            self.showErrorAlert()
        }
    }
    
    @IBAction func newCitySearchBarButton(_ sender: UIBarButtonItem) {

            self.showAlertAction(title: "Новый город", message: "Введите название", placeholder: "Название города")
    }
    
    //MARK: - Alamofire request
    
    func currentWeatherRequest(with cityInfo: String) {
        APIServices.shared.getObject(method: .currentEventMethod, params: ["q": cityInfo, "appid": "d988069c070ff798d8c1fea149be599a"])
        {[weak self](result: CurrentWeatherModel?, error: Error?) in
            if let error = error {
                print("\(error)")
                self?.showAlertAction(title: "Ошибка",
                                      message: "Введите корректное имя города или проверьте интернет соединение",
                                      placeholder: "Название города")
                self?.testingConnection(self!.reachability)
            } else if let currentResult = result {
                self?.cityInfo = cityInfo
                self?.navigationItem.title = cityInfo
                self?.currentWeatherUpdate(from: currentResult)
                self?.saveObject(from: currentResult)
            }
        }
    }
    
    func saveObject(from result: CurrentWeatherModel) {
        
        
        let newWeather = CurrentWeatherRealmModel(name: result.name,
                                                  country: result.sys!.country,
                                                  icon: result.weather.first!.icon,
                                                  temp: result.main!.temp,
                                                  tempMin: result.main!.temp_min,
                                                  tempMax: result.main!.temp_max,
                                                  pressure: result.main!.pressure,
                                                  humidity: result.main!.humidity,
                                                  speed: result.wind!.speed,
                                                  cloudy: result.clouds!.all)
        StorageManager.saveObject(newWeather)
        
    }
    
    private func setupWeatherFromCache() {
        
        testingConnection(reachability)
        if currentWeatherRealmModel != nil {
            if connection == false {

            navigationItem.title = currentWeatherRealmModel!.name + ", " + currentWeatherRealmModel!.country
            currentWeatherView.tempLabel?.text = String(format: "%.0f", (currentWeatherRealmModel!.temp) - 273.15) + "°C"
            currentWeatherView.pressureLabel?.text = String(format: "%.0f", Double(currentWeatherRealmModel!.pressure) * 0.75) + " мм рт. ст."
            currentWeatherView.humidityLabel?.text = String(currentWeatherRealmModel!.humidity) + " %"
            currentWeatherView.windSpeedLabel?.text = String(currentWeatherRealmModel!.speed) + " м/с"
            currentWeatherView.cloudsLabel?.text = String(currentWeatherRealmModel!.cloudy) + " %"
            self.cityInfo = currentWeatherRealmModel!.name
            
            } else {
                currentWeatherRequest(with: currentWeatherRealmModel!.name)
            }
        }
    }
    
    private func currentWeatherUpdate(from result: CurrentWeatherModel) {
        navigationItem.title = result.name + ", " + result.sys!.country
        
        currentWeatherView.tempLabel?.text = String(format: "%.0f", (result.main!.temp) - 273,15) + "°C"
        
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
    @IBAction func showCacheViewCotrollerAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ShowCacheViewController", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let forecastViewController = segue.destination as? ForecastViewController else { return }
        forecastViewController.cityInfo = cityInfo
        forecastViewController.connection = connection
        
        let backItem = UIBarButtonItem()
        backItem.title = "Сегодня"
        navigationItem.backBarButtonItem = backItem
    }
    
}


