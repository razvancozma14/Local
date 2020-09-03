//
//  LocalResult.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import CoreLocation

protocol Result {}

enum LocalResult: Result {
    case showLoading
    case error(error: Error)
    case success
    case locations(locations: [Location], userLocations: CLLocation?)
    case location(locations: Location, userLocations: CLLocation?)
    case locationPermission(status: CLAuthorizationStatus)
}

enum CoreError: Swift.Error {
    case network(statusCode: Int)
    case decodingResponse(error: Swift.Error)
    case generalError
}
