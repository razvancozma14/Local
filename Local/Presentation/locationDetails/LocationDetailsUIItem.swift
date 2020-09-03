//
//  LocationDetailsUIItem.swift
//  Local
//
//  Created by Razvan Cozma on 02/09/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation

enum LocationDetailsUIItem{
    case locationTitle(name: String)
    case address(address: String)
    case details(detailsTitle: String, detailsSubtitle: String)
    case image(imageUrl: URL?)
    case map(latitude: Double, longitude: Double)
}
