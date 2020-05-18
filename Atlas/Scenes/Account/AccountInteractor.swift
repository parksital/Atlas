//
//  AccountInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 07/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol AccountLogic: class {
    func viewDidFinishLoading()
    func goToSignUp()
}

protocol AccountDataStore {
    
}

typealias AccountInteraction = AccountLogic & AccountDataStore
final class AccountInteractor: AccountDataStore {
    private let presenter: AccountPresentationLogic!
    private let sessionService: SessionService!
    
    init(sessionService: SessionService, presenter: AccountPresentationLogic) {
        self.sessionService = sessionService
        self.presenter = presenter
    }
}

extension AccountInteractor: AccountLogic {
    func viewDidFinishLoading() {
        // get user auth status
        
        // present user info
        // OR
        // present unauth view
        presenter.presentSignedOutView()
    }
    
    func goToSignUp() {
        
    }
}
