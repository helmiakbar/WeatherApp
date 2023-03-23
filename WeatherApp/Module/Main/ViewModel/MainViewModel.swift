//
//  MainViewModel.swift
//  WeatherApp
//
//  Created by tamu on 23/03/23.
//

class MainViewModel: BaseViewModel {
    private let dataSource: HomeDataSource
    var citiesModel: [City]! = []
    let weatherType = ["Clear", "Clouds", "Rain", "Snow"]
    let cities = [["name": "Lake Zurich", "id": 4899170], ["name": "Upper Hutt", "id": 6244895], ["name": "Davos", "id": 2661039], ["name": "Alaska", "id": 5879092], ["name": "Malyy Yermuchash", "id": 6198431], ["name": "Sahara Village", "id": 5780908], ["name": "Sandy Hills", "id": 5781070], ["name": "Belgrade", "id": 792680], ["name": "Ystads Kommun", "id": 2662148], ["name": "California", "id": 4350049]]
    var datas: [WeatherData]! = []
    var tempDatas: [WeatherData]! = []
    
    init(dataSource: HomeDataSource) {
        self.dataSource = dataSource
    }
    
    func insertToCityModel() {
        for city in cities {
            let cityObj = City(id: city["id"] as? Int ?? 0, name: city["name"] as? String ?? "")
            citiesModel.append(cityObj)
            loadCityWeather(city: cityObj)
        }
    }
    
    func getCitiesCount() -> Int {
        return tempDatas.count
    }
    
    func populateWeatherByType(weatherType: String) {
        tempDatas.removeAll()
        for data in datas {
            let datas = data.datas?.filter{$0.weather?.first?.main == weatherType}
            let obj = WeatherData(city: data.city, datas: datas, datasCount: datas?.count)
            tempDatas.append(obj)
        }
        sortData()
    }
    
    func sortData() {
        tempDatas.sort { $0.datasCount == $1.datasCount ? $0.city?.name ?? "" < $1.city?.name ?? "" : $0.datasCount ?? 0 > $1.datasCount ?? 0 }
    }
    
    func loadCityWeather(city: City) {
        state.accept(.loading)
        let request = RequestModel(cityId: city.id, apiKey: NetworkConfiguration.apiKey)
        dataSource.getWeatherByCity(request: request)
            .subscribe(onNext: { [weak self] responseModel in
                let obj = WeatherData(city: city, datas: responseModel?.list, datasCount: responseModel?.list?.count)
                self?.datas.append(obj)
                if self?.datas.count == self?.cities.count {
                    self?.tempDatas = self?.datas
                    self?.sortData()
                    self?.state.accept(.finished)
                }
            }, onError: { [weak self] error in
                self?.handleNetworkError(error)
                self?.state.accept(.failed)
            })
            .disposed(by: disposeBag)
    }
}
