//
//  SignUpInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 23/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

struct AppleAuthData {
    let uid: String
    let email: String
    let fullName: PersonNameComponents
    let token: String
    
    var firstName: String {
        fullName.givenName!
    }
    
    var lastName: String {
        fullName.familyName!
    }
}

protocol SignUpLogic {
    func signUpWithAppleID(authData: AppleAuthData)
    func handleCredentialsError()
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
    func signUpWithAppleID(authData: AppleAuthData) {
        authService.signUpWithAppleID(authData)
            .sink(receiveCompletion: { _ in },
                receiveValue: { [presenter] _ in
                    presenter?.presentSuccessfulSignUp()
            })
            .store(in: &cancellables)
    }
    
    func handleCredentialsError() {
        
    }
}
