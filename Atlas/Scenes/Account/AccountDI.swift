//
//  AccountDI.swift
//  Atlas
//
//  Created by Parvin Sital on 06/08/2020.
//  Copyright (c) 2020 Parvin Sital. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation
import Swinject

class AccountDI: ServiceInjection {
    func setDependencies(inContainer container: Container) {
        container.autoregister(AccountInteraction.self, initializer: AccountInteractor.init)
        container.autoregister(AccountPresentationLogic.self, initializer: AccountPresenter.init)
        container.autoregister(AccountRouterProtocol.self, initializer: AccountRouter.init)
        container.register(AccountViewController.self) { _ in AccountViewController()
        }.initCompleted { r, vc in
            let interactor = r.resolve(AccountInteraction.self)!
            let router = r.resolve(AccountRouterProtocol.self)!
            let presenter = r.resolve(AccountPresentationLogic.self)!
            
            vc.setup(interactor: interactor)
            vc.setup(router: router)
            
            router.setup(viewController: vc)
            router.setup(dataStore: interactor)
            
            presenter.setup(viewController: vc)
        }.initCompleted(resolveLocalization)
    }
}
