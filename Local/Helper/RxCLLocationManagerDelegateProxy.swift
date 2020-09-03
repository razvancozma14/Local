//
//  RxCLLocationManagerDelegateProxy.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import CoreLocation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}


class RxCLLocationManagerDelegateProxy : DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, CLLocationManagerDelegate, DelegateProxyType {
    
    public init(locationManager: CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
    }
    
    internal lazy var didUpdateLocationsSubject = PublishSubject<[CLLocation]>()
    internal lazy var didDetermineStateSubject = PublishSubject<(state: CLRegionState, region: CLRegion)>()
    internal lazy var didFailWithErrorSubject = PublishSubject<Error>()
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _forwardToDelegate?.locationManager?(manager, didUpdateLocations: locations)
        didUpdateLocationsSubject.onNext(locations)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _forwardToDelegate?.locationManager?(manager, didFailWithError: error)
        
        didFailWithErrorSubject.onNext(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        _forwardToDelegate?.locationManager?(manager, didDetermineState: state, for: region)
        didDetermineStateSubject.onNext((state, region))
    }
    
    deinit {
        self.didUpdateLocationsSubject.on(.completed)
        self.didDetermineStateSubject.on(.completed)
        self.didFailWithErrorSubject.on(.completed)
    }
}
