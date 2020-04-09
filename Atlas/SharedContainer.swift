//
//  SharedContainer.swift
//  Atlas
//
//  Created by Parvin Sital on 09/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Swinject

class SharedContainer {
    static let shared = SharedContainer()
    let container: Container
    
    private init() {
        container = Container(parent: AWSContainer.shared.container)
        
        //MARK: - Eventlist Dependencies
        container.autoregister(EventService.self, initializer: EventService.init)
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
        
        //MARK: - EventDetail Dependencies
        container.autoregister(EventDetailInteraction.self, initializer: EventDetailInteractor.init)
        container.autoregister(EventDetailPresentationLogic.self, initializer: EventDetailPresenter.init)
        container.autoregister(EventDetailRouterProtocol.self, initializer: EventDetailRouter.init)
        container.register(EventDetailViewController.self) { r in
            EventDetailViewController()
        }.initCompleted { r, vc in
            let interactor = r.resolve(EventDetailInteraction.self)!
            let router = r.resolve(EventDetailRouterProtocol.self)!
            let presenter = r.resolve(EventDetailPresentationLogic.self)!
            
            vc.setup(interactor: interactor)
            vc.setup(router: router)

            
            router.setup(dataStore: interactor)
            router.setup(viewController: vc)
            
            presenter.setup(viewController: vc)
        }

    }
}
