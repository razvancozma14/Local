//
//  AppSchedulers.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwift

class AppSchedulers {
    let main: RxSwift.SchedulerType
    let disk: RxSwift.SchedulerType
    let network: RxSwift.SchedulerType
    let computation: RxSwift.SchedulerType

    init(main: RxSwift.SchedulerType, disk: RxSwift.SchedulerType, network: RxSwift.SchedulerType,
         computation: RxSwift.SchedulerType) {
        self.main = main
        self.disk = disk
        self.network = network
        self.computation = computation
    }
}
