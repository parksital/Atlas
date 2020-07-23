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
    
    func testViewDidFinishLoading_called() {
        let spy = PresenterSpy()
        sut = makeSUT(presenter: spy)
        sut.viewDidFinishLoading()
        XCTAssertEqual(spy.presentSettingsCalled, 1)
    }
    
    func testObserveSession_notSignedIn() {
        let sessionService = SessionService(
            appleAuthService: AppleAuthService.fixture(),
            authClient: MockAuthClient(),
            keychain: MockKeychain()
        )
        
        let spy = PresenterSpy()
        sut = makeSUT(presenter: spy, sessionService: sessionService)
        
        sut.viewDidFinishLoading()
        XCTAssertNil(sut.user)
        XCTAssertEqual(spy.presentUnAuthViewCalled, 1)
    }
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
        
        func setup(viewController: AccountDisplayLogic) { }
        
        func presentUnAuthView() {
            presentUnAuthViewCalled += 1
        }
        
        func presentUser(_ user: User) {
            
        }
        
        func presentSettings(_ settings: [AccountSetting]) {
            presentSettingsCalled += 1
        }
        
        func goToSignUp() { }
        
        func presentSelectedSetting() { }
    }
}

extension ProfileService {
    static func fixture() -> ProfileService {
        ProfileService(
            client: AWSClient(appSyncClient: MockAPIClient())
        )
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
