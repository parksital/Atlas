//
//  AppleAuthService.swift
//  Atlas
//
//  Created by Parvin Sital on 13/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AuthenticationServices
import Combine

typealias AppleIDCredentialState = ASAuthorizationAppleIDProvider.CredentialState
final class AppleAuthService {
    
    func checkAppleIDAuthStatus(forUID uid: String?) -> Future<AppleIDCredentialState, AuthError> {
        return Future<AppleIDCredentialState, AuthError> { promise in
            guard uid != nil else {
                promise(.failure(.noAppleUID))
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
