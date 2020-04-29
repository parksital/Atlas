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
    func signUp(email: String, password: String, token: String)
    func handleIncompleteCredentials()
}

protocol SignUpDataStore {
    
}

typealias SignUpInteraction = SignUpLogic & SignUpDataStore
final class SignUpInteractor: SignUpDataStore {
    private let authService: AuthService!
    private let presenter: SignUpPresentationLogic!
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(authService: AuthService, presenter: SignUpPresentationLogic) {
        self.authService = authService
        self.presenter = presenter
    }
    
    deinit { cancellables.forEach { $0.cancel() } }
}

extension SignUpInteractor: SignUpLogic {
    func signUp(email: String, password: String, token: String) {
        authService.signUp(email: email, password: password, token: token)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in  },
                receiveValue: { [presenter] status in
                    if status == .signedIn {
                        presenter?.presentSuccessfulSignUp()
                    }
                }
        ).store(in: &cancellables)
    }
    
    func handleIncompleteCredentials() {
        
    }
}
