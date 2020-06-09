//
//  AuthService.swift
//  Atlas
//
//  Created by Parvin Sital on 27/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

final class AuthService {
    private let authClient: AuthClientProtocol!
    
    init(authClient: AuthClientProtocol) {
        self.authClient = authClient
    }
}

private extension AuthService {
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
    
    func storeCognitoSUB(_ sub: String) {
        print("saving sub: ", sub)
        KeychainWrapper.standard.set(sub, forKey: "sub")
    }
}

extension AuthService {
    func signUpWithAppleID(_ authData: AppleAuthData) -> AnyPublisher<AWSAuthState, AuthError> {
        let password = generatePassword()

        return signUp(email: authData.email, password: password, attributes: authData.attributes)
            .filter({ $0 == .confirmed})
            .flatMap({ [weak self] _ in self!.signIn(email: authData.email, password: password) })
            .eraseToAnyPublisher()
    }
    
    func signUp(email: String, password: String, attributes: [String: String]) -> AnyPublisher<AWSAuthState, AuthError> {
        return authClient.signUp(email: email, password: password, attributes: attributes)
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<AWSAuthState, AuthError> {
        return authClient.signIn(email: email, password: password)
    }
    
    func logOut() {
    }
}
