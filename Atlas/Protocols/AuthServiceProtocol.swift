//
//  AuthServiceProtocol.swift
//  Atlas
//
//  Created by Parvin Sital on 22/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

protocol AuthServiceProtocol {
    func initiateSignUpWithApple(_ authData: AppleAuthData) -> AnyPublisher<AuthStatus, AuthError>
    
    func signUp(
        email: String,
        password: String,
        attributes: [String: String]
    ) -> Future<AuthStatus, AuthError>
    
    func signIn(
        email: String,
        password: String
    ) -> Future<AuthStatus, AuthError>
}
