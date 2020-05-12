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

final class AppleAuthService {
    typealias AppleIDCredentialState = ASAuthorizationAppleIDProvider.CredentialState
    
    func checkAppleIDAuthStatus(forUID uid: String?) -> Future<AppleIDCredentialState, Error> {
        return Future<AppleIDCredentialState, Error> { promise in
            guard uid != nil else {
                promise(.success(.notFound))
                return
            }
            
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: uid!) { credentialState, error in
                guard error == nil else { return }
                promise(.success(credentialState))
            }
        }
    }
    
    func observeAppleIDAuthRevocation(revocationHandler: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(
            forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
            object: self,
            queue: OperationQueue.current,
            using: revocationHandler
        )
    }
}

final class SessionService {
    private let appleAuthService: AppleAuthService!
    private let awsMobileClient: AuthClientProtocol!
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
        // grab auth type and uid
        
        // start observing with awsMobileClient
        awsMobileClient.initialize()
        
        appleAuthService.checkAppleIDAuthStatus(forUID: self.uid)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] status in
                    guard let self = self else { return }
                    switch status {
                    case .revoked:
                        _ = self.wipeKeychain()
                        self.revokeAWSCredentials()
                        //
                    case .notFound:
                        _ = self.wipeKeychain()
                        self.revokeAWSCredentials()
                        //
                    case .authorized:
                        // carry on to verify awsCredentials
                        break
                    default: break
                    }
            })
            .store(in: &cancellables)
    }
}

private extension SessionService {
    func revokeAWSCredentials() {
        awsMobileClient.signOut()
    }
    
    func wipeKeychain() -> Bool {
        KeychainWrapper.standard.removeAllKeys()
    }
}
