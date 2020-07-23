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
    
    func testSignUp_confirmed() {
        sut = makeSUT()
        let f = sut.signUp(email: "new.user@domain.com", password: "password", attributes: [:])
        let spy = StateSpy(publisher: f.eraseToAnyPublisher())
        
        XCTAssertNil(spy.error)
        XCTAssertEqual(spy.values, [.confirmed])
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
        XCTAssertEqual(result, "david.appleid.uid")
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
        _ = sut.signUp(email: "david.appleid@domain.com", password: "password", attributes: [:])
        
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
    
    func testSignUp_statusConfirmed() {
        sut = makeSUT()
        let authData = AppleAuthData.fixture()
        
        let p = sut.initiateSignUpWithApple(authData)
        let spy = StateSpy(publisher: p.eraseToAnyPublisher())
        
        XCTAssertNil(spy.error)
        XCTAssertEqual(spy.values, [.signedIn])
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

extension AppleAuthData {
    static func fixture() -> AppleAuthData {
        let formatter = PersonNameComponentsFormatter()
        let components = formatter.personNameComponents(from: "David Jefferson")!
        
        return AppleAuthData(
            uid: "david.appleid.uid",
            email: "david.appleid@domain.com",
            fullName: components,
            token: UUID().uuidString
        )
    }
}

