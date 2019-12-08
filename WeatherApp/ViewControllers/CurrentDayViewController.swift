//
//  CurrentDayViewController.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 09.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit
import SceneKit

class CurrentDayViewController: UIViewController {

    @IBOutlet weak var currentWeatherView: CurrentWeatherView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentWeatherView.helloLabel?.text = "Holy Shit! It works!"
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


