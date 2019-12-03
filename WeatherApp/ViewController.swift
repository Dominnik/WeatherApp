//
//  ViewController.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 03.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRequest()
    }
    
    func getRequest() {
        
        let jsonUrlString = "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=d988069c070ff798d8c1fea149be599a"
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.downloadTask(with: url) { (location, response, error) in
            
            let weatherData = try? Data(contentsOf: url)
            
            do {
                let weatherJson = try JSONSerialization.jsonObject(with: weatherData!, options: []) as! Dictionary<String, Any>
                let weather = WeatherModel(weatherJson: weatherJson)
                
                print(weather.nameCity, Int(weather.temp))
            } catch {
                print(error)
            }
        }.resume()
        
        
    }
    
}

