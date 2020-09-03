//
//  LocalService.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwift
import Moya

class LocalService{
    
    private let appSchedulers: AppSchedulers
    private let decoder = JSONDecoder()
    private let endpoint: MoyaProvider<LocalApi>
    
    
    init(appSchedulers: AppSchedulers){
        self.appSchedulers = appSchedulers
        
        let localServiceEndpointClosure = {
            (target: LocalApi) -> Endpoint in
            let apiUrl = URL(string: Constants.NetworkAPI.localEndpoint)!
            let url = apiUrl.appendingPathComponent(target.path).absoluteString
            return Endpoint(url: url, sampleResponseClosure: { .networkResponse(200, target.sampleData) }, method: target.method, task: target.task, httpHeaderFields: target.headers);
        }
        
        let networkPlugins: [PluginType] = [NetworkLoggerPlugin(configuration:
            NetworkLoggerPlugin.Configuration(
                formatter: NetworkLoggerPlugin.Configuration.Formatter(responseData: JSONResponseDataFormatter),
                logOptions: NetworkLoggerPlugin.Configuration.LogOptions.formatRequestAscURL))]
        
        self.endpoint = MoyaProvider<LocalApi>(endpointClosure: localServiceEndpointClosure, plugins: networkPlugins)
    }
    
    func requestLocations() -> Single<MyLocationsRespons>{
        let jsonDecoder = decoder
        return endpoint.rx.request(.mylocations)
            .subscribeOn(appSchedulers.network)
            .observeOn(appSchedulers.computation)
            .catchError({ (error) -> PrimitiveSequence<SingleTrait, Response> in
                throw CoreError.network(statusCode: -1)
            })
            .map { (response) -> MyLocationsRespons in
                guard response.statusCode == 200 && !response.data.isEmpty else {
                    throw CoreError.network(statusCode: response.statusCode)
                }
                do {
                    return try jsonDecoder.decode(MyLocationsRespons.self, from: response.data)
                } catch (let error) {
                    throw CoreError.decodingResponse(error: error)
                }
        }
    }
  
}
