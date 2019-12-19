//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 08.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTF: UITextField!
    
    private let locationManager = LocationManager()
    var cityInfo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let exposedLocation = self.locationManager.exposedLocation else {
            print("*** Error in \(#function): exposedLocation is nil")
            return
        }
        
        self.locationManager.getPlace(for: exposedLocation) { (placemark) in
            
            guard let placemark = placemark else { return }
            
            if let city = placemark.locality {
                self.cityInfo = city
                print("&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&!")
                print(city)
            }
        }
        
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        guard searchTF.text?.isEmpty == false else { return }
        
        performSegue(withIdentifier: "cityNameSegue", sender: nil)

    }

    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let currentDayViewController = segue.destination as? CurrentDayViewController else { return }
        currentDayViewController.cityInfo = cityInfo
        currentDayViewController.navigationItem.title = cityInfo
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}
