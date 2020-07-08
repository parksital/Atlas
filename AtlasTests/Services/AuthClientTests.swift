//
//  SessionServiceTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 01/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import Combine

final class MockAuthClient: AuthClientProtocol {
    func initialize() -> Future<AWSAuthState, AuthError> {
        return Future<AWSAuthState, AuthError>.init { (promise) in
            promise(.success(.confirmed))
        }
    }
    
    func observe() -> PassthroughSubject<AWSAuthState, AuthError> {
        return PassthroughSubject<AWSAuthState, AuthError>()
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
    
    func signOut() { }
}

class SessionServiceTests: XCTestCase {
    var sut: AuthClientProtocol!
    
    override func setUp() {
        super.setUp()
        sut = MockAuthClient()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_initialState_confirmed() {
        sut.initialize()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { value in
                    XCTAssertEqual(value, .confirmed)
            }
        ).cancel()
    }
}
