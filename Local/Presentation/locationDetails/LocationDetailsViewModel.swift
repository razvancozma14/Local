//
//  LocationDetailsViewModel.swift
//  Local
//
//  Created by Razvan Cozma on 02/09/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwift
import MapKit

class LocationDetailsViewModel {
    let locationUIItems : PublishSubject<[LocationDetailsUIItem]> = PublishSubject()
    
    private let locaRepository: LocalRepository
    private let schedulers: AppSchedulers
    private let locationName: String
    private let disposable = DisposeBag()
    
    init(locationName: String,
         locaRepository: LocalRepository,
         schedulers: AppSchedulers){
        self.schedulers = schedulers
        self.locaRepository = locaRepository
        self.locationName = locationName
    }
    
    func fetchData(){
        locaRepository.observeLocation(name: locationName)
            .observeOn(schedulers.computation)
            .do(onNext: {[unowned self] (result) in
                switch result {
                case LocalResult.location(let location, let userLocations):
                    var items = [LocationDetailsUIItem]()
                    items.append(.locationTitle(name: location.name))
                    items.append(.image(imageUrl: URL(string: location.image)))
                    items.append(.map(latitude: location.lat, longitude: location.lng))
                    items.append(.address(address: location.address))
                    items.append(.details(detailsTitle: "Coordinates", detailsSubtitle: "\(location.lat) \(location.lng)"))
                    let secondPoint = CLLocation(latitude: location.lat, longitude: location.lng)
                    if let distance = self.distanceBetween2Points(firstPoint: userLocations, secondPonit: secondPoint) {
                        items.append(.details(detailsTitle: "Distance", detailsSubtitle: distance))
                    }
                    
                    self.locationUIItems.onNext(items)
                default: break
                }
            }).subscribe()
            .disposed(by: disposable)
    }
    
    func updateAddress(address: String){
        locaRepository.updateLocationAddress(name: locationName, newAddress: address)
    }
    
    private func distanceBetween2Points(firstPoint: CLLocation?, secondPonit: CLLocation?) ->  String? {
        guard let fPoint = firstPoint, let sPoint = secondPonit else {
            return nil
        }
        
        let distance = fPoint.distance(from: sPoint) / 1000.0
        return "\(String(format: "%.1f", distance)) km"
    }
}
