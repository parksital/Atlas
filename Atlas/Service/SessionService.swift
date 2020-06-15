//
//  SessionService.swift
//  Atlas
//
//  Created by Parvin Sital on 11/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AuthenticationServices
import Combine

final class SessionService {
    private let appleAuthService: AppleAuthService!
    private let awsMobileClient: AuthClientProtocol!
    private (set) var status = CurrentValueSubject<AWSAuthState, AuthError>(.unknown)
    private (set) var cognitoSUB = CurrentValueSubject<String?, AuthError>(nil)
    
    private var uid: String? {
        KeychainWrapper.standard.string(forKey: "uid")
    }
    
    private var sub: String? {
        KeychainWrapper.standard.string(forKey: "sub")
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(appleAuthService: AppleAuthService, awsMobileClient: AuthClientProtocol) {
        self.appleAuthService = appleAuthService
        self.awsMobileClient = awsMobileClient
    }
    
    deinit { cancellables.forEach { $0.cancel() } }
}

extension SessionService {
    func initialize() {
        setupInitialization()
        setupAuthObserver()
        setupSUBObserver()
    }
}

private extension SessionService {
    func setupInitialization() {
        awsMobileClient.initialize()
            .merge(with: awsMobileClient.observe())
            .subscribe(status)
            .store(in: &cancellables)
    }
    
    func setupAuthObserver() {
        appleAuthService.checkAppleIDAuthStatus(forUID: self.uid)
            .allSatisfy({ $0 == .authorized })
            .zip(status)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] appleAuth, awsAuth in
                    guard let self = self else { return }
                    if appleAuth {
                        self.handleAWSAuthState(awsAuth)
                    } else {
                        self.revokeAWSCredentials()
                        self.wipeKeychain()
                    }
            })
            .store(in: &cancellables)
    }
    
    func setupSUBObserver() {
        status
            .filter({ $0 == .signedIn })
            .flatMap({ [weak self] _ in self!.fetchSub() })
            .subscribe(cognitoSUB)
            .store(in: &cancellables)
    }
    
    func handleAWSAuthState(_ authState: AWSAuthState) -> Void {
        switch authState {
        case .signedOut, .expiredToken: // sign back in
            print("apple auth success -> aws auth sign fail")
            default: break
        }
    }
    
    func fetchSub() -> AnyPublisher<String?, AuthError> {
        guard let sub = self.sub else {
            return awsMobileClient.getCognitoSUB()
                .eraseToAnyPublisher()
        }
        
        return Just<String?>(sub)
            .setFailureType(to: AuthError.self)
            .eraseToAnyPublisher()
    }
    
    func getAWSCredentials() -> (String, String) {
        let email = KeychainWrapper.standard.string(forKey: "email")!
        let password = KeychainWrapper.standard.string(forKey: "password")!
        return (email, password)
    }
    
    func revokeAWSCredentials() {
        awsMobileClient.signOut()
    }
    
    func wipeKeychain() {
        _ = KeychainWrapper.standard.removeAllKeys()
    }
}
