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
    func storeToken(_ token: String)
    func signUp(username: String, password: String)
}

protocol SignUpDataStore {
    
}

typealias SignUpInteraction = SignUpLogic & SignUpDataStore
final class SignUpInteractor: SignUpDataStore {
    private let authService: AuthService!
    private let presenter: SignUpPresentationLogic!
//    private let keyChain: KeychainService!
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(authService: AuthService, presenter: SignUpPresentationLogic) {
        self.authService = authService
        self.presenter = presenter
    }
}

extension SignUpInteractor: SignUpLogic {
    func storeToken(_ token: String) {
        
    }
    
    func signUp(username: String, password: String) {
        authService
            .signUp(email: username, password: password)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                    break
                }
            }, receiveValue: { status in
                switch status {
                case .unknown:
                    assertionFailure("unkown after sign up?")
                    break
                case .unauthenticated:
                    assertionFailure("unauthenticated after sign up?")
                    break
                case .confirmed:
                    break
                case .signedIn:
                    break
                // presenter.presentSignedIn
                default:
                    break
                }
            })
            .store(in: &cancellables)
    }
    
}
