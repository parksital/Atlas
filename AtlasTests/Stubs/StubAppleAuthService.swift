//
//  StubAppleAuthService.swift
//  AtlasTests
//
//  Created by Parvin Sital on 06/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine
import AuthenticationServices

final class StubAppleAuthService: AppleAuthServiceProtocol {
    private (set) var validUID: String
    private (set) var revoke: Bool
    
    init(
        validUID: String = "",
        initialState: AppleIDCredentialState = .notFound,
        revoke: Bool = false
    ) {
        self.validUID = validUID
        self.revoke = revoke
    }
    
    func checkAppleIDAuthStatus(
        forUID uid: String?
    ) -> Future<AppleIDCredentialState, AuthError> {
        return Future<AppleIDCredentialState, AuthError> { [unowned self] promise in
            if uid == self.validUID {
                promise(.success(.authorized))
            } else {
                promise(.success(.notFound))
            }
        }
    }
    
    func observeAppleIDRevocation() -> AnyPublisher<Notification, Never> {
        return Future<Notification, Never>({ [weak self] promise in
            guard let self = self else { return }
            if self.revoke {
                promise(.success(Notification(name: ASAuthorizationAppleIDProvider.credentialRevokedNotification)))
            }
        }).eraseToAnyPublisher()
    }
}
