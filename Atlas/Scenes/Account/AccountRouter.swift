//
//  AccountRouter.swift
//  Atlas
//
//  Created by Parvin Sital on 07/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

@objc protocol AccountRouting {
    func setup(viewController: AccountViewController)
    func routeToSignUp()
    func routeToSelectedSetting()
}

protocol AccountDataPassing {
    var dataStore: AccountDataStore? { get }
    func setup(dataStore: AccountDataStore)
}

typealias AccountRouterProtocol = NSObject & AccountRouting & AccountDataPassing
final class AccountRouter: AccountRouterProtocol {
    weak var viewController: AccountViewController?
    var dataStore: AccountDataStore?
    
    func setup(dataStore: AccountDataStore) {
        self.dataStore = dataStore
    }
        
    func setup(viewController: AccountViewController) {
        self.viewController = viewController
    }
    
    func routeToSignUp() {
        let container = SceneContainer.shared.container
        let vc = container.resolve(SignUpViewController.self)!
        let destination = UINavigationController(rootViewController: vc)
        presentDestination(source: viewController!, destination: destination)
    }
    
    func routeToSelectedSetting() {
        guard let selection = dataStore?.selectedSetting else { return }
        
        let container = SceneContainer.shared.container
        var destination: UIViewController!
        
        switch selection {
        case .myTickets:
            destination = container
                .resolve(MyTicketsViewController.self)!
        case .savedEvents:
            destination = container
                .resolve(SavedEventsViewController.self)!
        case .history:
            destination = UIViewController()
            destination.view.backgroundColor = .systemTeal
        case .preferences:
            destination = container.resolve(PreferencesViewController.self)!
        }
        
        navigateToDestination(source: viewController!, destination: destination)
    }
    
    
    //MARK: - These functions are used in every router, perhaps make a base router
    func presentDestination(source: UIViewController, destination: UIViewController) {
        source.present(destination, animated: true, completion: nil)
    }
    
    func navigateToDestination(source: UIViewController, destination: UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
}
