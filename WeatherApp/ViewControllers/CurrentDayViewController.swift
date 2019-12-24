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
    @IBOutlet weak var currentLocationButton: UIBarButtonItem!
    
    var currentWeatherRealmModel: CurrentWeatherRealmModel?
    var cachedViewController: CacheViewController?
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
//        currentWeatherView.setupWeatherFromCache(currentWeatherRealmModel!)
    }
    
    func testingConnection(_ reachability: Reachability) {
        
        reachability.whenReachable = { reachability in
            self.connection = true
            self.errorConnectionView.isHidden = true
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
        }
        
        reachability.whenUnreachable = { _ in
            self.connection = false
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
            self.currentWeatherView.activityLoader.startAnimating()
            let textField = newCityAlert.textFields![0]
            
            guard textField.text?.isEmpty == false else { return }
            if self.connection {
                self.currentWeatherRequest(with: textField.text!)
            } else {
                self.currentWeatherRealmModel = StorageManager.findObjectByName(textField.text!).first
                self.navigationItem.title = self.currentWeatherRealmModel?.name
                self.cityInfo = self.currentWeatherRealmModel?.name
                if self.currentWeatherRealmModel != nil {
                    self.currentWeatherView.setupWeatherFromCache(self.currentWeatherRealmModel!)
                } else {
                    self.showErrorAlert()
                }

            }
            self.currentWeatherView.activityLoader.stopAnimating()
        }))
    }
    
    func showErrorAlert() {
        let newErrorAlert = UIAlertController(title: "Ошибка интернет соединения", message: "Просмотрите сохраненную ранее погоду", preferredStyle: .alert)
        
        newErrorAlert.addAction(UIAlertAction(title: "Выбрать", style: .default, handler: { (UIAlertAction) in
            self.showCacheViewController()
        }))
        self.present(newErrorAlert, animated: true, completion: nil)
    }
    
    @IBAction func goToCurrentLocationAction(_ sender: UIBarButtonItem) {

            testingConnection(reachability)
            if currentCity != nil && connection {
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
        currentWeatherView.activityLoader.startAnimating()
        
        APIServices.shared.getObject(method: .currentEventMethod, params: ["q": cityInfo, "appid": APIServices.shared.userId]) {
            (res: Result<CurrentWeatherModel, Error>) in
            switch res {
            case .success(let result):
                self.cityInfo = cityInfo
                self.navigationItem.title = cityInfo
                self.currentWeatherView.configure(with: result)
                self.currentWeatherView.activityLoader.stopAnimating()
                self.locationManager.stopUpdatingLocation()
                self.saveObject(from: result)
            case .failure(let error):
                print("\(error)")
                self.currentWeatherView.activityLoader.stopAnimating()
                self.showAlertAction(title: "Ошибка",
                                      message: "Введите корректное имя города или проверьте интернет соединение",
                                      placeholder: "Название города")
                self.testingConnection(self.reachability)
            }
        }
    }
    
    //MARK: - Work with database
    
    func saveObject(from result: CurrentWeatherModel) {

        let newWeather = CurrentWeatherRealmModel()
        newWeather.getResultFromModel(with: result)
        StorageManager.saveObject(newWeather)
    }
    
    func showCacheViewController() {
        
        let cachedViewController = storyboard?.instantiateViewController(identifier: "CacheViewController") as! CacheViewController
        cachedViewController.delegate = self
        present(cachedViewController, animated: true, completion: nil)
    }
    
    @IBAction func showCacheViewCotrollerAction(_ sender: UIBarButtonItem) {
        showCacheViewController()
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

extension CurrentDayViewController: CacheDataDelegate {
    func sendCacheModel(_ currentCachedWeatherRealmModel: CurrentWeatherRealmModel) {
        navigationItem.title = currentCachedWeatherRealmModel.name + ", " + currentCachedWeatherRealmModel.country
        currentWeatherView.tempLabel?.text = String(format: "%.0f", (currentCachedWeatherRealmModel.temp).celsius).celsius
        currentWeatherView.pressureLabel?.text = String(format: "%.0f", Double(currentCachedWeatherRealmModel.pressure).millimetreOfMercury).millimetreOfMercury
        currentWeatherView.humidityLabel?.text = String(currentCachedWeatherRealmModel.humidity).percent
        currentWeatherView.windSpeedLabel?.text = String(currentCachedWeatherRealmModel.speed).metersPerSecond
        currentWeatherView.cloudsLabel?.text = String(currentCachedWeatherRealmModel.cloudy).percent
        self.cityInfo = currentCachedWeatherRealmModel.name
    }
}






