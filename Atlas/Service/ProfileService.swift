//
//  ProfileService.swift
//  Atlas
//
//  Created by Parvin Sital on 20/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

final class ProfileService {
    private let authClient: AuthClientProtocol!
    private let client: APIClientProtocol!
    private var cancellables = Set<AnyCancellable>()
    
    init(authClient: AuthClientProtocol, client: APIClientProtocol) {
        self.authClient = authClient
        self.client = client
    }
    
    deinit { cancellables.forEach({ $0.cancel() }) }
    
}

private extension ProfileService {
    
}

extension ProfileService {
    func getCurrentUser() {
        authClient.getUID()
            .sink(receiveValue: { uid in print(uid) })
            .store(in: &cancellables)
    }
}
