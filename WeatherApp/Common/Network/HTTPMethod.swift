//
//  HTTPMethod.swift
//  WeatherApp
//
//  Created by tamu on 23/03/23.
//

import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

struct NetworkConfiguration {
    fileprivate static let base_url = "http://api.openweathermap.org/data/2.5/"
    static let kTokenExpiredErrorCode = 405
    static let kGatewayTimeoutErrorCode = 503
    static let kMissingPhoneNumberErrorCode = 403
    static let sessionExpired = 401
    
    static let apiKey = "1b7eeecd2ff64dc83e8dcf1f4cb2102b"
    static var envBaseUrl: String = {
        return base_url
    }()
    
    static func api(_ apiType: APIUrl) -> String {
        return envBaseUrl + apiType.apiString()
    }
}
