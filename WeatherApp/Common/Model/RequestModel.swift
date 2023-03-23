//
//  RequestModel.swift
//  WeatherApp
//
//  Created by tamu on 23/03/23.
//

import Foundation

struct RequestModel {
    var cityId: Int? = 0
    var apiKey: String? = ""
    
    func getParams() -> [String: Any] {
        var params = [String: Any]()
        params["appid"] = apiKey
        params["id"] = cityId
        return params
    }
}
