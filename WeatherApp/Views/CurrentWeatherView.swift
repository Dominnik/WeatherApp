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
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
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
    
}


