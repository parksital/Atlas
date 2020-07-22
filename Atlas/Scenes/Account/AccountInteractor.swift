//
//  AccountInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 07/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

protocol AccountLogic: class {
    func viewDidFinishLoading()
    func goToSignUp()
    func didSelectItem(atIndex index: IndexPath)
}

protocol AccountDataStore {
    var settings: [AccountSetting] { get }
    var selectedSetting: AccountSetting? { get }
}

typealias AccountInteraction = AccountLogic & AccountDataStore
final class AccountInteractor: AccountDataStore {
    private let presenter: AccountPresentationLogic!
    private let profileService: ProfileService!
    private (set) var settings: [AccountSetting] = AccountSetting.allCases
    private (set) var selectedSetting: AccountSetting?
    private var cancellables = Set<AnyCancellable>()
    
    init(profileService: ProfileService, presenter: AccountPresentationLogic) {
        self.profileService = profileService
        self.presenter = presenter
    }
    
    deinit { cancellables.forEach({ $0.cancel() }) }
}

private extension AccountInteractor {
    func observe() {
    }
    
    func getUser() {
    
    }
    
    func presentSettings() {
        presenter.presentSettings(settings)
    }
}

extension AccountInteractor: AccountLogic {
    func viewDidFinishLoading() {
        observe()
        presentSettings()
    }
    
    func goToSignUp() {
        presenter.goToSignUp()
    }
    
    func didSelectItem(atIndex index: IndexPath) {
        guard
            index.section > 0,
            index.row >= 0,
            index.row < settings.count
            else { return }
        
        selectedSetting = settings[index.row]
        presenter.presentSelectedSetting()
    }
}
