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
    func presentSignUpView()
    func presentAccountView(forUser user: String)
    func presentSignedOutView()
}

final class AccountPresenter {
    private weak var viewController: AccountDisplayLogic?
}

extension AccountPresenter: AccountPresentationLogic {
    func setup(viewController: AccountDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentSignUpView() {
        viewController?.showSignUpView()
    }
    
    func presentAccountView(forUser user: String) {
        viewController?.displayAccount(viewModel: user)
    }
    
    func presentSignedOutView() {
        viewController?.displaySignedOutView()
    }
}
