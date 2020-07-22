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

enum AuthError: Error {
    case generic
    case existingEmail
    case userNotFound
}

extension AuthError: Equatable { }

protocol AuthClientProtocol {
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
            promise(.success(.signedUp))
        }
    }
    
    func signIn(
        email: String,
        password: String
    ) -> Future<AuthStatus, AuthError> {
        return Future<AuthStatus, AuthError> { [unowned self] promise in
            guard self.existingUsers.contains(email) else {
                promise(.failure(.userNotFound))
                return
            }
            
            promise(.success(.signedIn))
        }
    }
}

protocol AuthServiceProtocol {
    func signInWithApple(_ authData: AppleAuthData) -> AnyPublisher<AuthStatus, AuthError>
    
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

final class AuthService: AuthServiceProtocol {
    private let authClient: AuthClientProtocol!
    
    init(authClient: AuthClientProtocol) {
        self.authClient = authClient
    }
    
    func signUp(
        email: String,
        password: String,
        attributes: [String: String]
    ) -> Future<AuthStatus, AuthError> {
        
        authClient.signUp(email: email, password: password, attributes: attributes)
    }
    
    func signIn(
        email: String,
        password: String
    ) -> Future<AuthStatus, AuthError> {
        authClient.signIn(email: email, password: password)
    }
    
    func signInWithApple(_ authData: AppleAuthData) -> AnyPublisher<AuthStatus, AuthError> {
        let password = "password"
        return signUp(email: authData.email, password: password, attributes: authData.attributes)
            .flatMap({ [unowned self] _ in
                self.signIn(email: authData.email, password: password)
            })
            .eraseToAnyPublisher()
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
        _ = sut.signUp(email: "existing.user@domain.com", password: "password", attributes: [:])
        
        let f = sut.signUp(email: "existing.user@domain.com", password: "password", attributes: [:])
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [])
        XCTAssertNotNil(spy.error)
        XCTAssertEqual(spy.error, AuthError.existingEmail)
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
        XCTAssertEqual(spy.error, AuthError.userNotFound)
    }
    
    func testSignIn_success() {
        _ = sut.signUp(email: "existing.user@domain.com", password: "password", attributes: [:])
        
        let f = sut.signIn(email: "existing.user@domain.com", password: "password")
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertNil(spy.error)
        XCTAssertEqual(spy.values, [.signedIn])
    }
    
    func testSignInWithApple_success() {
        let authData = AppleAuthData.fixture()
        let f = sut.signInWithApple(authData)
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertNil(spy.error)
        XCTAssertEqual(spy.values, [.signedIn])
    }
}
