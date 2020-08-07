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
            .inObjectScope(.container)
        container.autoregister(AuthServiceProtocol.self, initializer: AuthService.init)
        container.autoregister(KeychainManagerProtocol.self, initializer: KeychainManager.init)
        container.autoregister(ProfileService.self, initializer: ProfileService.init)
        container.autoregister(EventService.self, initializer: EventService.init)
        container.register(LocalizationService.self) { _ in
            LocalizationService()
        }
            
        
        //MARK: - Eventlist Dependencies
        EventListDI.setDependencies(inContainer: container)
        
        //MARK: - EventDetail Dependencies
        EventDetailDI().setDependencies(inContainer: container)
        
        //MARK: - Buy Ticket Dependencies
        BuyTicketDI.setDependencies(inContainer: container)
        
        //MARK: - Account Depenedencies
        AccountDI().setDependencies(inContainer: container)
        
        //MARK: - My Tickets Depenedencies
        MyTicketsDI().setDependencies(inContainer: container)
        
        //MARK: - Saved Dependencies
        SavedEventsDI().setDependencies(inContainer: container)
        
        //MARK: - Preferences Depenedencies
        PreferencesDI.setDependencies(inContainer: container)
        
        //MARK: - Preferences Depenedencies
        HistoryDI.setDependencies(inContainer: container)
        
        //MARK: - SignUp Dependencies
        SignUpDI().setDependencies(inContainer: container)
    }
    
    func resolveLocalization<C: UIViewController>(
        _ r: Resolver,
        _ vc: C) where C: HasLocalization {
        vc.localizationService = r.resolve(LocalizationService.self)!
    }
}
