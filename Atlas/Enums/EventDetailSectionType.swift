//
//  EventDetailSectionType.swift
//  Atlas
//
//  Created by Parvin Sital on 04/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum EventDetailSectionType: Int {
    case header
    case description
    case artists
    case admission
    case map
}

extension EventDetailSectionType: CaseIterable { }

extension EventDetailSectionType: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
}

struct EventDetailItem {
    let section: EventDetailSectionType
    let item: EventDetail.ViewModel
}

extension EventDetailItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.section)
        hasher.combine(self.item)
    }
}
