//
//  DetailRepository.swift
//  WeatherApp
//
//  Created by tamu on 24/03/23.
//

import RxSwift

class DetailRepository: DetailDataSource {
    private let remoteData: NetworkProtocol
    
    init(remoteData: NetworkProtocol) {
        self.remoteData = remoteData
    }
    
    func getCurrentWeather(request: RequestModel) -> Observable<CurrentWeather?> {
        let url = APIUrl.weather(request: request).urlString()
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        return remoteData.get(url: urlString).flatMap { data -> Observable<CurrentWeather?> in
            do {
                let responseModel = try JSONDecoder().decode(CurrentWeather.self, from: data)
                return Observable.just(responseModel)
            } catch {
                return Observable.error(error)
            }
        }
    }
}
