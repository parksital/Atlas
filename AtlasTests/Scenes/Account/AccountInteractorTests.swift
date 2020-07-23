//
//  AccountInteractorTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 23/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

class AccountInteractorTests: XCTestCase {
    private var sut: AccountInteraction!
    
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
        sut.viewDidFinishLoading()
        sut = nil
        XCTAssertNil(sut)
    }
    
    func testViewDidFinishLoading_called() {
        let spy = PresenterSpy()
        sut = makeSUT(presenter: spy)
        sut.viewDidFinishLoading()
        XCTAssertEqual(spy.presentSettingsCalled, 1)
    }
    
    func testObserveSession_notSignedIn() {
        let spy = PresenterSpy()
        sut = makeSUT(
            presenter: spy,
            sessionService: .fixture()
        )
        
        sut.viewDidFinishLoading()
        XCTAssertNil(sut.user)
        XCTAssertEqual(spy.presentUnAuthViewCalled, 1)
    }
    
//    func testObservationSession_signedIn() {
//        let authData = AppleAuthData.fixture()
//        let authClient = MockAuthClient(existingUsers: [authData.email])
//
//        let keychain = MockKeychain()
//        keychain.setValue(authData.uid, forKey: "uid")
//
//        let sessionService = SessionService(
//            appleAuthService: AppleAuthService.fixture(),
//            authClient: authClient,
//            keychain: keychain
//        )
//
//        let spy = PresenterSpy()
//        sut = makeSUT(
//            presenter: spy,
//            sessionService: sessionService,
//            profileService: .fixture()
//        )
//
//        sut.viewDidFinishLoading()
//
//        XCTAssertEqual(spy.presentUserCalled, 1)
//    }
    
//    func testStatusObservation_signIn() {
//        let authClient = MockAuthClient(
//            observedValues: [.unknown, .confirmed, .signedUp, .signedIn]
//        )
//
//        sut = makeSUT(authClient: authClient)
//        let promise = expectation(description: "received all observed values")
//        var result: [AuthStatus] = []
//
//        sut.observe()
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    XCTAssertEqual(result.count, 4)
//                    promise.fulfill()
//                default:
//                    XCTFail()
//                }
//            }, receiveValue: { value in
//                result.append(value)
//            })
//            .store(in: &cancellables)
//
//        wait(for: [promise], timeout: 1.5)
//    }
}

private extension AccountInteractorTests {
    func makeSUT(
        presenter: AccountPresentationLogic = PresenterSpy(),
        sessionService: SessionService = .fixture(),
        profileService: ProfileService = .fixture()
    ) -> AccountInteractor {
        AccountInteractor(
            presenter: presenter,
            sessionService: sessionService,
            profileService: profileService
        )
    }
    
    private class PresenterSpy: AccountPresentationLogic {
        var presentSettingsCalled: Int = 0
        var presentUnAuthViewCalled: Int = 0
        var presentUserCalled: Int = 0
        
        func setup(viewController: AccountDisplayLogic) { }
        
        func presentUnAuthView() {
            presentUnAuthViewCalled += 1
        }
        
        func presentUser(_ user: User) {
            presentUserCalled += 1
        }
        
        func presentSettings(_ settings: [AccountSetting]) {
            presentSettingsCalled += 1
        }
        
        func goToSignUp() { }
        
        func presentSelectedSetting() { }
    }
}

extension SessionService {
    static func fixture() -> SessionService {
        SessionService(
            appleAuthService: AppleAuthService(
                appleIDProvider: MockAppleIDProvider()),
            authClient: MockAuthClient(),
            keychain: MockKeychain()
        )
    }
}
