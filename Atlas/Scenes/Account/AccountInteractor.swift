//
//  AccountInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 07/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol AccountLogic {
    func viewDidFinishLoading()
}

protocol AccountDataStore {
    
}

typealias AccountInteraction = AccountLogic & AccountDataStore
final class AccountInteractor: AccountDataStore {
    private let presenter: AccountPresentationLogic!
    private let authService: AuthService!
    
    init(authService: AuthService, presenter: AccountPresentationLogic) {
        self.authService = authService
        self.presenter = presenter
    }
}

extension AccountInteractor: AccountLogic {
    func viewDidFinishLoading() {
    }
}
