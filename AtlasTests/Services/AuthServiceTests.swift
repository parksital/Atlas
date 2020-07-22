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
    case emailNotFound
    case uidNotFound
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
                promise(.failure(.emailNotFound))
                return
            }
            
            promise(.success(.signedIn))
        }
    }
}

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

final class AuthService: AuthServiceProtocol {
    private let authClient: AuthClientProtocol!
    private let keychain: KeychainManagerProtocol!
    
    init(authClient: AuthClientProtocol, keychain: KeychainManagerProtocol) {
        self.authClient = authClient
        self.keychain = keychain
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
    
    func initiateSignUpWithApple(_ authData: AppleAuthData) -> AnyPublisher<AuthStatus, AuthError> {
        guard
            let uid = keychain.getValue(forKey: "uid"),
            let password = keychain.getValue(forKey: "password"),
            uid == authData.uid else {
                return signUpWithApple(authData)
        }
        
        return signIn(email: authData.email, password: password)
            .eraseToAnyPublisher()
    }
    
    func signUpWithApple(_ authData: AppleAuthData) -> AnyPublisher<AuthStatus, AuthError> {
        let password = generatePassword()
        
        return signUp(email: authData.email, password: password, attributes: authData.attributes)
            .flatMap({ [unowned self] _ in
                self.signIn(email: authData.email, password: password)
            })
            .handleEvents(receiveOutput: { [keychain] status in
                if status == .signedIn {
                    keychain?.setValue(authData.uid, forKey: "uid")
                    keychain?.setValue(password, forKey: "password")
                }
            })
            .eraseToAnyPublisher()
    }
    
    private func generatePassword() -> String {
        return PasswordGenerator.shared.generatePassword(
            includeNumbers: true,
            includePunctuation: true,
            includeSymbols: false,
            length: 10
        )
    }
}

class AuthServiceTests: XCTestCase {
    private var sut: AuthServiceProtocol!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSignUp_emailAlreadyExists_failure() {
        sut = makeSUT()
        _ = sut.signUp(email: "existing.user@domain.com", password: "password", attributes: [:])
        
        let f = sut.signUp(email: "existing.user@domain.com", password: "password", attributes: [:])
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [])
        XCTAssertNotNil(spy.error)
        XCTAssertEqual(spy.error, AuthError.existingEmail)
    }
    
    func testSignUp_success() {
        sut = makeSUT()
        let f = sut.signUp(email: "new.user@domain.com", password: "password", attributes: [:])
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertNil(spy.error)
        XCTAssertEqual(spy.values, [.signedUp])
    }
    
    func testSignIn_UserDoesNotExists_failure() {
        sut = makeSUT()
        let f = sut.signIn(email: "new.user@domain.com", password: "password")
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [])
        XCTAssertNotNil(spy.error)
        XCTAssertEqual(spy.error, AuthError.emailNotFound)
    }
    
    func testSignIn_success() {
        sut = makeSUT()
        _ = sut.signUp(email: "existing.user@domain.com", password: "password", attributes: [:])
        
        let f = sut.signIn(email: "existing.user@domain.com", password: "password")
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertNil(spy.error)
        XCTAssertEqual(spy.values, [.signedIn])
    }
    
    func testSignIn_afterAppleAuth_success() {
        sut = makeSUT()
        let authData = AppleAuthData.fixture()
        let f = sut.initiateSignUpWithApple(authData)
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertNil(spy.error)
        XCTAssertEqual(spy.values, [.signedIn])
    }
    
    func testSavingUID_afterSignUpWithApple() {
        let keychain = MockKeychain()
        sut = makeSUT(keychain: keychain)
        
        let authData = AppleAuthData.fixture()
        let f = sut.initiateSignUpWithApple(authData)
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        let result = keychain.getValue(forKey: "uid")
        XCTAssertEqual(spy.values, [.signedIn])
        XCTAssertNotNil(result)
        XCTAssertEqual(result, "user.appleid.uid")
    }
    
    func testSavingPassword_afterSignUpWithApple() {
        let keychain = MockKeychain()
        sut = makeSUT(keychain: keychain)
        
        let authData = AppleAuthData.fixture()
        let f = sut.initiateSignUpWithApple(authData)
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        let result = keychain.getValue(forKey: "password")
        XCTAssertEqual(spy.values, [.signedIn])
        XCTAssertNotNil(result)
    }
    
    func testSignIn_afterAppleAuthRevocation_failure() {
        sut = makeSUT()
        _ = sut.signUp(email: "user.appleid@domain.com", password: "password", attributes: [:])
        
        let authData = AppleAuthData.fixture()
        let f = sut.initiateSignUpWithApple(authData)
        
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        XCTAssertNotNil(spy.error)
        XCTAssertEqual(spy.error, AuthError.existingEmail)
    }
    
    func testSignIn_afterAppleAuthRevocation_success() {
        sut = makeSUT()
        let authData = AppleAuthData.fixture()
        
        let p = sut.initiateSignUpWithApple(authData)
        let _ = StateSpy(publisher: p.eraseToAnyPublisher())
        
        let f = sut.initiateSignUpWithApple(authData)
        let fSpy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertNil(fSpy.error)
        XCTAssertEqual(fSpy.values, [.signedIn])
        
    }
}

//MARK: - Helpers
private extension AuthServiceTests {
    func makeSUT(
        authClient: AuthClientProtocol = MockAuthClient(),
        keychain: KeychainManagerProtocol = MockKeychain()
    ) -> AuthService {
        AuthService(
            authClient: authClient,
            keychain: keychain
        )
    }
}

private extension AppleAuthData {
    static func fixture() -> AppleAuthData {
        let formatter = PersonNameComponentsFormatter()
        let components = formatter.personNameComponents(from: "David Jefferson")!
        
        return AppleAuthData(
            uid: "user.appleid.uid",
            email: "user.appleid@domain.com",
            fullName: components,
            token: UUID().uuidString
        )
    }
}

