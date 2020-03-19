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
        let events: [SectionType: [EventSummary]]
        
        var eventCount: Int {
            var count = 0
            self.events.forEach { $1.forEach { _ in count += 1 } }
            return count
        }
        
        var sectionHeaders: [String?] {
            return Array(events.keys).map { $0.header }
        }
        
        init(events: [SectionType: [EventSummary]] = [:]) {
            self.events = events
        }
    }
}
