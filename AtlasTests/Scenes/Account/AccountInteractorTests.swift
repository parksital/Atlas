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
    
    func testPresentUser_afterSignIn() {
        let presenter = PresenterSpy()
        sut = makeSUT(
            presenter: presenter,
            sessionService: .fixture(signedIn: true),
            profileService: .fixture()
        )
        
        sut.viewDidFinishLoading()
        
        XCTAssertNil(presenter.error)
        XCTAssertEqual(presenter.presentUserCalled, 1)
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
        var presentUserCalled: Int = 0
        var error: Error?
        
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
        
        func presentError(_ error: Error) {
            self.error = error
        }
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

extension XCTest {
    func expectToEventually(
        _ test: @autoclosure () -> Bool,
        timeout: TimeInterval = 1.0,
        message: String = ""
    ) {
        let runLoop = RunLoop.current
        let timeoutDate = Date(timeIntervalSinceNow: timeout)
        repeat {
            
            if test() {
                return
            }
            
            runLoop.run(until: Date(timeIntervalSinceNow: 0.01))
        } while Date().compare(timeoutDate) == .orderedAscending
        
        XCTFail(message)
    }
}
