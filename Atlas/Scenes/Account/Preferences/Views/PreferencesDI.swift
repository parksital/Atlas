//
//  PreferencesDI.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Swinject

class PreferencesDI: ServiceInjection {
    func setDependencies(inContainer container: Container) {
        container.autoregister(PreferencesInteraction.self, initializer: PreferencesInteractor.init)
        container.autoregister(PreferencesPresentationLogic.self, initializer: PreferencesPresenter.init)
        container.autoregister(PreferencesRouterProtocol.self, initializer: PreferencesRouter.init)
        container.register(PreferencesViewController.self) { r in
            PreferencesViewController()
        }.initCompleted { r, vc in
            let interactor = r.resolve(PreferencesInteraction.self)!
            let router = r.resolve(PreferencesRouterProtocol.self)!
            let presenter = r.resolve(PreferencesPresentationLogic.self)!
            
            vc.setup(interactor: interactor)
            vc.setup(router: router)

            
            router.setup(dataStore: interactor)
            router.setup(viewController: vc)
            
            presenter.setup(viewController: vc)
        }.initCompleted(resolveLocalization)
    }
}
