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
    var status: CurrentValueSubject<AuthStatus, AuthError> { get }
    
    func initialize(uid: String)
    func initializeAuthClient() -> Future<AuthStatus, AuthError>
    func getAppleAuthStatus(forUID uid: String) -> AnyPublisher<AppleIDCredentialState, AuthError>
}

class SessionService: SessionServiceProtocol {
    private let appleAuthService: AppleAuthServiceProtocol!
    private let authClient: AuthClientProtocol!
    private (set) var status =  CurrentValueSubject<AuthStatus, AuthError>(.unknown)
    private var cancellables = Set<AnyCancellable>()
    
    init(
        appleAuthService: AppleAuthServiceProtocol,
        authClient: AuthClientProtocol
    ) {
        self.appleAuthService = appleAuthService
        self.authClient = authClient
    }
    
    func initialize(uid: String) {
        getAppleAuthStatus(forUID: uid)
            .map({ $0 == .authorized})
            .zip(initializeAuthClient())
            .sink(receiveCompletion: { _ in},
                  receiveValue: { [unowned self] (authorized, authStatus) in
                    if authorized {
                        if authStatus == .signedIn {
                            self.status.send(.signedIn)
                        }
                    } else {
                        self.authClient.signOut()
                    }
            })
            .store(in: &cancellables)
    }
    
    func initializeAuthClient() -> Future<AuthStatus, AuthError> {
        authClient.initialize()
    }
    
    func getAppleAuthStatus(forUID uid: String) -> AnyPublisher<AppleIDCredentialState, AuthError> {
        appleAuthService
            .checkAppleIDCredentials(forUID: uid)
            .mapError({ AuthError.appleIDError(underlyingError: $0) })
            .eraseToAnyPublisher()
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
    
    func testDeinit() {
        sut = makeSUT()
        sut = nil
        XCTAssertNil(sut)
    }
    
    func testInitialize_appleAuth_notFound() {
        sut = makeSUT()
        let p = sut.getAppleAuthStatus(forUID: "")
        let spy = StateSpy(publisher: p.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.notFound])
    }
    
    func testInitialize_appleAuth_authorized() {
        sut = makeSUT()
        let p = sut.getAppleAuthStatus(forUID: "david.appleid.uid")
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
    
    func testStatus_initial_unknown() {
        sut = makeSUT()
        let s = sut.status
        let spy = StateSpy(publisher: s.eraseToAnyPublisher())
        
        XCTAssertEqual(spy.values, [.unknown])
    }
    
    func testInit_appleAuthNotFound_clientUnknown() {
        sut = makeSUT()
        
        let p = sut.status.eraseToAnyPublisher()
        let spy = StateSpy(publisher: p)
        
        sut.initialize(uid: "")
        
        XCTAssertEqual(sut.status.value, .unknown)
        XCTAssertEqual(spy.values, [.unknown])
    }
    
    func testInit_afterAppleAuth_clientSignedIn() {
        let authClient = MockAuthClient(existingUsers: ["david.appleid@domain.com"])
        sut = makeSUT(authClient: authClient)
        
        let p = sut.status.eraseToAnyPublisher()
        let spy = StateSpy(publisher: p)
        
        sut.initialize(uid: "david.appleid.uid")
        XCTAssertEqual(spy.values, [.unknown, .signedIn])
        XCTAssertEqual(sut.status.value, .signedIn)
    }
    
    func testInit_afterAppleAuth_notFound() {
        sut = makeSUT()
        
        let p = sut.status.eraseToAnyPublisher()
        let spy = StateSpy(publisher: p)
        
        sut.initialize(uid: "")
        
        XCTAssertEqual(spy.values, [.unknown,])
        XCTAssertEqual(sut.status.value, .unknown)
    }
    
    func testInit_appleAuth_revoked_clientSignedIn() {
        let authClient = MockAuthClient(existingUsers: ["david.appleid@domain.com"])
        sut = makeSUT(authClient: authClient)
        
        let p = sut.status.eraseToAnyPublisher()
        let spy = StateSpy(publisher: p)
        
        sut.initialize(uid: "")
        
        XCTAssertEqual(authClient.signOutCalledCount, 1)
        XCTAssertEqual(spy.values, [.unknown])
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
