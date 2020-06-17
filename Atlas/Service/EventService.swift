//
//  EventService.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

class EventService {
    private (set) var client: APIClientProtocol!
    private (set) var decoder: JSONDecoder! = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    private var token: String?
    
    init(client: APIClientProtocol) {
        self.client = client
    }
    
    func events() -> AnyPublisher<[EventItem], Error> {
        let f: Future<GetEventList, Error> = client.fetch(query: EventList.Request(token: token))
        
        return f
            .map({ $0.eventSummaryList.eventItems })
            .eraseToAnyPublisher()
    }
    
    func event(byID id: String) -> Future<GetEvent, Error> {
        return client.fetch(query: EventDetail.Request(id: id))
    }
}
