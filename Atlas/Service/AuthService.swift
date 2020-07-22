//
//  AuthService.swift
//  Atlas
//
//  Created by Parvin Sital on 22/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

final class AuthService: AuthServiceProtocol {
    private let authClient: AuthClientProtocol!
    private let keychain: KeychainManagerProtocol!
    
    init(authClient: AuthClientProtocol, keychain: KeychainManagerProtocol) {
        self.authClient = authClient
        self.keychain = keychain
    }
    
    func signUp(
        email: String,
        password: String,
        attributes: [String: String]
    ) -> Future<AuthStatus, AuthError> {
        
        authClient.signUp(email: email, password: password, attributes: attributes)
    }
    
    func signIn(
        email: String,
        password: String
    ) -> Future<AuthStatus, AuthError> {
        authClient.signIn(email: email, password: password)
    }
    
    func initiateSignUpWithApple(_ authData: AppleAuthData) -> AnyPublisher<AuthStatus, AuthError> {
        guard
            let uid = keychain.getValue(forKey: "uid"),
            let password = keychain.getValue(forKey: "password"),
            uid == authData.uid else {
                return signUpWithApple(authData)
        }
        
        return signIn(email: authData.email, password: password)
            .eraseToAnyPublisher()
    }
    
    func signUpWithApple(_ authData: AppleAuthData) -> AnyPublisher<AuthStatus, AuthError> {
        let password = generatePassword()
        
        return signUp(email: authData.email, password: password, attributes: authData.attributes)
            .filter({ $0 == .confirmed })
            .flatMap({ [unowned self] _ in
                self.signIn(email: authData.email, password: password)
            })
            .handleEvents(receiveOutput: { [keychain] status in
                if status == .signedIn {
                    keychain?.setValue(authData.uid, forKey: "uid")
                    keychain?.setValue(password, forKey: "password")
                }
            })
            .eraseToAnyPublisher()
    }
    
    private func generatePassword() -> String {
        return PasswordGenerator.shared.generatePassword(
            includeNumbers: true,
            includePunctuation: true,
            includeSymbols: false,
            length: 10
        )
    }
}
