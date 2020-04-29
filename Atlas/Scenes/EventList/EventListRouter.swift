//
//  EventListRouter.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

@objc protocol EventListRouting {
    func routeToDetail()
    func routeToAccount()
    func setup(viewController: EventListViewController)
}

protocol EventListDataPassing {
    var dataStore: EventListDataStore? { get }
    func setup(dataStore: EventListDataStore)
}

typealias EventListRouterProtocol = NSObject & EventListRouting & EventListDataPassing
final class EventListRouter: EventListRouterProtocol {
    weak var viewController: EventListViewController?
    var dataStore: EventListDataStore?
    
    func routeToDetail() {
        let container = SceneContainer.shared.container
        let destinationVC = container.resolve(EventDetailViewController.self)!
        var destinationDS = destinationVC.router?.dataStore
        passDataToDestination(source: dataStore!, destination: &destinationDS!)
        navigateToDestination(source: viewController!, destination: destinationVC)
    }
    
    func routeToAccount() {
        let container = SceneContainer.shared.container
        let vc = container.resolve(SignUpViewController.self)!
        
        let destinationVC = UINavigationController(rootViewController: vc)
        destinationVC.modalTransitionStyle = .coverVertical
        destinationVC.modalPresentationStyle = .fullScreen
        presentDestination(source: viewController!, destination: destinationVC)
    }
    
    func passDataToDestination(source: EventListDataStore, destination: inout EventDetailDataStore) {
        DispatchQueue.global(qos: .userInitiated).async { [destination] in
            destination.event = source.selectedEvent
        }
    }
    
    func presentDestination(source: EventListViewController, destination: UIViewController) {
        source.present(destination, animated: true, completion: nil)
    }
    
    func navigateToDestination(source: EventListViewController, destination: UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func setup(viewController: EventListViewController) {
        self.viewController = viewController
    }
    
    func setup(dataStore: EventListDataStore) {
        self.dataStore = dataStore
    }
}
