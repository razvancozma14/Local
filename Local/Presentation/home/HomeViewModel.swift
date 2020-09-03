//
//  HomeViewModel.swift
//  Local
//
//  Created by Razvan Cozma on 01/09/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwiftExt
import RxSwift
import RxCocoa
import CoreLocation

class HomeViewModel {
    public enum HomeError {
        case internetError(String)
        case locationDisabled
    }
    
    let locationsUIItems : PublishSubject<[HomeUIItem]> = PublishSubject()
    let uiEvents: PublishSubject<UIEvent> = PublishSubject<UIEvent>()
    let loading: PublishSubject<Bool> = PublishSubject()
    let error : PublishSubject<HomeError> = PublishSubject()
    
    private let localRepository: LocalRepository
    private let schedulers: AppSchedulers
    private let disposable = DisposeBag()
    
    init(localRepository: LocalRepository,
         schedulers: AppSchedulers){
        self.schedulers = schedulers
        self.localRepository = localRepository
    }
    
    func fetchData(){
        let requestData = uiEvents.ofType(HomeLocationsEvent.self)
            .startWith(HomeLocationsEvent())
            .do(onNext: {[unowned self] (_) in
                self.loading.onNext(true)
            })
            .observeOn(schedulers.computation)
            .flatMapLatest{[unowned self] _ in
                return self.localRepository.requestLocations()
        }
        
        Observable.merge(requestData,
                         localRepository.observeLocations(),
                         localRepository.authorizedLocation())
            .do(onNext: {[unowned self] (result) in
                switch result {
                case LocalResult.locationPermission(let status):
                    if status == .denied {
                        self.error.onNext(.locationDisabled)
                    }
                case LocalResult.error(let error):
                    print(error)
                    self.loading.onNext(false)
                    self.error.onNext(.internetError("Something went wrong"))
                case LocalResult.locations(let locations, let userLocation):
                    
                    var uiItems: [HomeUIItem] = locations.map({[unowned self] (location) -> HomeUIItem in
                        var address = location.address
                        let secondPoint = CLLocation(latitude: location.lat, longitude: location.lng)
                        if let distance = self.distanceBetween2Points(firstPoint: userLocation, secondPonit: secondPoint) {
                            address = "\(location.address) - \(distance) km"
                        }
                        return HomeUIItem(name: location.name,
                                          imageUrl: URL(string: location.image),
                                          address: address,
                                          location: CLLocation(latitude: location.lat, longitude: location.lng))
                    })
                    uiItems = uiItems.sorted(by: {$0.name < $1.name})
                    self.locationsUIItems.onNext(uiItems)
                case LocalResult.success:
                    self.loading.onNext(false)
                default: break
                }
            })
            .subscribe()
            .disposed(by: disposable)
    }
    
    func retry(){
        uiEvents.onNext(HomeLocationsEvent())
    }
    
    private func distanceBetween2Points(firstPoint: CLLocation?, secondPonit: CLLocation?) ->  String? {
        guard let fPoint = firstPoint, let sPoint = secondPonit else {
            return nil
        }
        
        let distance = fPoint.distance(from: sPoint) / 1000.0
        return String(format: "%.1f", distance)
    }
    
}

