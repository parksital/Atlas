//
//  SignUpPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 23/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol SignUpPresentationLogic {
    func setup(viewController: SignUpDisplayLogic)
    func presentLoadingIndicator()
    func presentSuccessfulSignUp()
}

final class SignUpPresenter {
    private weak var viewController: SignUpDisplayLogic?
}

extension SignUpPresenter: SignUpPresentationLogic {
    func setup(viewController: SignUpDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentLoadingIndicator() {
        viewController?.displayActivityIndicator()
    }
    
    func presentSuccessfulSignUp() {
        viewController?.signUpSuccessful()
    }
}
