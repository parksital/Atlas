//
//  AppleAuthService.swift
//  Atlas
//
//  Created by Parvin Sital on 22/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import AuthenticationServices
import Combine

final class AppleAuthService: AppleAuthServiceProtocol {
    private let appleIDProvider: AppleIDProviderProtocol!
    
    init(appleIDProvider: AppleIDProviderProtocol) {
        self.appleIDProvider = appleIDProvider
    }
    
    func checkAppleIDCredentials(forUID uid: String?) -> Future<AppleIDCredentialState, Error> {
        Future<AppleIDCredentialState, Error> { [appleIDProvider] promise in
            guard let id = uid else {
                promise(.success(.notFound))
                return
            }
            
            appleIDProvider?.getCredentialState(forUserID: id) { (state, error) in
                guard error == nil else {
                    promise(.failure(error!))
                    return
                }
                promise(.success(state))
            }
        }
    }
    
    func observeAppleIDRevocation() -> AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)
            .eraseToAnyPublisher()
    }
}

extension AppleAuthService {
    static func fixture() -> AppleAuthService {
        AppleAuthService(appleIDProvider: MockAppleIDProvider())
    }
}
