//
//  AppleAuthData.swift
//  Atlas
//
//  Created by Parvin Sital on 29/04/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

struct AppleAuthData {
    let uid: String
    let email: String
    let fullName: PersonNameComponents
    let token: String
    
    var firstName: String {
        fullName.givenName!
    }
    
    var lastName: String {
        fullName.familyName!
    }
}
