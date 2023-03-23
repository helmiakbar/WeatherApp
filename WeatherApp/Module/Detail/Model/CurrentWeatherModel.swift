//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by tamu on 24/03/23.
//

import Foundation

struct CurrentWeather: Codable {
    let id: Int?
    let name: String?
    let sys: Sys?
    let wind: Wind?
    let visibility: Int?
    let main: Main?
    let weather: [Weather]?
}
