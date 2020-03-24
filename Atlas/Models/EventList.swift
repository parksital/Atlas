//
//  EventList.swift
//  Atlas
//
//  Created by Parvin Sital on 19/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum EventList {
    struct Request {
        private var token: String?
        var query: ListEventsSummarizedByStartDateQuery {
            ListEventsSummarizedByStartDateQuery(
                type: "Event",
                sortDirection: .asc,
                limit: 30,
                nextToken: token
            )
        }
        
        init(token: String?) {
            self.token = token
        }
    }
    
    struct Response {
        let id: String
        let title: String
        let startDate: Date
        let venue: String
    }
    
    struct ViewModel {
        let events: [String: [EventSummary]]
        // headers are stored in a separate array to maintain order
        let sectionHeaders: [String]
        
        var eventCount: Int {
            var count = 0
            self.events.forEach { $1.forEach { _ in count += 1 } }
            return count
        }

        init(events: [String: [EventSummary]] = [:], sectionHeaders: [String] = []) {
            self.events = events
            self.sectionHeaders = sectionHeaders
        }
    }
}

extension EventList.ViewModel {
    func eventsForSection(_ section: Int) -> [EventSummary] {
        guard section < sectionHeaders.count else { return [] }
        let header = sectionHeaders[section]
        let output = events[header] ?? []
        return output
    }
}

extension EventList.Response: Decodable {
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

extension EventList.Response: Equatable { }
