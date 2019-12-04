//
//  APIServices.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 03.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import Foundation
import Alamofire

final public class APIServices {
   
    public static let shared = APIServices()
    
    private(set) var domain = "https://api.openweathermap.org"
    
    public static let eventMethod = "/data/2.5/forecast"
    
    public func getObject<T:Codable>(
        method: String,
        params: Parameters,
        handler: @escaping (_ object: T?, _ error: Error?) -> Void) {
        
        let resultURL = domain + method
        
        request(resultURL, parameters: params).responseData() { response in
            response.result.withValue { data in
                do {
                    let result = try JSONDecoder.init().decode(T.self, from: data)
//                    print(response)
                    
                    handler(result, nil)
                } catch (let error) {
                    handler(nil, error)
                }
            }.withError { error in
                handler(nil, error)
            }
        }
    }
}
