//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 09.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

protocol CurrentWeatherViewDelegate: class {
    func goToForecastViewController()
}

class CurrentWeatherView: UIView {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    weak var delegate: CurrentWeatherViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("CurrentWeatherView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func showForecastWeatherAction(_ sender: UIButton) {
        
        delegate?.goToForecastViewController()
    }
    
    func configure(with result: CurrentWeatherModel) {
        
        tempLabel?.text = String(format: "%.0f", (result.main!.temp).celsius).celsius
        if let pressure = result.main?.pressure {
            pressureLabel?.text = String(format: "%.0f", Double(pressure).millimetreOfMercury).millimetreOfMercury
        }
        if let windSpeed = result.wind?.speed {
            windSpeedLabel?.text = String(windSpeed).metersPerSecond
        }
        if let humidity = result.main?.humidity {
            humidityLabel?.text = String(humidity).percent
        }
        if let overcast = result.clouds?.all {
            cloudsLabel?.text = String(overcast).percent
        }
        let icons = result.weather.compactMap { day in
            return day
        }
        guard let iconUrl = URL(string: (icons.first?.icon)!.iconURL) else { return }
        iconImageView.loadIcon(with: iconUrl)

    }
    
    func setupWeatherFromCache(_ currentWeatherRealmModel: CurrentWeatherRealmModel) {
        
        tempLabel?.text = String(format: "%.0f", (currentWeatherRealmModel.temp).celsius).celsius
        pressureLabel?.text = String(format: "%.0f", Double(currentWeatherRealmModel.pressure).millimetreOfMercury).millimetreOfMercury
        humidityLabel?.text = String(currentWeatherRealmModel.humidity).percent
        windSpeedLabel?.text = String(currentWeatherRealmModel.speed).metersPerSecond
        cloudsLabel?.text = String(currentWeatherRealmModel.cloudy).percent
    }
    
    
}


