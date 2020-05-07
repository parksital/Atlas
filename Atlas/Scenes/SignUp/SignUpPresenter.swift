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
    
    func presentSuccessfulSignUp() {
        viewController?.signUpSuccessful()
    }
    
    func presentView() {
        let viewModel = SignUpViewModel(
            mainText: "For a personalized experience, \nsign into your account.",
            secondaryText: "Lorem ipsum dolor sit amet, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        )
        viewController?.updateWithViewModel(viewModel)
    }
}
