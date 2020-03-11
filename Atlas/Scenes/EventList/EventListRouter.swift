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
}

protocol EventListDataPassing {
    var dataStore: EventListDataStore? { get }
}

final class EventListRouter: NSObject, EventListRouting, EventListDataPassing {
    
    weak var viewController: EventListViewController?
    var dataStore: EventListDataStore?

    
    func routeToDetail() {
        let destinationVC = EventDetailViewController()
        var destinationDS = destinationVC.router?.dataStore
        passDataToDestination(source: dataStore!, destination: &destinationDS!)
        navigateToDestination(source: viewController!, destination: destinationVC)
    }

    func passDataToDestination(source: EventListDataStore, destination: inout EventDetailDataStore) {
        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
        destination.eventID = source.events[selectedRow!].id
    }
    
    func navigateToDestination(source: EventListViewController, destination: UIViewController) {
        DispatchQueue.main.async {
            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
}
