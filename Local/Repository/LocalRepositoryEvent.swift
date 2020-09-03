//
//  LocalRepositoryEvent.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocalRepositoryEvent {}

struct NewDataEvent: LocalRepositoryEvent {}

struct RequestNewDataEvent: LocalRepositoryEvent {}

struct ReloadeCurrentLocation: LocalRepositoryEvent {
    let name: String
}

 
