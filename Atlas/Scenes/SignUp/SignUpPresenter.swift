//
//  SignUpPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 23/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

struct SignUpViewModel {
    let mainText: String
    let secondaryText: String
}

protocol SignUpPresentationLogic {
    func setup(viewController: SignUpDisplayLogic)
    func presentLoadingIndicator()
    func presentSuccessfulSignUp()
    func presentView()
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
    
    func presentView() {
        let viewModel = SignUpViewModel(
            mainText: "[Value proposition main text]",
            secondaryText: "[Value proposition secondary text]"
        )
        viewController?.setupWithViewModel(viewModel)
    }
}
