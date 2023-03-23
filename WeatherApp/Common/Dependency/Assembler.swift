//
//  Assembler.swift
//  WeatherApp
//
//  Created by tamu on 23/03/23.
//

import Foundation
import Swinject

extension Assembler {
    static let sharedAssembler: Assembler = {
        let container = Container()
        let assembler = Assembler([
            HomeAssembly(),
            DetailAssembly()
        ], container: container)
        return assembler
    }()
    
}
