//
//  EventDetailRouter.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

@objc protocol EventDetailRouting {
    func setup(viewController: EventDetailViewController)
    func routeToBuyTicket()
}

protocol EventDetailDataPassing {
    var dataStore: EventDetailDataStore? { get }
    func setup(dataStore: EventDetailDataStore)
}

typealias EventDetailRouterProtocol = NSObject & EventDetailRouting & EventDetailDataPassing
final class EventDetailRouter: EventDetailRouterProtocol {
    weak var viewController: EventDetailViewController?
    var dataStore: EventDetailDataStore?
    
    func setup(viewController: EventDetailViewController) {
        self.viewController = viewController
    }
    
    func setup(dataStore: EventDetailDataStore) {
        self.dataStore = dataStore
    }
    
    func routeToBuyTicket() {
        let container = SceneContainer.shared.container
        let vc = container.resolve(BuyTicketViewController.self)!
        navigateToDestination(source: viewController!, destination: vc)
    }
    
    func presentDestination(source: UIViewController, destination: UIViewController) {
        source.present(destination, animated: true, completion: nil)
    }
    
    func navigateToDestination(source: UIViewController, destination: UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
}
