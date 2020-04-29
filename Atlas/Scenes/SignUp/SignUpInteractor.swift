//
//  SignUpInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 23/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

struct AuthData {
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
    func signUp(signUpData: AuthData)
    func signUp(email: String, password: String, token: String)
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
    func signUp(signUpData: AuthData) {
        let email = signUpData.email
        let firstName = signUpData.firstName
        let lastName = signUpData.lastName
        let token = signUpData.token
        
        let password = ""

        #warning("After successful signup+signin, create a profile in DynamoDB, use a profileservice")
        authService.signUp(email: email, password: "password", token: token)
            .flatMap { [authService] _ in
                authService!.signIn(email: email, password: "password", token: token)
        }
        .first(where: { $0 == .signedIn })
        .sink(
            receiveCompletion: { completion in },
            receiveValue: { _ in print(firstName) }
        )
            .store(in: &cancellables)
    }
    
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
    
    func handleCredentialsError() {
        
    }
}
