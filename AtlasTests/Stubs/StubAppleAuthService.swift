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
    
    init(validUID: String = "", initialState: AppleIDCredentialState = .notFound) {
        self.validUID = validUID
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
        return Just<Notification>(Notification(name: ASAuthorizationAppleIDProvider.credentialRevokedNotification))
            .eraseToAnyPublisher()
    }
}
