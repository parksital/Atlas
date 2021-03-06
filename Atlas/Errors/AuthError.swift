//
//  AuthError.swift
//  Atlas
//
//  Created by Parvin Sital on 22/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum AuthError: Error {
    case generic
    case existingEmail
    case emailNotFound
    case uidNotFound
    case attributesError(Error)
    case appleIDError(Error)
    case decoding(Error)
}
