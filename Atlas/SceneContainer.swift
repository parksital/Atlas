//
//  SharedContainer.swift
//  Atlas
//
//  Created by Parvin Sital on 09/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AuthenticationServices
import Swinject

class SceneContainer {
    static let shared = SceneContainer()
    let container: Container
    
    private init() {
        container = Container(parent: AWSContainer.shared.container)
        
        //MARK: - Services
        container.autoregister(AppleIDProviderProtocol.self, initializer: ASAuthorizationAppleIDProvider.init)
        container.autoregister(AppleAuthServiceProtocol.self, initializer: AppleAuthService.init)
        container.autoregister(SessionServiceProtocol.self, initializer: SessionService.init)
        container.autoregister(AuthServiceProtocol.self, initializer: AuthService.init)
        container.autoregister(KeychainManagerProtocol.self, initializer: KeychainManager.init)
        container.autoregister(ProfileService.self, initializer: ProfileService.init)
        container.autoregister(EventService.self, initializer: EventService.init)
            
        
        //MARK: - Eventlist Dependencies
        EventListDI.setDependencies(inContainer: container)
        
        //MARK: - EventDetail Dependencies
        EventDetailDI.setDependencies(inContainer: container)
        
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
        
        //MARK: - Preferences Depenedencies
        PreferencesDI.setDependencies(inContainer: container)
        
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
