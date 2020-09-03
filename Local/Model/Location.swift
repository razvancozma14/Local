//
//  Location.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object, Codable {
    @objc dynamic var lat : Double = 0
    @objc dynamic var lng : Double = 0
    @objc dynamic var name : String = ""
    @objc dynamic var address : String = ""
    @objc dynamic var image : String = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    enum CodingKeys: String, CodingKey {
        
        case lat = "lat"
        case lng = "lng"
        case name = "label"
        case address = "address"
        case image = "image"
    }
    
    enum CoordinatesCodingKeys: String, CodingKey {
        case lat = "latitude"
        case lng = "longitude"
    }
    
    
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat) ?? 0
        if lat == 0 {
            let values = try decoder.container(keyedBy: CoordinatesCodingKeys.self)
            lat = try values.decodeIfPresent(Double.self, forKey: .lat) ?? 0
        }
        
        lng  = try values.decodeIfPresent(Double.self, forKey: .lng) ?? 0
        if lng == 0 {
            let values = try decoder.container(keyedBy: CoordinatesCodingKeys.self)
            lng = try values.decodeIfPresent(Double.self, forKey: .lng) ?? 0
        }
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? "-1"
        address = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        super.init()
    }
    
    required init()
    {
        super.init()
    }
    
    
    
}

//extension Location: Equatable {
//}

func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.name == rhs.name
}
