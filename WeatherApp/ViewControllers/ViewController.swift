//
//  ViewController.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 03.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var items: [Main] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIServices.shared.getObject(method: APIServices.eventMethod, params: ["q": "Samara,ru", "appid": "d988069c070ff798d8c1fea149be599a"])
        {[weak self](result : WeatherModel?, error: Error?) in
            if let error = error {
                print("\(error)")
            } else if let result = result {
                print("\(result)")
                self?.update(from: result)
            }
        }
    }
    
    private func update(from result: WeatherModel) {
        navigationItem.title = result.city.name
        items = result.list.compactMap { day in
            return day.main
        }
        print(result.city.name)
        print(items)
        tableView.reloadData()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        

        cell.textLabel?.text = String(items[indexPath.row].temp)
            
        
        return cell
    }
    
}

