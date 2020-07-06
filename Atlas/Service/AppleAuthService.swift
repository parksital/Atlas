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

protocol AppleAuthServiceProtocol: class {
    func checkAppleIDAuthStatus(forUID uid: String?) -> Future<AppleIDCredentialState, AuthError>
    func observeAppleIDRevocation() -> AnyPublisher<Notification, Never>
}

typealias AppleIDCredentialState = ASAuthorizationAppleIDProvider.CredentialState
final class AppleAuthService {
    
    func checkAppleIDAuthStatus(forUID uid: String?) -> Future<AppleIDCredentialState, AuthError> {
        return Future<AppleIDCredentialState, AuthError> { promise in
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
    
    func observeAppleIDRevocation() -> AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)
            .eraseToAnyPublisher()
    }
}
