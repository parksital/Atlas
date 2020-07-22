//
//  AuthServiceTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 22/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import AWSMobileClient
import Combine

enum AuthStatus {
    case signedUp
    case signedIn
}

enum SignInError: Error {
    case userNotFound
}

enum SignUpError: Error {
    case generic
    case existingEmail
}

extension SignUpError: Equatable { }

protocol AuthClientProtocol {
    func signUp(
        email: String,
        password: String,
        attributes: [String: String]
    ) -> Future<AuthStatus, SignUpError>
    
    func signIn(
        email: String,
        password: String
    ) -> Future<AuthStatus, SignInError>
}

class MockAuthClient: AuthClientProtocol {
    private let existingUsers = ["existing.user@domain.com"]
    
    func signUp(
        email: String,
        password: String,
        attributes: [String: String]
    ) -> Future<AuthStatus, SignUpError> {
        return Future<AuthStatus, SignUpError> { [unowned self] promise in
            guard !self.existingUsers.contains(email) else {
                promise(.failure(.existingEmail))
                return
            }
            
            promise(.success(.signedUp))
        }
    }
    
    func signIn(
        email: String,
        password: String
    ) -> Future<AuthStatus, SignInError> {
        return Future<AuthStatus, SignInError> { [unowned self] promise in
            guard self.existingUsers.contains(email) else {
                promise(.failure(.userNotFound))
                return
            }
            
            promise(.success(.signedIn))
        }
    }
}

protocol AuthServiceProtocol {
    func signUp(
        email: String,
        password: String,
        attributes: [String: String]
    ) -> Future<AuthStatus, SignUpError>
    
    func signIn(
        email: String,
        password: String
    ) -> Future<AuthStatus, SignInError>
}

final class AuthService: AuthServiceProtocol {
    private let authClient: AuthClientProtocol!
    
    init(authClient: AuthClientProtocol) {
        self.authClient = authClient
    }
    
    func signUp(
        email: String,
        password: String,
        attributes: [String: String]
    ) -> Future<AuthStatus, SignUpError> {
        
        authClient.signUp(email: email, password: password, attributes: attributes)
    }
    
    func signIn(
        email: String,
        password: String
    ) -> Future<AuthStatus, SignInError> {
        authClient.signIn(email: email, password: password)
    }
}

class AuthServiceTests: XCTestCase {
    private var sut: AuthServiceProtocol!
    
    override func setUp() {
        super.setUp()
        sut = AuthService(authClient: MockAuthClient())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSignUp_emailAlreadyExists_failure() {
        let f = sut.signUp(email: "existing.user@domain.com", password: "password", attributes: [:])
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [])
        XCTAssertNotNil(spy.error)
        XCTAssertEqual(spy.error, SignUpError.existingEmail)
    }
    
    func testSignUp_success() {
        let f = sut.signUp(email: "new.user@domain.com", password: "password", attributes: [:])
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertNil(spy.error)
        XCTAssertEqual(spy.values, [.signedUp])
    }
    
    func testSignIn_UserDoesNotExists_failure() {
        let f = sut.signIn(email: "new.user@domain.com", password: "password")
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [])
        XCTAssertNotNil(spy.error)
        XCTAssertEqual(spy.error, SignInError.userNotFound)
    }
    
    func testSignIn_success() {
        let f = sut.signIn(email: "existing.user@domain.com", password: "password")
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertNil(spy.error)
        XCTAssertEqual(spy.values, [.signedIn])
    }
}
