//
//  AuthService.swift
//  Atlas
//
//  Created by Parvin Sital on 27/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

enum AuthError: Error {
    case generic
    case signUpError
    case unknownAfterSignIn
}

final class AuthService {
    private let authClient: AuthClientProtocol!
    private let keychain: KeychainWrapper!
    
    init(authClient: AuthClientProtocol, keychain: KeychainWrapper) {
        self.authClient = authClient
        self.keychain = keychain
    }
}

private extension AuthService {
    func storeToken(_ token: String) {
        guard keychain.serviceName == "auth" else { return }
        keychain.set(token, forKey: "siwa-token")
    }
    
    func storeAuthData(email: String, password: String) {
        guard keychain.serviceName == "auth" else { return }
        keychain.set(email, forKey: "email")
        keychain.set(password, forKey: "password")
    }
}

extension AuthService {
    func signUp(email: String, password: String, token: String) -> AnyPublisher<AuthStatus, AuthError> {
        return authClient.signUp(email: email, password: password)
            .filter { $0 == .confirmed }
            .flatMap { [unowned self] _ in
                self.signIn(
                    email: email,
                    password: password,
                    token: token)
        }
        .eraseToAnyPublisher()
    }
    
    func signIn(email: String, password: String, token: String) -> AnyPublisher<AuthStatus, AuthError> {
        return authClient.signIn(email: email, password: password)
            .first(where: { $0 == .signedIn })
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.storeToken(token)
                self?.storeAuthData(email: email, password: password)
            })
            .eraseToAnyPublisher()
    }
}
