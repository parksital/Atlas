//
//  SessionServiceTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 23/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import Combine

protocol SessionServiceProtocol {
    func initializeAuthClient() -> Future<AuthStatus, AuthError>
    func getAppleAuthStatus(forUID uid: String) -> Future<AppleIDCredentialState, Error>
}

struct SessionService: SessionServiceProtocol {
    private let appleAuthService: AppleAuthServiceProtocol!
    private let authClient: AuthClientProtocol!
    
    init(
        appleAuthService: AppleAuthServiceProtocol,
        authClient: AuthClientProtocol
    ) {
        self.appleAuthService = appleAuthService
        self.authClient = authClient
    }
    
    func initializeAuthClient() -> Future<AuthStatus, AuthError> {
        authClient.initialize()
    }
    
    func getAppleAuthStatus(forUID uid: String) -> Future<AppleIDCredentialState, Error> {
        appleAuthService.checkAppleIDCredentials(forUID: uid)
    }
}

class SessionServiceTests: XCTestCase {
    private var sut: SessionServiceProtocol!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialization() {
        sut = makeSUT()
        XCTAssertNotNil(sut)
    }
    
    func testInitialize_appleAuth_notFound() {
        sut = makeSUT()
        let p = sut.getAppleAuthStatus(forUID: "")
        let spy = StateSpy(publisher: p.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.notFound])
    }
    
    func testInitialize_appleAuth_authorized() {
        sut = makeSUT()
        let p = sut.getAppleAuthStatus(forUID: "apple.auth.uid")
        let spy = StateSpy(publisher: p.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.authorized])
    }
    
    func testInitialize_authClient_unknown() {
        sut = makeSUT()
        let p = sut.initializeAuthClient()
        let spy = StateSpy(publisher: p.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.unknown])
    }
    
    func testInitialize_authClient_signedIn() {
        // doesn't matter which e-mail you enter, for now
        let authClient = MockAuthClient(existingUsers: ["david.appleid@domain.com"])
        sut = makeSUT(authClient: authClient)
        
        let p = sut.initializeAuthClient()
        let spy = StateSpy(publisher: p.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.signedIn])
    }
    
    func testDeinit() {
        sut = makeSUT()
        sut = nil
        XCTAssertNil(sut)
    }
}

private extension SessionServiceTests {
    func makeSUT(
        authClient: AuthClientProtocol = MockAuthClient()
    ) -> SessionService {
        let appleAuthService = AppleAuthService(appleIDProvider: MockAppleIDProvider())
        
        return SessionService(
            appleAuthService: appleAuthService,
            authClient: authClient
        )
    }
}
