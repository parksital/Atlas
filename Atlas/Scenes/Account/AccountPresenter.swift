//
//  AccountPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 07/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol AccountPresentationLogic {
    func setup(viewController: AccountDisplayLogic)
    func presentUser(_ user: User?)
    func presentSettings(_ settings: [String])
    func goToSignUp()
}

final class AccountPresenter {
    private weak var viewController: AccountDisplayLogic?
}

extension AccountPresenter: AccountPresentationLogic {
    func setup(viewController: AccountDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentUser(_ user: User?) {
        viewController?.displayAccount(for: user)
    }
    
    func presentSettings(_ settings: [String]) {
        viewController?.displaySettings(settings: settings)
    }
    
    func goToSignUp() {
        viewController?.showSignUpView()
    }
}
