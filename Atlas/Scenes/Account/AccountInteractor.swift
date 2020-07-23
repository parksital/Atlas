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
    var user: User? { get }
    var settings: [AccountSetting] { get }
    var selectedSetting: AccountSetting? { get }
}

typealias AccountInteraction = AccountLogic & AccountDataStore
final class AccountInteractor: AccountDataStore {
    private let presenter: AccountPresentationLogic!
    private let sessionService: SessionServiceProtocol!
    private let profileService: ProfileService!
    
    private (set) var user: User?
    private (set) var settings: [AccountSetting] = AccountSetting.allCases
    private (set) var selectedSetting: AccountSetting?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        presenter: AccountPresentationLogic,
        sessionService: SessionServiceProtocol,
        profileService: ProfileService
    ) {
        self.presenter = presenter
        self.sessionService = sessionService
        self.profileService = profileService
    }
    
    deinit { cancellables.forEach({ $0.cancel() }) }
}

private extension AccountInteractor {
    func observe() {
        sessionService.initialize()
        
        sessionService.status
            .append(sessionService.observe())
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [unowned self] authStatus in
                    guard authStatus == .signedIn else {
                        self.presenter.presentUnAuthView()
                        return
                    }
                    self.getUser()
            })
            .store(in: &cancellables)
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
