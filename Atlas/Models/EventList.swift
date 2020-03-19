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
        let events: [EventSummary]
        let sections: [SectionType]

        init(events: [EventSummary] = [], sections: [SectionType] = []) {
            self.events = events
            self.sections = sections
        }
    }
}
