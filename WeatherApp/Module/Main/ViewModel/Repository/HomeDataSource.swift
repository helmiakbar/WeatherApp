//
//  HomeDataSource.swift
//  WeatherApp
//
//  Created by tamu on 23/03/23.
//

import RxSwift

protocol HomeDataSource {
    func getWeatherByCity(request: RequestModel) -> Observable<WeatherModel?>
}
