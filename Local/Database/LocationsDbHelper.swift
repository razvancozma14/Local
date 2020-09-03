//
//  LocationsDbHelper.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RealmSwift
import RxSwift
import Foundation

class LocationsDbHelper {
    
    init(){
    }
    
    func updateOrdInserLocations(locations: [Location]) {
        let realm = try! Realm()
        do {
            for item in locations {
                if let currentObject = realm.object(ofType:Location.self, forPrimaryKey: item.name) {
                    item.address = currentObject.address
                }
                
                try realm.write {
                    realm.add(item, update: .modified)
                }
            }
        }catch{ print(error)}
    }
    
    func loadLocationsSingle() -> Observable<[Location]> {
        
        return Observable.deferred { () -> Observable<[Location]> in
            let realm = try! Realm()
            let locations = realm.objects(Location.self).filter("lat != 0 && lng != 0").toArray(type: Location.self).map({Location(value: $0)})
            return Observable.just(locations)
        }
    }
    
    func loadLocationSingle(name: String) -> Single<Location?> {
        let realm = try! Realm()
        return Single.deferred { [weak self] () -> Single<Location?> in
            return Single.just(realm.object(ofType:Location.self, forPrimaryKey: name).map({Location(value: $0)}))
        }
    }
    
    func updateLocationAddress(name: String, address: String){
        let realm = try! Realm()
        do {
            try realm.write {
            realm.create(Location.self, value: ["name": name, "address": address], update: .modified)
            }
        }catch { print(error) }
    }
}

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
