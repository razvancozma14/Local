//
//  MyLocationsRespons.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation


struct MyLocationsRespons: Codable {
    let status : String?
    let locations : [Location]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case locations = "locations"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        locations = try values.decodeIfPresent([Location].self, forKey: .locations)
    }

}

enum ResponseStatus: String{
    case ok
}

