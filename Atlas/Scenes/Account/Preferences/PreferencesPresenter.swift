//
//  PreferencesPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol PreferencesPresentationLogic {
    func presentAlert()
}

final class PreferencesPresenter {
    private weak var viewController: PreferencesDisplayLogic?
}

extension PreferencesPresenter: PreferencesPresentationLogic {
    func presentAlert() {
        viewController?.displayAlert()
    }
}
