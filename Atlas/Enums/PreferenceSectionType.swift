//
//  PreferenceSectionType.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum PreferenceSectionType: Int, CaseIterable {
    case preferences
}

enum PreferenceItem: Hashable {
    case wipeKeychain(Bool?)
}
