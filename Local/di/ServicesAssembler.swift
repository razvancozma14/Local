//
//  ServicesAssembler.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation

import Foundation

fileprivate var sharedInstances: [String : Any] = [:]

protocol ServicesAssembler {
    func resolve() -> LocalService
    func resolve() -> LocalRepository
    func resolve() -> LocationsDbHelper
    func resolve() -> GeolocationService
}

extension ServicesAssembler where Self: Assembler {
    func resolve() -> LocalService {
        let key = String(describing: LocalService.self)
        if let instance = sharedInstances[key] as? LocalService {
            return instance
        }
        let service = LocalService(appSchedulers: resolve())
        
        sharedInstances[key] = service
        return service
    }
    
    func resolve() -> LocalRepository {
        let key = String(describing: LocalRepository.self)
        if let instance = sharedInstances[key] as? LocalRepository {
            return instance
        }
        let service = LocalRepository(localService: resolve(), locationsDbHelper: resolve(), locationService: resolve(), schedulers: resolve())
        
        sharedInstances[key] = service
        return service
    }
    
    func resolve() -> LocationsDbHelper {
        let key = String(describing: LocationsDbHelper.self)
        if let instance = sharedInstances[key] as? LocationsDbHelper {
            return instance
        }
        let service = LocationsDbHelper()
        
        sharedInstances[key] = service
        return service
    }
    func resolve() -> GeolocationService{
        let key = String(describing: GeolocationService.self)
        if let instance = sharedInstances[key] as? GeolocationService {
            return instance
        }
        let service = GeolocationService(schedulers: resolve())
        
        sharedInstances[key] = service
        return service
    }
}
