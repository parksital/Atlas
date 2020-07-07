//
//  StubAuthClient.swift
//  AtlasTests
//
//  Created by Parvin Sital on 06/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

final class StubAuthClient: AuthClientProtocol {
    private (set) var signOutCalled: Bool = false
    private (set) var signOutCalledCount: Int = 0
    private (set) var observeCalledCount: Int = 0
    
    private (set) var result: Result<AWSAuthState, AuthError>
    private var observedValues: [AWSAuthState] = []
    
    init(value: AWSAuthState, observedValues: [AWSAuthState] = []) {
        self.result = .success(value)
        self.observedValues = observedValues
    }
    
    init(error: Error) {
        self.result = .failure(.generic)
    }
    
    func initialize() -> Future<AWSAuthState, AuthError> {
        return Future<AWSAuthState, AuthError>.init { [unowned self] (promise) in
            promise(self.result)
        }
    }
    
    func observe() -> AnyPublisher<AWSAuthState, AuthError> {
        return observedValues
            .publisher
            .setFailureType(to: AuthError.self)
            .eraseToAnyPublisher()
    }
    
    func getCognitoSUB() -> Future<String, AuthError> {
        return Future<String, AuthError>.init { (promise) in
            promise(.success("sub"))
        }
    }
    
    func signUp(email: String, password: String, attributes: [String: String]) -> AnyPublisher<AWSAuthState, AuthError> {
        return Just<AWSAuthState>(.confirmed)
            .setFailureType(to: AuthError.self)
            .eraseToAnyPublisher()
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<AWSAuthState, AuthError> {
        return Just<AWSAuthState>(.confirmed)
            .setFailureType(to: AuthError.self)
            .eraseToAnyPublisher()
    }
    
    func signOut() {
        signOutCalled = true
        signOutCalledCount += 1
    }
}
