//
//  BaseRouting.swift
//  Atlas
//
//  Created by Parvin Sital on 04/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol BaseRouting {
    func navigateToDestination(
        source: UIViewController,
        destination: UIViewController
    )
    
    func presentDestination(
        source: UIViewController,
        destination: UIViewController
    )
}

extension BaseRouting {
    func navigateToDestination(
        source: UIViewController,
        destination: UIViewController
    ) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func presentDestination(source: UIViewController, destination: UIViewController) {
        source.present(destination, animated: true, completion: nil)
    }
}
