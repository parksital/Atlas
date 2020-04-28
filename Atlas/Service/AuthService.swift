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

extension AuthService {
    func signUp(email: String, password: String) -> Future<AuthStatus, Error> {
        authClient.signUp(email: email, password: password)
    }
    
    func signIn(email: String, password: String) {
        authClient.signIn(email: email, password: password)
    }
}
