//
//  HomeRepository.swift
//  WeatherApp
//
//  Created by tamu on 23/03/23.
//

import RxSwift

class HomeRepository: HomeDataSource {
    private let remoteData: NetworkProtocol
    
    init(remoteData: NetworkProtocol) {
        self.remoteData = remoteData
    }
    
    func getWeatherByCity(request: RequestModel) -> Observable<WeatherModel?> {
        let url = APIUrl.cityWeather(request: request).urlString()
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        return remoteData.get(url: urlString).flatMap { data -> Observable<WeatherModel?> in
            do {
                let responseModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                return Observable.just(responseModel)
            } catch {
                return Observable.error(error)
            }
        }
    }
}
