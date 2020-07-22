//
//  AppleAuthServiceProtocol.swift
//  Atlas
//
//  Created by Parvin Sital on 22/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine
import AuthenticationServices

typealias AppleIDCredentialState = ASAuthorizationAppleIDProvider.CredentialState
protocol AppleAuthServiceProtocol {
    func checkAppleIDCredentials(forUID uid: String?) -> Future<AppleIDCredentialState, Error>
    func observeAppleIDRevocation() -> AnyPublisher<Notification, Never>
}
