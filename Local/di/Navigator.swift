//
//  Navigator.swift
//  Local
//
//  Created by Razvan Cozma on 31/08/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import UIKit

protocol NavigatorType {
    func navigateToDetails(locationTitle: String, sourceViewController: UIViewController)
}

struct Navigator: NavigatorType {
    let assembler: Assembler
    
    init(assembler: Assembler) {
        self.assembler = assembler
    }
    
    func navigateToDetails(locationTitle: String, sourceViewController: UIViewController){
        let vc: LocationDetailsViewController = assembler.resolve(name: locationTitle)
        sourceViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
}
