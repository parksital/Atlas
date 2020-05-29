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
    private (set) var status = PassthroughSubject<AWSAuthState, AuthError>()
    private var uid: String? {
        KeychainWrapper.standard.string(forKey: "uid")
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
        appleAuthService.checkAppleIDAuthStatus(forUID: self.uid)
            .map({ $0 == .authorized })
            .zip(awsMobileClient.initialize())
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
    
    func observe() {
        awsMobileClient.observe()
            .subscribe(status)
            .store(in: &cancellables)
    }
}

private extension SessionService {
    func handleAWSAuthState(_ authState: AWSAuthState) -> Void {
        switch authState {
        case .signedOut, .expiredToken: // sign back in
            print("apple auth success -> aws auth sign fail")
            default: break
        }
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
