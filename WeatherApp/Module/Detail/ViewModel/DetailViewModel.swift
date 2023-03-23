//
//  DetailViewModel.swift
//  WeatherApp
//
//  Created by tamu on 24/03/23.
//

import Foundation

class DetailViewModel: BaseViewModel {
    private let dataSource: DetailDataSource
    var responseData: CurrentWeather?
    
    init(dataSource: DetailDataSource) {
        self.dataSource = dataSource
    }
    
    func loadCurrentWeather(cityId: Int) {
        state.accept(.loading)
        let request = RequestModel(cityId: cityId, apiKey: NetworkConfiguration.apiKey)
        dataSource.getCurrentWeather(request: request)
            .subscribe(onNext: { [weak self] responseModel in
                self?.responseData = responseModel
                self?.state.accept(.finished)
            }, onError: { [weak self] error in
                self?.handleNetworkError(error)
                self?.state.accept(.failed)
            })
            .disposed(by: disposeBag)
    }
}
