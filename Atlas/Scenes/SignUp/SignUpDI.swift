//
//  SignUpDI.swift
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

class SignUpDI: ServiceInjection {
    func setDependencies(inContainer container: Container) {
        container.autoregister(SignUpInteraction.self, initializer: SignUpInteractor.init)
        container.autoregister(SignUpPresentationLogic.self, initializer: SignUpPresenter.init)
        container.autoregister(SignUpRouterProtocol.self, initializer: SignUpRouter.init)
        container.register(SignUpViewController.self) { r  in
            SignUpViewController()
        }.initCompleted { r, vc in
            let interactor = r.resolve(SignUpInteraction.self)!
            let router = r.resolve(SignUpRouterProtocol.self)!
            let presenter = r.resolve(SignUpPresentationLogic.self)!
            
            vc.setup(interactor: interactor)
            vc.setup(router: router)
            
            router.setup(dataStore: interactor)
            router.setup(viewController: vc)
            
            presenter.setup(viewController: vc)
        }.initCompleted(resolveLocalization)
    }
}