//
//  AccountSectionType.swift
//  Atlas
//
//  Created by Parvin Sital on 22/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum AccountSectionType: Int {
    case userProfileSection
    case settingsSection
}

extension AccountSectionType: CaseIterable { }

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

enum AccountSetting: String {
    case myTickets
    case savedEvents
    case history
    case preferences
}

extension AccountSetting: CaseIterable { }
