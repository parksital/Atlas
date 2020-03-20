//
//  EventList.swift
//  Atlas
//
//  Created by Parvin Sital on 19/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum EventList {
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
