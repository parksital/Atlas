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
    private let profileService: ProfileService!
    
    init(profileService: ProfileService, presenter: AccountPresentationLogic) {
        self.profileService = profileService
        self.presenter = presenter
    }
}

private extension AccountInteractor {

}

extension AccountInteractor: AccountLogic {
    func viewDidFinishLoading() {
        profileService.getCurrentUser()
    }
    
    func goToSignUp() {
        presenter.goToSignUp()
    }
}
