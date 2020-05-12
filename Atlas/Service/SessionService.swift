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
    typealias AppleIDCredentialState = ASAuthorizationAppleIDProvider.CredentialState
    
    private var uid: String? {
        return KeychainWrapper.standard.string(forKey: "uid")
    }
    
    private (set) var status = PassthroughSubject<AppleIDCredentialState, Error>()
    private var cancellables = Set<AnyCancellable>()
    
    deinit { cancellables.forEach { $0.cancel() } }
    
    func initialize() {
        checkAppleIDAuthStatus(forUID: self.uid).print()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { print("apple credential state: ", $0.rawValue) })
            .store(in: &cancellables)
    }
    
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
