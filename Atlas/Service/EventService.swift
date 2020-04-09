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
    
    func fetchEventList() -> Future<GetEventList, Error> {
        return client.fetch(query: EventList.Request(token: token))
    }
    
    func fetchEvent(request: EventDetail.Request, _ completion: @escaping (Result<EventDetail.Response, Error>) -> Void) {
//        client?.fetch(query: request.query) { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let data):
//                guard let event = data.getEvent else {
//                    completion(.failure(NetworkError.noEvents))
//                    return
//                }
//
//                if JSONSerialization.isValidJSONObject(event.jsonObject) {
//                    do {
//                        let jsonData = try JSONSerialization.data(withJSONObject: event.jsonObject, options: .prettyPrinted)
//                        let eventDetails = try self.decoder.decode(EventDetail.Response.self, from: jsonData)
//
//                        completion(.success(eventDetails))
//                    } catch {
//                        completion(.failure(error))
//                    }
//                }
//            }
//        }
    }
}
