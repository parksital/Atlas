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
    func observe() -> AnyPublisher<AuthStatus, AuthError>
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
                        self.status.send(.signedOut)
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
    
    
    func observe() -> AnyPublisher<AuthStatus, AuthError> {
        authClient.observe()
    }
}

class SessionServiceTests: XCTestCase {
    private var sut: SessionServiceProtocol!
    private var cancellabels: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellabels = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellabels.forEach({ $0.cancel() })
        cancellabels = nil
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
        
        XCTAssertEqual(sut.status.value, .signedOut)
        XCTAssertEqual(spy.values, [.unknown, .signedOut])
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
        
        XCTAssertEqual(spy.values, [.unknown, .signedOut])
        XCTAssertEqual(sut.status.value, .signedOut)
    }
    
    func testInit_appleAuth_revoked_clientSignedIn() {
        let authClient = MockAuthClient(existingUsers: ["david.appleid@domain.com"])
        sut = makeSUT(authClient: authClient)
        
        let p = sut.status.eraseToAnyPublisher()
        let spy = StateSpy(publisher: p)
        
        sut.initialize(uid: "")
        
        XCTAssertEqual(authClient.signOutCalledCount, 1)
        XCTAssertEqual(spy.values, [.unknown, .signedOut])
    }
    
    func testObservation_signIn() {
        let authClient = MockAuthClient(
            observedValues: [.unknown, .confirmed, .signedUp, .signedIn]
        )
        
        sut = makeSUT(authClient: authClient)
        let promise = expectation(description: "received all observed values")
        var result: [AuthStatus] = []
        
        sut.observe()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertEqual(result.count, 4)
                    promise.fulfill()
                default:
                    XCTFail()
                }
            }, receiveValue: { value in
                result.append(value)
            })
            .store(in: &cancellabels)
        
        wait(for: [promise], timeout: 1.5)
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
