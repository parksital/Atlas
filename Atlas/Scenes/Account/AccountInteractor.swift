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
}

protocol AccountDataStore {
    
}

typealias AccountInteraction = AccountLogic & AccountDataStore
final class AccountInteractor: AccountDataStore {
    private let presenter: AccountPresentationLogic!
    private let profileService: ProfileService!
    private var cancellables = Set<AnyCancellable>()
    
    init(profileService: ProfileService, presenter: AccountPresentationLogic) {
        self.profileService = profileService
        self.presenter = presenter
    }
    
    deinit { cancellables.forEach({ $0.cancel() }) }
}

private extension AccountInteractor {

}

extension AccountInteractor: AccountLogic {
    func viewDidFinishLoading() {
        profileService.getCurrentUser()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: print("finished")
                case .failure(let error): assertionFailure(error.localizedDescription)
                }
            }, receiveValue: { user in
                print(user.id)
            })
            .store(in: &cancellables)
    }
    
    func goToSignUp() {
        presenter.goToSignUp()
    }
}
