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
}

final class AuthService {
    private let authClient: AuthClientProtocol!
    
    init(authClient: AuthClientProtocol) {
        self.authClient = authClient
    }
}

extension AuthService {
    func initialize() {
        authClient.initialize()
    }
    
    func generatePassword() -> String {
        PasswordGenerator.shared.generatePassword(
            includeNumbers: true,
            includePunctuation: true,
            includeSymbols: false,
            length: 10
        )
    }
    
    func storeAppleAuthData(_ authData: AppleAuthData) {
        KeychainWrapper.standard.set(authData.token, forKey: "token")
        KeychainWrapper.standard.set(authData.uid, forKey: "uid")
        KeychainWrapper.standard.set(authData.email, forKey: "email")
    }
    
    func storePassword(_ password: String) {
        KeychainWrapper.standard.set(password, forKey: "password")
    }
    
    func signUpWithAppleID(_ authData: AppleAuthData) -> AnyPublisher<AuthStatus, AuthError> {
        let password = generatePassword()
        return self.signUp(email: authData.email, password: password)
            .first(where: { $0 == .confirmed })
            .flatMap({ _ in
                return self.signIn(email: authData.email, password: password)
            })
            .first(where: { $0 == .signedIn })
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self = self else {
                    assertionFailure()
                    return
                }
                self.storeAppleAuthData(authData)
                self.storePassword(password)
            })
            .eraseToAnyPublisher()
    }
    
    func signUp(email: String, password: String) -> AnyPublisher<AuthStatus, AuthError> {
        return authClient.signUp(email: email, password: password)
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<AuthStatus, AuthError> {
        return authClient.signIn(email: email, password: password)
    }
    
    func logOut() {
        authClient.logOut()
    }
}
