//
//  APIUrl.swift
//  WeatherApp
//
//  Created by tamu on 23/03/23.
//

import Foundation

enum APIUrl {
    case cityWeather(request: RequestModel)
    case weather(request: RequestModel)

    func apiString() -> String {
        switch self {
        case .cityWeather(let request):
            return "forecast?\(request.getParams().toQueryString())"
        case .weather(let request):
            return "weather?\(request.getParams().toQueryString())"
        }
    }
    
    func urlString() -> String {
        return NetworkConfiguration.api(self)
    }
}
