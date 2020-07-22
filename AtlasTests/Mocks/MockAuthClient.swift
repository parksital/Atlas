//
//  MockAuthClient.swift
//  Atlas
//
//  Created by Parvin Sital on 22/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

class MockAuthClient: AuthClientProtocol {
    private var existingUsers: [String] = []
    
    func signUp(
        email: String,
        password: String,
        attributes: [String: String]
    ) -> Future<AuthStatus, AuthError> {
        return Future<AuthStatus, AuthError> { [unowned self] promise in
            guard !self.existingUsers.contains(email) else {
                promise(.failure(.existingEmail))
                return
            }
            
            self.existingUsers.append(email)
            promise(.success(.confirmed))
        }
    }
    
    func signIn(
        email: String,
        password: String
    ) -> Future<AuthStatus, AuthError> {
        return Future<AuthStatus, AuthError> { [unowned self] promise in
            guard self.existingUsers.contains(email) else {
                promise(.failure(.emailNotFound))
                return
            }
            
            promise(.success(.signedIn))
        }
    }
}
