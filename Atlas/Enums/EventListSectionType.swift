//
//  SectionType.swift
//  Atlas
//
//  Created by Parvin Sital on 19/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum EventListSectionType {
    case tonight
    case tomorrow
    case date(String?)
    
    var header: String? {
        switch self {
        case .tonight: return "Tonight"
        case .tomorrow: return "Tomorrow"
        case .date(let custom):
            guard
                let date = custom,
                !date.isEmpty else { return nil }
            return date
        }
    }
}

extension EventListSectionType: Equatable { }
extension EventListSectionType: Hashable { }
