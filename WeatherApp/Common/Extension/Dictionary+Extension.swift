//
//  Dictionary+Extension.swift
//  WeatherApp
//
//  Created by tamu on 23/03/23.
//

import Foundation

extension Dictionary {
    func toQueryString() -> String {
        var queryString: String = ""
        for (key,value) in self {
            queryString += "\(key)=\(value)&"
        }
        return String(queryString.dropLast())
    }
}
