//
//  StubAuthClient.swift
//  AtlasTests
//
//  Created by Parvin Sital on 06/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

final class StubAuthClient {
    private (set) var signOutCalledCount: Int = 0
    private (set) var observeCalledCount: Int = 0
    private (set) var getSubCalledCount: Int = 0
    
    private var sub: String?
    private var result: Result<AWSAuthState, AuthError>
    private var observedValues: [AWSAuthState] = []
    
    init(value: AWSAuthState, observedValues: [AWSAuthState] = [], sub: String? = nil) {
        self.result = .success(value)
        self.observedValues = observedValues
        self.sub = sub
    }
    
    init(error: Error) {
        self.result = .failure(.generic)
    }
}
extension StubAuthClient: AuthClientProtocol {
    
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
        getSubCalledCount += 1
        return Future<String, AuthError>.init { [weak self] (promise) in
            guard let sub = self?.sub else {
                promise(.failure(.attributesError))
                return
            }
            
            promise(.success(sub))
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
        signOutCalledCount += 1
    }
}
