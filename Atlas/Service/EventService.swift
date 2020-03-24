//
//  EventService.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

class EventService {
    private (set) var client: AWSClient?
    private (set) var decoder: JSONDecoder! = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    private var token: String?
    
    init(client: AWSClient? = AWSClient()) {
        self.client = client
    }
    
    #warning("TODO: - Refactor me")
    func fetchEventList(_ completion: @escaping (Result<[EventList.Response], Error>) -> Void) {
        let request = EventList.Request.init(token: token)
        client?.fetch(query: request.query) { (result) in
            switch result {
            case .failure(let error): assertionFailure(error.localizedDescription)
            case .success(let data):
                guard let items = data.eventsByStartDate?.items else {
                    assertionFailure("list events not found")
                    completion(.failure(NetworkError.noEvents))
                    return
                }
                
                let data = try! items
                    .compactMap { $0 }
                    .map { $0.jsonObject }
                    .filter(JSONSerialization.isValidJSONObject(_:))
                    .map { try JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted) }
                    .map { try self.decoder.decode(EventList.Response.self, from: $0) }
                completion(.success(data))
            }
        }
    }
    
    func fetchEvent(request: EventDetail.Request, _ completion: @escaping (Result<EventDetail.Response, Error>) -> Void) {
        client?.fetch(query: request.query) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                guard let event = data.getEvent else {
                    completion(.failure(NetworkError.noEvents))
                    return
                }
                
                if JSONSerialization.isValidJSONObject(event.jsonObject) {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: event.jsonObject, options: .prettyPrinted)
                        let eventDetails = try self.decoder.decode(EventDetail.Response.self, from: jsonData)
                        
                        completion(.success(eventDetails))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
