//
//  EventService.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

final class EventService {
    private (set) var client: AWSClient!
    private (set) var decoder: JSONDecoder! = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    init(client: AWSClient = AWSClient()) {
        self.client = client
    }
    
    func fetchEventsSummarized(_ completion: @escaping (Result<[EventSummary], Error>) -> Void) {
        client.fetch(query: ListEventsSummarizedQuery()) { result in
            switch result {
            case .failure(let error): assertionFailure(error.localizedDescription)
            case .success(let data):
                guard let items = data.listEvents?.items else {
                    assertionFailure("list events not found")
                    completion(.failure(NetworkingError.noListEvents))
                    return
                }
                
                let data = try! items
                    .compactMap { $0 }
                    .map { $0.jsonObject }
                    .filter(JSONSerialization.isValidJSONObject(_:))
                    .map { try JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted) }
                    .map { try self.decoder.decode(EventSummary.self, from: $0) }
                
                completion(.success(data))
            }
        }
    }
}
