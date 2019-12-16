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

class CurrentDayViewController: UIViewController {
    
    @IBOutlet weak var currentWeatherView: CurrentWeatherView!
    

    var cityInfo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentWeatherRequest()

    }
    
    func currentWeatherRequest() {
        APIServices.shared.getObject(method: .currentEventMethod, params: ["q": cityInfo!, "appid": "d988069c070ff798d8c1fea149be599a"])
        {[weak self](result: CurrentWeatherModel?, error: Error?) in
            if let error = error {
                print("\(error)")
            } else if let currentResult = result {
//                print("\(currentResult)")
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


    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


