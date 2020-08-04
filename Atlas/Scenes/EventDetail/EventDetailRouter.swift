//
//  EventDetailRouter.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol EventDetailRouting: BaseRouting {
    func setup(viewController: EventDetailViewController)
    func routeToBuyTicket()
}

protocol EventDetailDataPassing {
    var dataStore: EventDetailDataStore? { get }
    func setup(dataStore: EventDetailDataStore)
}

typealias EventDetailRouterProtocol = NSObject
    & EventDetailRouting
    & EventDetailDataPassing

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
}
