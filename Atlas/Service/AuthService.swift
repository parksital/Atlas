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
    @Keychained(key: "uid") var uid: String?
    @Keychained(key: "email") var email: String?
    @Keychained(key: "password") var password: String?
    @Keychained(key: "token") var token: String?
    
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
}

extension AuthService {
    func initiateSignIn(with authData: AppleAuthData) -> AnyPublisher<AWSAuthState, AuthError> {
        if authData.uid == self.uid,
            let email = _email.wrappedValue,
            let password = _password.wrappedValue {
            return signIn(email: email, password: password)
        } else {
            return signUpWithAppleID(authData)
        }
    }
    
    func signUpWithAppleID(_ authData: AppleAuthData) -> AnyPublisher<AWSAuthState, AuthError> {
        let password = generatePassword()
        return signUp(email: authData.email, password: password, attributes: authData.attributes)
            .filter({ $0 == .confirmed})
            .flatMap({ [weak self] _ in self!.signIn(email: authData.email, password: password) })
            .filter({ $0 == .signedIn })
            .handleEvents(receiveOutput: { [weak self ] _ in
                self?.uid = authData.uid
                self?.email = authData.email
                self?.password = password
            })
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
