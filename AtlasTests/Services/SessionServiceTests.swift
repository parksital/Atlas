//
//  SessionServiceTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 01/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest
import Combine

class SessionServiceTests: XCTestCase {
    private let validUID = "abcxyz"
    var sut: SessionServiceProtocol!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_mobileClientInitialization_error() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(),
            awsMobileClient: StubAuthClient(error: AuthError.generic), keychainManager: StubKeychain()
        )
        
        let status = sut.initialize()
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.error, AuthError.generic)
    }
    
    func test_mobileClientObservation_unknown() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(),
            awsMobileClient: StubAuthClient(value: .unknown, observedValues: [.unknown]),
            keychainManager: StubKeychain()
        )
        
        let status = sut.initialize()
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut])
    }
    
    func test_mobileClientObservation_signIn() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(),
            awsMobileClient: StubAuthClient(value: .unknown, observedValues: [.confirmed, .signedIn]),
            keychainManager: StubKeychain()
        )
        
        let status = sut.observe()
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut, .confirmed, .signedIn])
    }
    
    func test_appleAuthInitialization_invalidUID() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .unknown),
            keychainManager: StubKeychain()
        )
        
        let status = sut.getAppleCredentialState(forUID: "")
        let spy = StateSpy(publisher: status)
        XCTAssertEqual(spy.values, [.notFound])
    }
    
    func test_appleAuthInitialization_validUID() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .unknown),
            keychainManager: StubKeychain()
        )
        
        let status = sut.getAppleCredentialState(forUID: validUID)
        let spy = StateSpy(publisher: status)
        XCTAssertEqual(spy.values, [.authorized])
    }
    
    func test_appleAuthInitialized_mobileClientInitialized_valid() {
        let keychain = StubKeychain()
        
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .signedIn),
            keychainManager: keychain
        )
        
        keychain.setValue(validUID, forKey: "uid")
        let status = sut.initialize()
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedIn])
    }
    
    func test_appleAuthInitialized_invalid_mobileClient_initialized() {
        let keychain = StubKeychain()
        
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .unknown),
            keychainManager: keychain
        )
        
        let status = sut.initialize() //invalid uid
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut])
    }
    
    func test_appleAuthInitialized_valid_mobileClient_initialized_signedOut() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .signedOut),
            keychainManager: StubKeychain()
        )
        
        let status = sut.initialize()
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut])
    }
    
    func test_appleAuth_valid_mobileClient_signedOut_observe_signIn() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .signedOut, observedValues: [.confirmed, .signedIn]),
            keychainManager: StubKeychain()
        )
        
        let status = sut.initialize()
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut])
    }
    
    func test_appleAuth_invalid_mobileClient_signOut() {
        let awsMobileClient = StubAuthClient(value: .signedIn)
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: awsMobileClient,
            keychainManager: StubKeychain()
        )
        
        let status = sut.initialize()
        let spy = StateSpy(publisher: status)
        XCTAssertEqual(spy.values, [.signedOut])
        XCTAssertTrue(awsMobileClient.signOutCalled)
    }
    
    func test_appleAuthRevoked_mobileClient_signOut() {
        let appleAuthService = StubAppleAuthService(validUID: validUID, revoke: true)
        let awsMobileClient = StubAuthClient(value: .signedIn)
        let keychain = StubKeychain()
        sut = SessionService(
            appleAuthService: appleAuthService,
            awsMobileClient: awsMobileClient,
            keychainManager: keychain
        )
        
        keychain.setValue(validUID, forKey: "uid")
        let status = sut.observe()
        let spy = StateSpy(publisher: status)
        
        XCTAssertTrue(awsMobileClient.signOutCalled)
        XCTAssertEqual(awsMobileClient.signOutCalledCount, 1)
        XCTAssertEqual(spy.values, [.signedIn, .signedOut])
    }
}

private extension SessionServiceTests {
    // MARK: - Helpers
    final class StateSpy<T> {
        private (set) var values: [T] = []
        private (set) var error: AuthError?
        private var cancellables = Set<AnyCancellable>()
        
        init(publisher: AnyPublisher<T, AuthError>) {
            publisher
                .sink(
                    receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error): self?.error = error
                        case .finished: break
                        }
                    },
                    receiveValue: { [weak self] value in
                        self?.values.append(value)
                    }
            ).store(in: &cancellables)
        }
    }
}
