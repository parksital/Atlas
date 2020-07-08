//
//  PreferencesRouter.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

@objc protocol PreferencesRouting {
    func setup(viewController: PreferencesViewController)
    func presentAlert(_ alert: UIAlertController)
}

protocol PreferencesDataPassing {
    var dataStore: PreferencesDataStore? { get }
    func setup(dataStore: PreferencesDataStore)
}

typealias PreferencesRouterProtocol = NSObject & PreferencesRouting & PreferencesDataPassing
final class PreferencesRouter: PreferencesRouterProtocol {
    weak var viewController: PreferencesViewController?
    var dataStore: PreferencesDataStore?
    
    func setup(viewController: PreferencesViewController) {
        self.viewController = viewController
    }
    
    func setup(dataStore: PreferencesDataStore) {
        self.dataStore = dataStore
    }
    
    func presentAlert(_ alert: UIAlertController) {
        presentDestination(source: viewController!, destination: alert)
    }
    
    //MARK: - These functions are used in every router, perhaps make a base router
    func presentDestination(source: UIViewController, destination: UIViewController) {
        source.present(destination, animated: true, completion: nil)
    }
    
    func navigateToDestination(source: UIViewController, destination: UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
}
