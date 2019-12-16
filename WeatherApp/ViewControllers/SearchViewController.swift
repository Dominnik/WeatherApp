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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        guard searchTF.text?.isEmpty == false else { return }
        
        //TODO: доделать do-catch
        do {
            performSegue(withIdentifier: "cityNameSegue", sender: nil)
        } catch {
        
            let alert = UIAlertController(title: "Wrong format", message: "Please enter city name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    

    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let forecastViewController = segue.destination as? ViewController else { return }
        forecastViewController.cityInfo = searchTF.text
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}
