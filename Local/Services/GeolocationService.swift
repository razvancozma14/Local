//
//  GeolocationService.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import CoreLocation
import UserNotifications
import UIKit
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

public class GeolocationService {
    private (set) public var authorized: Driver<CLAuthorizationStatus>
    private (set) public var location: Observable<CLLocation>
    
    public let lastKnownLocation: BehaviorRelay<CLLocation?> = BehaviorRelay<CLLocation?>(value: nil)
    
    
    private let locationManager = CLLocationManager()
    
    private let disposeBag = DisposeBag()
    
    
    init(schedulers: AppSchedulers) {
        authorized = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx.didChangeAuthorizationStatus
                .startWith(status)
        }
        .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
        
        
        
        location = locationManager.rx.didUpdateLocations.filter {
            !$0.isEmpty
        }
        .flatMap { locations -> Observable<CLLocation> in
                print("start update loc size \(locations.count)")
                return locations.last.map(Observable.just) ?? Observable.empty()
        }
            
        
        location.asObservable()
            .observeOn(schedulers.disk)
            .do(onNext: {[unowned self] (location) in
                self.lastKnownLocation.accept(location)
            })
            .subscribeOn(schedulers.disk)
            .subscribe()
            .disposed(by: disposeBag)
        

        
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.distanceFilter = 50.0
    }
    
   
}
