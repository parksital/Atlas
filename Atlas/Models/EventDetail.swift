//
//  EventDetails.swift
//  Atlas
//
//  Created by Parvin Sital on 12/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum EventDetail {
    struct Request {
        private var id: String
        var query: GetEventQuery { GetEventQuery(id: id) }
        
        init(id: String) {
            self.id = id
        }
    }
    struct Response {
        let id: String
        let title: String
        let startDate: Date
        let endDate: Date
        let venue: String
        let description: String?
    }
    
    struct ViewModel {
        let id: String
        let title: String
        let startDate: String
        let venue: String
        let description: String?
    }
}

extension EventDetail.Response: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case startDate = "start_date"
        case endDate = "end_date"
        case venue
        case description
        
        enum VenueKeys: String, CodingKey {
            case name
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let venueContainer = try container.nestedContainer(keyedBy: CodingKeys.VenueKeys.self, forKey: .venue)

        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        venue = try venueContainer.decode(String.self, forKey: .name)
        description = try container.decode(String?.self, forKey: .description)
    }
}
