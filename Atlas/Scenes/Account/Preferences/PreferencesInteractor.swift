//
//  PreferencesInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
protocol PreferencesLogic {
    func viewDidFinishLoading()
    func wipeKeychainButtonTapped()
}

final class PreferencesInteractor: PreferencesLogic {
    
}

extension PreferencesInteractor {
    func viewDidFinishLoading() {
        
    }
    func wipeKeychainButtonTapped() {
        // present alert
    }
}
