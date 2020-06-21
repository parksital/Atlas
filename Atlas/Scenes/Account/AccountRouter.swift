//
//  AccountRouter.swift
//  Atlas
//
//  Created by Parvin Sital on 07/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

@objc protocol AccountRouting {
    func setup(viewController: AccountViewControllerCV)
    func routeToSignUp()
}

protocol AccountDataPassing {
    var dataStore: AccountDataStore? { get }
    func setup(dataStore: AccountDataStore)
}

typealias AccountRouterProtocol = NSObject & AccountRouting & AccountDataPassing
final class AccountRouter: AccountRouterProtocol {
    weak var viewController: AccountViewControllerCV?
    var dataStore: AccountDataStore?
    
    func setup(dataStore: AccountDataStore) {
        self.dataStore = dataStore
    }
        
    func setup(viewController: AccountViewControllerCV) {
        self.viewController = viewController
    }
    
    func routeToSignUp() {
        let container = SceneContainer.shared.container
        let vc = container.resolve(SignUpViewController.self)!
        let destination = UINavigationController(rootViewController: vc)
        presentDestination(source: viewController!, destination: destination)
    }
    
    
    //MARK: - These functions are used in every router, perhaps make a base router
    func presentDestination(source: UIViewController, destination: UIViewController) {
        source.present(destination, animated: true, completion: nil)
    }
    
    func navigateToDestination(source: UIViewController, destination: UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
}
