//
//  DailyWeatherCell.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 04.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit

class DailyWeatherCell: UITableViewCell {

    @IBOutlet weak var weatherValueLabel: UILabel!
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var pressureValueLabel: UILabel!
    @IBOutlet weak var windSpeedValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(for sections: [ForecastWeatherSectionModel], and indexPath: IndexPath) {
        
        let row = sections[indexPath.section].cells[indexPath.row]
        
        weatherValueLabel?.text = String(row.temp).celsius
        dateValueLabel?.text = row.time
        humidityValueLabel?.text = String(row.humidity).percent
        pressureValueLabel?.text = String(row.pressure).millimetreOfMercury
        windSpeedValueLabel?.text = String(row.speed).metersPerSecond
        print(row)
        weatherIconImage.loadIcon(with: row.imageUrl ?? URL(string: "localhost:8080")!)

    }
    
}
