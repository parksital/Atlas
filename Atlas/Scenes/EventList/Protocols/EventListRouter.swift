//
//  EventListRouter.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

@objc protocol EventListRouting {
    func routeToDetail(eventID: String)
}

protocol EventListDataPassing {
    var dataStore: EventListDataStore? { get }
}

final class EventListRouter: NSObject, EventListRouting, EventListDataPassing {
    
    weak var viewController: EventListViewController?
    var dataStore: EventListDataStore?

    
    func routeToDetail(eventID: String) {
    }
     
//    func passDataToChild(source: EventListDataStore, destination: inout ChildDataStore) {
//        destination.name = source.events
//    }
//
//    func navigateToChild(source: EventListViewController, destination: UIViewController) {
//        source.navigationController?.pushViewController(destination, animated: true)
//    }
}
