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
        let destinationVC = EventDetailViewController()
        var destinationDS = destinationVC.router?.dataStore
        passDataToDestination(source: dataStore!, destination: &destinationDS!)
        navigateToDestination(source: viewController!, destination: destinationVC)
    }

    func passDataToDestination(source: EventListDataStore, destination: inout EventDetailDataStore) {
        DispatchQueue.global(qos: .userInitiated).async { [destination] in
            destination.event = source.selectedEvent
        }
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
