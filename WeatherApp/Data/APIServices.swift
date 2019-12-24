//
//  APIServices.swift
//  WeatherApp
//
//  Created by Andrey Kovalenko on 03.12.2019.
//  Copyright © 2019 Andrey Kovalenko. All rights reserved.
//

import Foundation
import Alamofire

public enum ApiMethod: String {
    
    case forecastEventMethod = "/data/2.5/forecast"
    case currentEventMethod = "/data/2.5/weather"
}

final public class APIServices {
   
    public static let shared = APIServices()
    private let formatter = DateFormatterFactory()
    
    private(set) var domain = "https://api.openweathermap.org"
    public var userId = "d988069c070ff798d8c1fea149be599a"
    
    
    public func getObject<T:Decodable>(
        method: ApiMethod,
        params: Parameters,
        handler: @escaping (Swift.Result<T, Error>) -> Void) {
        
        let resultURL = domain + method.rawValue
        
        request(resultURL, parameters: params).responseData() { response in
            response.result.withValue { data in
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(self.formatter.dateFormatter)
                    let result = try decoder.decode(T.self, from: data)
                    handler(.success(result))
                } catch (let error) {
                    handler(.failure(error))
                }
            }.withError { error in
                handler(.failure(error))
            }
        }
    }
}
