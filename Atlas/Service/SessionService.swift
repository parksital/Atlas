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
    private var uid: String? {
        KeychainWrapper.standard.string(forKey: "uid")
    }
    var sub: String? {
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
        awsMobileClient.initialize()
            .merge(with: awsMobileClient.observe())
            .subscribe(status)
            .store(in: &cancellables)
        
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
    
    func getUID() -> AnyPublisher<String, AuthError> {
        return status
            .filter({ $0 == .signedIn })
            .flatMap { [unowned self] _ in self.awsMobileClient.getCognitoSUB() }
            .eraseToAnyPublisher()
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
