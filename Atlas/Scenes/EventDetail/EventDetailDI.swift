//
//  EventDetailDI.swift
//  Atlas
//
//  Created by Parvin Sital on 20/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Swinject

class EventDetailDI {
    static func setDependencies(inContainer container: Container) {
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
