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
            awsMobileClient: StubAuthClient(error: AuthError.generic), keychainManager: MockKeychain()
        )
        
        let status = sut.initialize()
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.error, AuthError.generic)
    }
    
    func test_mobileClientObservation_unknown() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(),
            awsMobileClient: StubAuthClient(value: .unknown, observedValues: [.unknown]),
            keychainManager: MockKeychain()
        )
        
        let status = sut.initialize()
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut])
    }
    
    func test_appleAuthInitialization_invalidUID() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .unknown),
            keychainManager: MockKeychain()
        )
        
        let status = sut.getAppleCredentialState(forUID: "")
        let spy = StateSpy(publisher: status)
        XCTAssertEqual(spy.values, [.notFound])
    }
    
    func test_appleAuthInitialization_validUID() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .unknown),
            keychainManager: MockKeychain()
        )
        
        let status = sut.getAppleCredentialState(forUID: validUID)
        let spy = StateSpy(publisher: status)
        XCTAssertEqual(spy.values, [.authorized])
    }
    
    func test_appleAuthInitialized_mobileClientInitialized_valid() {
        let keychain = MockKeychain()
        
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
        let keychain = MockKeychain()
        
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
            keychainManager: MockKeychain()
        )
        
        let status = sut.initialize()
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut])
    }
    
    func test_appleAuth_valid_mobileClient_signedOut_observe_signIn() {
        sut = SessionService(
            appleAuthService: StubAppleAuthService(validUID: validUID),
            awsMobileClient: StubAuthClient(value: .signedOut, observedValues: [.confirmed, .signedIn]),
            keychainManager: MockKeychain()
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
            keychainManager: MockKeychain()
        )
        
        let status = sut.observe()
        let spy = StateSpy(publisher: status)
        XCTAssertEqual(spy.values, [.signedOut])
        XCTAssertEqual(awsMobileClient.signOutCalledCount, 1)
    }
    
    func test_appleAuthRevoked_mobileClient_signOut() {
        let appleAuthService = StubAppleAuthService(validUID: "invalid", revoke: true)
        let awsMobileClient = StubAuthClient(value: .signedIn)
        let keychain = MockKeychain()
        keychain.setValue(validUID, forKey: "uid")
        
        sut = SessionService(
            appleAuthService: appleAuthService,
            awsMobileClient: awsMobileClient,
            keychainManager: keychain
        )
        
        let status = sut.observe()
        let spy = StateSpy(publisher: status)
        
        XCTAssertEqual(spy.values, [.signedOut])
        XCTAssertEqual(awsMobileClient.signOutCalledCount, 1)
    }
    
    func test_fetchingSub_notSaved() {
        let appleAuthService = StubAppleAuthService(validUID: validUID)
        let awsMobileClient = StubAuthClient(value: .signedIn, sub: "aws.cognito.sub")
        let keychain = MockKeychain()
        
        sut = SessionService(
            appleAuthService: appleAuthService,
            awsMobileClient: awsMobileClient,
            keychainManager: keychain
        )
        
        let sub = sut.fetchSub()
        let spy = StateSpy(publisher: sub)
        
        XCTAssertEqual(spy.values, ["aws.cognito.sub"])
        XCTAssertEqual(awsMobileClient.getSubCalledCount, 1)
    }
    
    func test_fetchingSub_saved() {
        let appleAuthService = StubAppleAuthService(validUID: validUID)
        let awsMobileClient = StubAuthClient(value: .signedIn)
        let keychain = MockKeychain()
        
        sut = SessionService(
            appleAuthService: appleAuthService,
            awsMobileClient: awsMobileClient,
            keychainManager: keychain
        )
        
        keychain.setValue("aws.cognito.sub", forKey: "sub")
        let sub = sut.fetchSub()
        let spy = StateSpy(publisher: sub)
        
        XCTAssertEqual(spy.values, ["aws.cognito.sub"])
        XCTAssertEqual(awsMobileClient.getSubCalledCount, 0)
    }
    
    func test_observeSUB() {
        let appleAuthService = StubAppleAuthService(validUID: validUID)
        let awsMobileClient = StubAuthClient(value: .signedIn, sub: "aws.cognito.sub")
        let keychain = MockKeychain()
        keychain.setValue(validUID, forKey: "uid")
        
        sut = SessionService(
            appleAuthService: appleAuthService,
            awsMobileClient: awsMobileClient,
            keychainManager: keychain
        )
        
        let sub = sut.cognitoSUB.eraseToAnyPublisher()
        let spy = StateSpy(publisher: sub)
        
        XCTAssertEqual(awsMobileClient.getSubCalledCount, 1)
        XCTAssertEqual(spy.values, ["aws.cognito.sub"])
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
