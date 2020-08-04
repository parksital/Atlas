//
//  AccountSectionType.swift
//  Atlas
//
//  Created by Parvin Sital on 22/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum AccountSectionType: Int, CaseIterable {
    case userProfileSection
    case settingsSection
}

enum AccountItem: Hashable {
    case noProfile
    case profile(User)
    case setting(AccountSetting)
    
    init(user: User?) {
        guard let profile = user else {
            self = .noProfile
            return
        }
        self = .profile(profile)
    }
    
    init(setting: AccountSetting) {
        self = .setting(setting)
    }
}

enum AccountSetting: String, CaseIterable {
    case myTickets
    case savedEvents
    case history
    case preferences
    
    
    var localized: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
}
