//
//  EventService.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol APIClient {
    
}

protocol EventFetching {
    var client: APIClient! { get }
}

final class EventService: EventFetching {
    private (set) var client: APIClient!
    
    init(client: APIClient) {
        self.client = client
    }
    
}
