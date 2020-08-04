//
//  SavedEventsDI.swift
//  Atlas
//
//  Created by Parvin Sital on 27/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Swinject

class SavedEventsDI {
    static func setDependencies(inContainer container: Container) {
        container.autoregister(SavedEventsInteraction.self, initializer: SavedEventsInteractor.init)
        container.autoregister(SavedEventsPresentationLogic.self, initializer: SavedEventsPresenter.init)
        container.autoregister(SavedEventsRoutingProtocol.self, initializer: SavedEventsRouter.init)
        container.register(SavedEventsViewController.self) { r in
            SavedEventsViewController()
        }.initCompleted { r, vc in
            let interactor = r.resolve(SavedEventsInteraction.self)!
            let router = r.resolve(SavedEventsRoutingProtocol.self)!
            let presenter = r.resolve(SavedEventsPresentationLogic.self)!
            
            vc.setup(interactor: interactor)
            vc.setup(router: router)

            
            router.setup(dataStore: interactor)
            router.setup(viewController: vc)
            
            presenter.setup(viewController: vc)
        }
    }
}
