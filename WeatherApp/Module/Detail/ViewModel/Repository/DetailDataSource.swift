//
//  DetailDataSource.swift
//  WeatherApp
//
//  Created by tamu on 24/03/23.
//

import RxSwift

protocol DetailDataSource {
    func getCurrentWeather(request: RequestModel) -> Observable<CurrentWeather?>
}
