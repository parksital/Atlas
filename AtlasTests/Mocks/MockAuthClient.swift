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
    private (set) var signOutCalledCount: Int = 0
    private var existingUsers: [String] = []
    private var observedValues: [AuthStatus] = []
    
    init(
        existingUsers: [String] = [],
        observedValues: [AuthStatus] = []
    ) {
        self.existingUsers = existingUsers
        self.observedValues = observedValues
    }
    
    func initialize() -> Future<AuthStatus, AuthError> {
        return Future<AuthStatus, AuthError> { [unowned self] promise in
            
            guard !self.existingUsers.isEmpty else {
                promise(.success(.unknown))
                return
            }
            
            promise(.success(.signedIn))
        }
    }
    
    func observe() -> AnyPublisher<AuthStatus, AuthError> {
        Timer.publish(every: 0.2, on: .main, in: .common)
            .autoconnect()
            .zip(self.observedValues.publisher)
            .map(\.1)
            .setFailureType(to: AuthError.self)
            .eraseToAnyPublisher()
    }
    
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
    
    func signOut() {
        signOutCalledCount += 1
    }
}
