//
//  AccountInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 07/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol AccountLogic {
    
}

protocol AccountDataStore {
    
}

typealias AccountInteraction = AccountLogic & AccountDataStore
final class AccountInteractor: AccountDataStore {
    private var presenter: AccountPresentationLogic!
    
    init(presenter: AccountPresentationLogic) {
        self.presenter = presenter
    }
}

extension AccountInteractor: AccountLogic {
    
}
