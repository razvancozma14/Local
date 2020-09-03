//
//  LocalRepository.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwift
import RxSwiftExt
import CoreLocation

class LocalRepository{
    private let localService: LocalService
    private let locationsDbHelper: LocationsDbHelper
    private let schedulers: AppSchedulers
    private let locationService: GeolocationService
    private let eventBus = PublishSubject<LocalRepositoryEvent>()
    private let disposeBag = DisposeBag()
    
    init(localService: LocalService, locationsDbHelper: LocationsDbHelper,
         locationService: GeolocationService, schedulers: AppSchedulers){
        self.localService = localService
        self.locationsDbHelper = locationsDbHelper
        self.locationService = locationService
        self.schedulers = schedulers
    }
    
    public func authorizedLocation() -> Observable<Result> {
        return locationService.authorized.asObservable()
            .do(onNext: {[weak self] (_) in
                self?.eventBus.onNext(NewDataEvent())
            })
            .map{(LocalResult.locationPermission(status: $0))}
    }
    
    func observeLocation(name: String) -> Observable<Result> {
        let locationEvent =  eventBus
            .ofType(ReloadeCurrentLocation.self)
            .startWith(ReloadeCurrentLocation(name: name))
            .observeOn(schedulers.computation)
            .filter {$0.name == name}
            .flatMap { [weak self] event -> Observable<Location> in
                return self?.locationsDbHelper.loadLocationSingle(name: name)
                    .asObservable()
                    .filter { $0 != nil}
                    .map {$0!} ?? Observable.empty()
        }
        .distinctUntilChanged()
        .subscribeOn(schedulers.disk)
        
    
        let userLocation = self.locationService.lastKnownLocation.asObservable()
        .subscribeOn(schedulers.disk).observeOn(schedulers.disk)
        
        return Observable.combineLatest(locationEvent, userLocation) {location, userLocation -> Result in
            return LocalResult.location(locations: location, userLocations: userLocation)
        }
        
        
    }
    
    func observeLocations() -> Observable<Result> {
        let locationsEvent =  eventBus
            .ofType(NewDataEvent.self)
            .startWith(NewDataEvent())
            .observeOn(schedulers.disk)
            .flatMap { [weak self] event -> Observable<[Location]> in
                return self?.locationsDbHelper.loadLocationsSingle()
                    .asObservable()
                    .filter { !$0.isEmpty}
                    .map {$0} ?? Observable.empty()
        }
        .subscribeOn(schedulers.disk)
        
        let userLocation = self.locationService.lastKnownLocation.asObservable().startWith(nil)
            .subscribeOn(schedulers.disk).observeOn(schedulers.disk).distinctUntilChanged()
        
        return Observable.combineLatest(locationsEvent,  userLocation){ locations, userLocation -> Result in
            return LocalResult.locations(locations: locations, userLocations: userLocation)
        }.observeOn(schedulers.disk)
    }
    
    
    func requestLocations() -> Observable<Result>{
        return localService.requestLocations().asObservable()
            .map({ (response) -> [Location] in
                if (response.status ?? "") == ResponseStatus.ok.rawValue {
                    return response.locations ?? []
                }
                throw CoreError.generalError
            })
            .observeOn(schedulers.disk)
            .do(onNext: {[weak self] (locations) in
                self?.locationsDbHelper.updateOrdInserLocations(locations: locations)
                self?.eventBus.onNext(NewDataEvent())
                
            })
            .map{_ in LocalResult.success}
            .catchError { (error) -> Observable<Result> in
                return .just(LocalResult.error(error: error))
        }
    }
    
    func updateLocationAddress(name: String, newAddress: String){
        Observable.just(locationsDbHelper.updateLocationAddress(name: name, address: newAddress))
            .subscribeOn(schedulers.disk)
            .do(onNext: { [weak self](_) in
                self?.eventBus.onNext(ReloadeCurrentLocation(name: name))
                self?.eventBus.onNext(NewDataEvent())
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
}
