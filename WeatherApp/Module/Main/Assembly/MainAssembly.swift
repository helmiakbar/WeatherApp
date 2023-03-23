//
//  MainAssembly.swift
//  WeatherApp
//
//  Created by tamu on 23/03/23.
//

import Swinject

class HomeAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkProtocol.self) { r in
            return NetworkProvider()
        }
        
        container.register(HomeDataSource.self) { r in
            guard let dataProvider = r.resolve(NetworkProtocol.self) else {
                fatalError("Unexpectedly found nil while unwrapping an Optional value")
            }
            return HomeRepository(remoteData: dataProvider)
        }

        container.register(MainViewModel.self) { r in
            guard let dataSource = r.resolve(HomeDataSource.self) else {
                fatalError("Unexpectedly found nil while unwrapping an Optional value")
            }
            return MainViewModel(dataSource: dataSource)
        }
    }
}
