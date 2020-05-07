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
    func presentSignedOutView()
}

final class AccountPresenter {
    private weak var viewController: AccountDisplayLogic?
}

extension AccountPresenter: AccountPresentationLogic {
    func setup(viewController: AccountDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentSignedOutView() {
        viewController?.displaySignedOutView()
    }
}
