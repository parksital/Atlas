//
//  ProfileService.swift
//  Atlas
//
//  Created by Parvin Sital on 20/05/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

final class ProfileService {
    private let sessionService: SessionService!
    private let client: APIClientProtocol!
    
    init(sessionService: SessionService, client: APIClientProtocol) {
        self.sessionService = sessionService
        self.client = client
    }
}

private extension ProfileService {
    
}
