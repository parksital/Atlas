//
//  SignUpInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 23/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

protocol SignUpLogic {
    func viewDidFinishLoading()
    func signUpWithAppleID(authData: AppleAuthData)
    func handleCredentialsError()
}

protocol SignUpDataStore {
    
}

typealias SignUpInteraction = SignUpLogic & SignUpDataStore
final class SignUpInteractor: SignUpDataStore {
    private let authService: AuthServiceProtocol!
    private let presenter: SignUpPresentationLogic!
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(authService: AuthServiceProtocol, presenter: SignUpPresentationLogic) {
        self.authService = authService
        self.presenter = presenter
    }
    
    deinit { cancellables.forEach { $0.cancel() } }
}

extension SignUpInteractor: SignUpLogic {
    func viewDidFinishLoading() {
        presenter?.presentView()
    }
    
    func signUpWithAppleID(authData: AppleAuthData) {
        authService.initiateSignUpWithApple(authData)
            .sink(receiveCompletion: { completion in },
                  receiveValue: { [presenter] _ in
                    presenter?.presentSuccessfulSignUp()
            })
            .store(in: &cancellables)
        
        presenter.presentLoadingIndicator()
    }
    
    func handleCredentialsError() {
        
    }
}
