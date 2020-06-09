//
//  AuthStatus.swift
//  Atlas
//
//  Created by Parvin Sital on 29/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum AWSAuthState: String {
    case unknown
    case signedOut
    case signedIn
    case confirmed
    case expiredToken
}
