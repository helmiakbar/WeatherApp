//
//  DetailAssembly.swift
//  WeatherApp
//
//  Created by tamu on 24/03/23.
//

import Swinject

class DetailAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkProtocol.self) { r in
            return NetworkProvider()
        }
        
        container.register(DetailDataSource.self) { r in
            guard let dataProvider = r.resolve(NetworkProtocol.self) else {
                fatalError("Unexpectedly found nil while unwrapping an Optional value")
            }
            return DetailRepository(remoteData: dataProvider)
        }

        container.register(DetailViewModel.self) { r in
            guard let dataSource = r.resolve(DetailDataSource.self) else {
                fatalError("Unexpectedly found nil while unwrapping an Optional value")
            }
            return DetailViewModel(dataSource: dataSource)
        }
    }
}
