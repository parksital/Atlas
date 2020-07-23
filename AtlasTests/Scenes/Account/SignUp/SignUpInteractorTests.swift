//
//  SignUpInteractorTests.swift
//  AtlasTests
//
//  Created by Parvin Sital on 23/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import XCTest

class SignUpInteractorTests: XCTestCase {
    private var sut: SignUpInteraction!

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
        sut = makeSUT(presenterSpy: spy)
        sut.viewDidFinishLoading()
        
        XCTAssertEqual(spy.presentViewCalledCount, 1)
    }
    
    func testSignUpWithApple() {
        let spy = PresenterSpy()
        sut = makeSUT(presenterSpy: spy)
        sut.signUpWithAppleID(authData: AppleAuthData.fixture())
        
        XCTAssertEqual(spy.presentSignUpSuccessCalledCount, 1)
    }
    
    func testDeinitInteractor() {
        sut = makeSUT()
        sut.signUpWithAppleID(authData: AppleAuthData.fixture())
        sut = nil
        XCTAssertNil(sut)
    }
}

private extension SignUpInteractorTests {
    func makeSUT(presenterSpy: SignUpPresentationLogic = PresenterSpy()) -> SignUpInteractor {
        let authService = AuthService(
            authClient: MockAuthClient(),
            keychain: MockKeychain()
        )
        
        return SignUpInteractor(
            authService: authService,
            presenter: presenterSpy
        )
    }
    
    private class PresenterSpy: SignUpPresentationLogic {
        var presentViewCalledCount: Int = 0
        var presentSignUpSuccessCalledCount: Int = 0
        
        func setup(viewController: SignUpDisplayLogic) { }
        
        func presentLoadingIndicator() { }
        
        func presentSuccessfulSignUp() {
            presentSignUpSuccessCalledCount += 1
        }
        
        func presentView() {
            presentViewCalledCount += 1
        }
    }
}
