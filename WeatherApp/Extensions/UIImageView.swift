//
//  UIImageView.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 24.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadIcon(with imgUrl: URL) {
        DispatchQueue.global().async {
            [weak self] in
            guard let data = try? Data(contentsOf: imgUrl) else { return }
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
