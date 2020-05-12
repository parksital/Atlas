//
//  SharedContainer.swift
//  Atlas
//
//  Created by Parvin Sital on 09/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Swinject

class SceneContainer {
    static let shared = SceneContainer()
    let container: Container
    
    private init() {
        container = Container(parent: AWSContainer.shared.container)
        
        //MARK: - Services
        container.autoregister(EventService.self, initializer: EventService.init)
        container.autoregister(SessionService.self, initializer: SessionService.init)
        container.autoregister(AuthService.self, initializer: AuthService.init)
            .inObjectScope(.weak)
        
        //MARK: - Eventlist Dependencies
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
        
        //MARK: - Account Depenedencies
        container.autoregister(AccountInteraction.self, initializer: AccountInteractor.init)
        container.autoregister(AccountPresentationLogic.self, initializer: AccountPresenter.init)
        container.autoregister(AccountRouterProtocol.self, initializer: AccountRouter.init)
        container.register(AccountViewController.self) { _ in AccountViewController() }
            .initCompleted { r, vc in
                let interactor = r.resolve(AccountInteraction.self)!
                let router = r.resolve(AccountRouterProtocol.self)!
                let presenter = r.resolve(AccountPresentationLogic.self)!
                
                vc.setup(interactor: interactor)
                vc.setup(router: router)
                
                router.setup(viewController: vc)
                router.setup(dataStore: interactor)
                
                presenter.setup(viewController: vc)
        }
        
        //MARK: - SignUp Dependencies
        container.autoregister(SignUpInteraction.self, initializer: SignUpInteractor.init)
        container.autoregister(SignUpPresentationLogic.self, initializer: SignUpPresenter.init)
        container.autoregister(SignUpRouterProtocol.self, initializer: SignUpRouter.init)
        container.register(SignUpViewController.self) { r  in
            SignUpViewController()
        }.initCompleted { r, vc in
            let interactor = r.resolve(SignUpInteraction.self)!
            let router = r.resolve(SignUpRouterProtocol.self)!
            let presenter = r.resolve(SignUpPresentationLogic.self)!
            
            vc.setup(router: router)
            vc.setup(interactor: interactor)
            
            router.setup(dataStore: interactor)
            router.setup(viewController: vc)
            
            presenter.setup(viewController: vc)
        }
    }
}
