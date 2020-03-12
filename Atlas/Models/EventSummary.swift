//
//  EventSummary.swift
//  Atlas
//
//  Created by Parvin Sital on 04/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

struct EventSummary {
    let id: String
    let title: String
    let startDate: Date
    let venue: String
}

extension EventSummary: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case startDate = "start_date"
        case venue
        
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
        venue = try venueContainer.decode(String.self, forKey: .name)
    }
}
