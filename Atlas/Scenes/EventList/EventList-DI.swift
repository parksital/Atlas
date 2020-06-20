//
//  EventList-DI.swift
//  Atlas
//
//  Created by Parvin Sital on 20/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Swinject

class EventListDI {
    static func setDependencies(inContaiener container: Container) {
        container.autoregister(EventListInteraction.self, initializer: EventListInteractor.init)
        container.autoregister(EventListPresentationLogic.self, initializer: EventListPresenter.init)
        container.autoregister(EventListRouterProtocol.self, initializer: EventListRouter.init)
        
        container.register(EventListViewController.self) { r in
            EventListViewController()
        }.initCompleted { r, vc in
            let interactor = r.resolve(EventListInteraction.self)!
            let router = r.resolve(EventListRouterProtocol.self)!
            let presenter = r.resolve(EventListPresentationLogic.self)!
            
            vc.setup(interactor: interactor)
            vc.setup(router: router)
            
            router.setup(dataStore: interactor)
            router.setup(viewController: vc)
            
            presenter.setup(viewController: vc)
        }
    }
}
