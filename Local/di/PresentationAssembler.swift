//
//  PresentationAssembler.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation

protocol PresentationAssembler {
    func resolve() -> NavigatorType
    func resolve() -> HomeViewModel
    func resolve() -> HomeviewControlller
    func resolve(name: String) -> LocationDetailsViewModel
    func resolve(name: String) -> LocationDetailsViewController
}

extension PresentationAssembler where Self: Assembler {
    func resolve() -> NavigatorType {
        return Navigator(assembler: self)
    }
    func resolve() -> HomeViewModel{
        return HomeViewModel(localRepository: resolve(), schedulers: resolve())
    }
    
    func resolve() -> HomeviewControlller{
        return HomeviewControlller(viewModel: resolve(), navigator: resolve())
    }
    
    func resolve(name: String) -> LocationDetailsViewModel{
        return LocationDetailsViewModel(locationName: name, locaRepository: resolve(), schedulers: resolve())
    }
    
    func resolve(name: String) -> LocationDetailsViewController{
        return LocationDetailsViewController(viewModel: resolve(name: name), navigator: resolve())
    }
}
